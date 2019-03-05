//
//  SearchVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SearchVC.h"

#import "CustomSearchNavView.h"     // 导航栏视图
#import "HistoryHeader.h"           // 搜索列表头视图
#import "HistoryCell.h"             // 搜索列表的item
#import "SearchVCData.h"            // 搜索页数据
#import "SearchDetailVC.h"          // 搜索结果控制器

static NSString *identifier = @"HistoryCell";
static NSString *HeaderIdentifier = @"HistoryHeaderCell";

@interface SearchVC () <CustomSearchNavViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, SearchVCDataDelegate>

@property (nonatomic, strong) CustomSearchNavView *navView;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) SearchVCData *data;

@end

@implementation SearchVC

// 懒加载
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y) collectionViewLayout:layout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.alwaysBounceVertical = YES;
        _collection.bounces = NO;
        _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collection registerClass:[HistoryCell class] forCellWithReuseIdentifier:identifier];
        [_collection registerClass:[HistoryHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
        _collection.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collection.backgroundColor = [UIColor clearColor];
    }
    return _collection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[SearchVCData alloc]init];
    self.data.delegate = self;
    [self.data requestHotSearchData];
    
    [self SearchVCLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navView.searchBar.text = nil;
    [self.data updateHistoryData];
    [self.collection reloadData];
}

#pragma mark - SearchVCDataDelegate
// 热门搜索
- (void)SearchVCData_HotSearchRequest_Success {
    NSLog(@"下载热门搜索成功");
    [self.collection reloadData];
}
- (void)SearchVCData_HotSearchRequest_Fail:(NSError *)error {
    NSLog(@"热门下载 er = %@",error);
}
// 标签搜索
- (void)SearchVCData_TagSearchRequest_Success {
    NSLog(@"标签搜索成功");
    [self.collection reloadData];
}
- (void)SearchVCData_TagSearchRequest_Fail:(NSError *)error {
    NSLog(@"标签搜索 er = %@",error);
}


#pragma mark - CustomSearchNavViewDelegate
// 点击取消按钮
- (void)CustomSearchNavViewClickedRightItem {
    [self.navigationController popViewControllerAnimated:NO];
}
// 点击键盘搜索
- (void)CustomSearchNavViewSearchWith:(NSString *)text {
    NSLog(@"text = %@",text);
    [self searchWith:text];
}

#pragma mark - 搜索
- (void)searchWith:(NSString *)text {
    NSLog(@"搜索 = %@",text);
    [self.data addHistoryData:text];

    SearchDetailVC *vc = [[SearchDetailVC alloc]init];
    vc.index = 1;
    vc.SearchText = text;
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;         //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromLeft; //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - 页面布局
- (void)SearchVCLayout {
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 导航视图
    self.navView = [[CustomSearchNavView alloc]init];
    self.navView.delegate = self;
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.index = 1;
    [self.view addSubview:self.navView];
    
    // 搜索历史和热门搜索的集合视图
    [self.view addSubview:self.collection];
}

#pragma mark - 删除搜索历史
- (void)DeleteMethod:(UIButton *)sender {
    [self.data deleteHistoryData];
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"SearchHistoty_4", nil)];
    [self.collection reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.data numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data numberOfRowsWithSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleLab.text = [self.data StringWithIndexPath:indexPath];
    return cell;
}
//设置页眉
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HistoryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        header.titleLab.text = NSLocalizedString(@"SearchHistoty_2", nil);
        header.deleButton.hidden = NO;
        [header.deleButton addTarget:self action:@selector(DeleteMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        header.titleLab.text = NSLocalizedString(@"SearchHistoty_3", nil);
        header.deleButton.hidden = YES;
    }
    return header;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data StringWithIndexPath:indexPath];
    [self searchWith:text];
}
//头尾视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat w = collectionView.frame.size.width;
    CGFloat h = 44;
    return CGSizeMake(w, h);
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data StringWithIndexPath:indexPath];;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:13]}];
    return  CGSizeMake(size.width + 44, 45);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);//上 左 下 右
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
// 在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
