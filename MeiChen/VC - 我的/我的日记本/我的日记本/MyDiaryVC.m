//
//  MyDiaryVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyDiaryVC.h"
#import "AddDiaryVC.h"
#import "DiaryCell.h"

@interface MyDiaryVC () <CustomNavViewDelegate, EmptyViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
    BOOL _isend;
}

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) EmptyView *empty;

@property (nonatomic, strong) MyDiaryData *DiaryData;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@end

@implementation MyDiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isend = YES;
    [self BUildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestMyDiaryData:NO refresh:NO];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"======================= cellCount = %lu",self.DiaryData.data.count);
    return self.DiaryData.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    DiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiaryCell" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyDiaryModel *model = self.DiaryData.data[indexPath.row];
    [cell LoadDiaryData:model];
    cell.update.tag = indexPath.row;
    [cell.update addTarget:self action:@selector(UpdateButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.count.text = [NSString stringWithFormat:@"%ld%@",indexPath.row,NSLocalizedString(@"MyDiaryVC_20", nil)];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return (180.0/375.0*tableView.frame.size.width) + 20;
}
//tableView自带的左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDiaryModel *model = self.DiaryData.data[indexPath.row];
    if ([model.status isEqualToString:@"UN_PASS"]) {
        return YES;
    }
    return NO;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        [self deleteDiary:indexPath.row];
    }
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    CGFloat offsetY = point.y;

    if (offsetY<=0) {
        // 上滑
        NSArray *visibleArr = [self.tabview indexPathsForVisibleRows];
        NSArray *cellArr = [self.tabview visibleCells];
        DiaryCell *cell = [cellArr lastObject];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        NSLog(@"row = %ld, count = %ld, count-3 = %lu",indexPath.row,self.DiaryData.data.count,self.DiaryData.data.count-3);
        if ([visibleArr containsObject:indexPath]) {
            if (indexPath.row >= self.DiaryData.data.count-3 && scrollView.isDragging && !_isend) {
                [self requestMyDiaryData:YES refresh:NO];
            }
        }
    }
}

#pragma mark - 更新日记
- (void)UpdateButtonMethod:(UIButton *)sender {
    AddDiaryVC *vc = [[AddDiaryVC alloc]init];
    vc.isfirst = NO;
    vc.diaryModel = [[DiaryDetailModel alloc]init];
    vc.mydiary = self.DiaryData.data[sender.tag];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat bu_h = 45;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;
    
    net = [[NetWork alloc]init];
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyDiaryVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,self.view.frame.size.height - y - bu_h} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
//    self.tabview.refreshControl = [[UIRefreshControl alloc]init];
//    [self.tabview.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    // UIRefreshControl
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tabview addSubview:_refreshControl];
    
    [self.view addSubview:self.tabview];

    self.empty = [[EmptyView alloc]initWithFrame:self.tabview.frame];
    self.empty.lab.text = NSLocalizedString(@"MyDiaryVC_5", nil);
    self.empty.delegate = self;
    [self.view addSubview:self.empty];

    [self judgeHide];
    
    // 预约相同案例
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bu_h, CGRectGetWidth(self.view.frame), bu_h)];
    [bu addTarget:self action:@selector(ButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [bu setTitle:NSLocalizedString(@"MyDiaryVC_2", nil) forState:UIControlStateNormal];
    [bu setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bu];
}

- (void)refreshData {
    [self requestMyDiaryData:NO refresh:YES];
}

- (void)judgeHide {
    if (self.DiaryData == nil || self.DiaryData.data == nil || self.DiaryData.data.count == 0) {
        self.empty.hidden = NO;
    }
    else {
        self.empty.hidden = YES;
    }
}

#pragma mark - 创建新日记本
- (void)ButtonMethod:(UIButton *)sender {
    AddDiaryVC *vc = [[AddDiaryVC alloc]init];
    vc.isfirst = YES;
    vc.diaryModel = [[DiaryDetailModel alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - EmptyViewDelegate
- (void)EmptyViewDidTouch {
    [self requestMyDiaryData:NO refresh:NO];
}

#pragma mark - 获取我的日记本数据
- (void)requestMyDiaryData:(BOOL)addmore refresh:(BOOL)refresh {
    if (!addmore && !refresh) {
        [SVProgressHUD show];
    }
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        return;
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    NSInteger page = 1;
    if (addmore) {
        NSInteger shang = self.DiaryData.data.count / 10;
        NSInteger yushu = self.DiaryData.data.count % 10;
        page = yushu==0?(shang+1):shang;
        if (page == 0) {
            page = 1;
        }
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    
    NSLog(@"获取我的日记本数据 page = %ld",page);
    [net requestWithUrl:@"sample/my-listing" Parames:m_dic Success:^(id responseObject) {
        [self ParsingMyDiaryListData:responseObject addmore:addmore];
    } Failure:^(NSError *error) {
        [self requestMyDiaryFail:error addmore:addmore];
    }];
}
// 获取定制列表数据 - 成功
- (void)requestMyDiarySuccess:(BOOL)addmore {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!addmore) {
            [SVProgressHUD dismiss];
            [self.tabview reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self judgeHide];
        [_refreshControl endRefreshing];
    });
}
// 获取定制列表数据 - 失败
- (void)requestMyDiaryFail:(NSError *)error addmore:(BOOL)addmore {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!addmore) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_refreshControl endRefreshing];
    });
}
#pragma mark - 解析数据
// 1、解析定制列表数据
- (void)ParsingMyDiaryListData:(id)responseObject addmore:(BOOL)addmore {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                MyDiaryData *model = [MTLJSONAdapter modelOfClass:[MyDiaryData class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    [self requestMyDiarySuccess:addmore];
                    return ;
                }
                if (model.data == nil) {
                    model.data = [NSArray array];
                }
                if (model.data.count < 10) {
                    _isend = YES;
                }
                else {
                    _isend = NO;
                }
                [self AddToArray:model addmore:addmore];
                [self requestMyDiarySuccess:addmore];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [self requestMyDiaryFail:error addmore:addmore];
    });
}

