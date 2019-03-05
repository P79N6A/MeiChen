//
//  AllMenuVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AllMenuVC.h"

#import "CustomSearchDetailNavView.h"   // 导航栏
#import "HistoryHeader.h"               // 搜索列表头视图
#import "HistoryCell.h"                 // 搜索列表的item
#import "AllMenuData.h"                 // 菜单页数据
#import "TypeTabCell.h"                 // 表视图cell
#import "SearchDetailVC.h"              // 搜索结果控制器

static NSString *identifier = @"TypeCell";
static NSString *HeaderIdentifier = @"TypeHeaderCell";

@interface AllMenuVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CustomSearchDetailNavViewDelegate, AllMenuDataDelegate> {
}
@property (nonatomic, strong) CustomSearchDetailNavView *navView;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) AllMenuData *data;

@end

@implementation AllMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[AllMenuData alloc]init];
    self.data.delegate = self;
    [self.data requestAllMenu];
    
    [self BuildUI];
}


#pragma mark - AllMenuDataDelegate
// 分类菜单请求
- (void)AllMenuData_requestSuccess {
    NSLog(@"分类菜单请求 成功");
    [self.tabView reloadData];
    [self.collView reloadData];
}
- (void)AllMenuData_requestFail:(NSError *)error {
    NSLog(@"分类菜单请求 失败");
}

#pragma mark - CustomSearchDetailNavViewDelegate
// 点击返回按钮
- (void)CustomSearchDetailNavView_ClickedBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)BuildUI {
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    // 导航栏
    self.navView = [[CustomSearchDetailNavView alloc]init];
    self.navView.delegate = self;
    self.navView.index = 2;
    self.navView.titleLab.text = NSLocalizedString(@"TypeVC_1", nil);
    [self.view addSubview:self.navView];
    
    CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, 90, CGRectGetHeight(self.view.frame) - y) style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tag = 0;
    self.tabView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabView.bounces = NO;
    [self.view addSubview:self.tabView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tabView.frame), y, self.view.frame.size.width - y, self.view.frame.size.height - y) collectionViewLayout:layout];
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.alwaysBounceVertical = YES;
    _collView.bounces = NO;
    _collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collView registerClass:[HistoryCell class] forCellWithReuseIdentifier:identifier];
    [_collView registerClass:[HistoryHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    _collView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data numOfTabRows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    TypeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TypeTabCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = [self.data TitleWithTabRow:indexPath.row];
    [cell didSelectWithRow:indexPath.row tag:tableView.tag];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tag = indexPath.row;
    [self.tabView reloadData];
    [self.tabView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    [self.collView reloadData];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"sections = %ld",[self.data numOfCollSections:self.tabView.tag]);
    return [self.data numOfCollSections:self.tabView.tag];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"items = %ld",[self.data numOfItemsInSection:section tag:self.tabView.tag]);
    return [self.data numOfItemsInSection:section tag:self.tabView.tag];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleLab.text = [self.data titleWithIndexPath:indexPath tag:self.tabView.tag];
    NSLog(@"text = %@",cell.titleLab.text);
    return cell;
}

//设置页眉
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HistoryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    header.deleButton.tag = indexPath.section;
    if ([self.data collHaveHeaderWithTag:self.tabView.tag]) {
        header.titleLab.text = [self.data titleHeaderWith:indexPath tag:self.tabView.tag];
        header.titleLab.hidden = NO;
        header.deleButton.hidden = NO;
        [header.deleButton setImage:[UIImage imageNamed:@"进入箭头"] forState:UIControlStateNormal];
        [header.deleButton addTarget:self action:@selector(DetailMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        header.titleLab.hidden = YES;
        header.deleButton.hidden = YES;
    }
    return header;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.data ItemModelWith:indexPath tag:self.tabView.tag];
    if ([obj isKindOfClass:[ChildMenuModel_2 class]]) {
        ChildMenuModel_2 *model = (ChildMenuModel_2 *)obj;
        NSLog(@"title_2 = %@, val = %@",model.title, model.val);
        [self jumpToSearchDetailVCWithKey:model.key val:model.val title:model.title];
    }
    else if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
        ChildMenuModel_3 *model = (ChildMenuModel_3 *)obj;
        NSLog(@"title_3 = %@, val = %@",model.title, model.val);
        [self jumpToSearchDetailVCWithKey:model.key val:model.val title:model.title];
    }
    
}

//头尾视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat w = collectionView.frame.size.width;
    CGFloat h = 44;
    if (![self.data collHaveHeaderWithTag:self.tabView.tag]) {
        h = 12;
    }
    return CGSizeMake(w, h);
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *text = [self.data titleWithIndexPath:indexPath tag:self.tabView.tag];
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:13]}];
    CGFloat width = collectionView.frame.size.width;
    CGFloat item_w = (width - 12 * 2 - 10 * 2) / 3.0;
    return  CGSizeMake(item_w, 45);
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

#pragma mark - 点击页眉详情
- (void)DetailMethod:(UIButton *)button {
    ChildMenuModel_2 *model = [self.data HeaderModelWith:button.tag tag:self.tabView.tag];
    NSLog(@"title = %@",model.title);
    [self jumpToSearchDetailVCWithKey:model.key val:model.val title:model.title];
}

- (void)jumpToSearchDetailVCWithKey:(NSString *)key val:(NSString *)val title:(NSString *)title {
    SearchDetailVC *vc = [[SearchDetailVC alloc]init];
    vc.index = 2;
    vc.key = key;
    vc.val = val;
    vc.titleStr = title;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
