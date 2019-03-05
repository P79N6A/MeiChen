//
//  SelectProjectVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SelectProjectVC.h"
#import "AllMenuData.h"                 // 菜单页数据
#import "TypeTabCell.h"                 // 表视图cell
#import "HistoryHeader.h"               // 搜索列表头视图
#import "HistoryCell.h"                 // 搜索列表的item
#import "AlreadySelectView.h"

static NSString *identifier = @"TypeCell";
static NSString *HeaderIdentifier = @"TypeHeaderCell";

@interface SelectProjectVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, AllMenuDataDelegate> {
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) AllMenuData *data;
@property (nonatomic, strong) AlreadySelectView *selectView;
@end

@implementation SelectProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[AllMenuData alloc]init];
    self.data.delegate = self;
    [self.data requestAllMenu];
    
    [self BUildUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.SelectArray = self.selectView.m_arr;
}

#pragma mark - AllMenuDataDelegate
// 分类菜单请求
- (void)AllMenuData_requestSuccess {
    NSLog(@"分类菜单请求 成功");
    [self.data updateAllMenuModel:NSMakeRange(0, 2)];
    
    [self.tabView reloadData];
    [self.collView reloadData];
}
- (void)AllMenuData_requestFail:(NSError *)error {
    NSLog(@"分类菜单请求 失败");
    [self CustomNavView_LeftItem:nil];
}





#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = kColorRGB(0xf0f0f0);
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat y = statusRect.size.height + 44;
    CGFloat select_h = 50;

    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsQueue];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyDiaryVC_18", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];

    self.selectView = [[AlreadySelectView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, select_h)];
    self.selectView.m_arr = self.SelectArray;
    [self.selectView reloadButtonTitle];
    __weak typeof(self) weakSelf = self;
    self.selectView.blockselect = ^{
        [weakSelf.collView reloadData];
    };
    [self.view addSubview:self.selectView];
    
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, y+select_h, 90, CGRectGetHeight(self.view.frame)-y-select_h) style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tag = 0;
    self.tabView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabView.bounces = NO;
    [self.view addSubview:self.tabView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tabView.frame), y+select_h, self.view.frame.size.width-y, self.view.frame.size.height-y-select_h) collectionViewLayout:layout];
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

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    if (self.blockArray != nil) {
        self.blockArray(self.SelectArray);
        [self CustomNavView_LeftItem:nil];
    }
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
    return [self.data numOfCollSections:self.tabView.tag];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data numOfItemsInSection:section tag:self.tabView.tag];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *str = [self.data titleWithIndexPath:indexPath tag:self.tabView.tag];
    cell.titleLab.text = str;
    if ([self haveInArray:self.selectView.m_arr with:str]) {
        cell.titleLab.textColor = [UIColor whiteColor];
        cell.titleLab.backgroundColor = kColorRGB(0x5CDAE6);
    }
    else {
        cell.titleLab.textColor = kColorRGB(0x333333);
        cell.titleLab.backgroundColor = [UIColor whiteColor];
    }
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
    }
    else if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
        ChildMenuModel_3 *model = (ChildMenuModel_3 *)obj;
        [self.selectView UpdateSelectArrayWith:model];
        [self.collView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else if ([obj isKindOfClass:[itemModel class]]) {
        itemModel *model = (itemModel *)obj;
        [self.selectView UpdateSelectArrayWith:model];
        [self.collView reloadItemsAtIndexPaths:@[indexPath]];
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
- (BOOL)haveInArray:(NSArray *)array with:(NSString *)str {
    for (int i = 0; i < array.count; i ++) {
        id obj = array[i];
        if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
            ChildMenuModel_3 *mo = (ChildMenuModel_3 *)obj;
            if ([mo.title isEqualToString:str]) {
                return YES;
            }
        }
        if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *mo = (itemModel *)obj;
            if ([mo.item_name isEqualToString:str]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