#pragma mark - 删除一个日记本
- (void)deleteDiary:(NSInteger)row {
    MyDiaryModel *model = self.DiaryData.data[row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"sample_id"] = model.sample_id;
    NSLog(@"sample_id = %@",model.sample_id);
    [SVProgressHUD show];
    [net requestWithUrl:@"sample/my-del" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"删除一个日记本 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [SVProgressHUD dismiss];
                NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.DiaryData.data];
                [m_arr removeObjectAtIndex:row];
                self.DiaryData.data = m_arr;
                [self.tabview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:(UITableViewRowAnimationLeft)];
                [self judgeHide];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

- (void)AddToArray:(MyDiaryData *)data addmore:(BOOL)addmore {
    if (self.DiaryData == nil ||
        self.DiaryData.data == nil ||
        self.DiaryData.data.count == 0) {
        self.DiaryData = data;
        return;
    }
    NSMutableArray *idArray = [NSMutableArray array];
    for (int i = 0; i < self.DiaryData.data.count; i ++) {
        MyDiaryModel *model = self.DiaryData.data[i];
        [idArray addObject:model.sample_id];
    }
    
    NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.DiaryData.data];
    NSInteger oldIndex = m_arr.count;
    NSMutableArray *insertArr = [NSMutableArray array];
    NSMutableArray *updateArr = [NSMutableArray array];
    for (int i = 0; i < data.data.count; i ++) {
        MyDiaryModel *model = data.data[i];
        if ([idArray containsObject:model.sample_id]) {
            NSInteger index = [idArray indexOfObject:model.sample_id];
            [m_arr replaceObjectAtIndex:index withObject:model];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [updateArr addObject:indexPath];
        }
        else {
            [m_arr addObject:model];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+oldIndex inSection:0];
            [insertArr addObject:indexPath];
        }
    }
    
    self.DiaryData.data = [NSArray arrayWithArray:m_arr];
//    [self.tabview reloadData];
    
    if (updateArr.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabview beginUpdates];
            [self.tabview reloadRowsAtIndexPaths:updateArr withRowAnimation:(UITableViewRowAnimationNone)];
            [self.tabview endUpdates];
        });
    }
    if (insertArr.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabview beginUpdates];
            [self.tabview insertRowsAtIndexPaths:insertArr withRowAnimation:(UITableViewRowAnimationNone)];
            [self.tabview endUpdates];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
