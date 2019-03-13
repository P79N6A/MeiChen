//
//  ExcSolVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/27.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExcSolVC.h"
#import "ExcSolCell.h"
#import "ExcSolDetailVC.h"
@interface ExcSolVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) NSMutableArray *heightArr;
@property (nonatomic, strong) OrderList*list;
@end

@implementation ExcSolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self BUildUI];
    [SVProgressHUD show];
    [self requestListWithAddMore:NO];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExcSolCell *cell = [ExcSolCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(YuYueMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    OrderListModel *model = self.list.data[indexPath.row];
    [cell loadDataWithIndexPath:indexPath model:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *num = self.heightArr[indexPath.row];
    return [num floatValue];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 18;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)YuYueMethod:(UIButton *)sender {
    ExcSolDetailVC *vc = [[ExcSolDetailVC alloc]init];
    OrderListModel *model = self.list.data[sender.tag];
    vc.order_id = model.order_id;
    vc.titleStr = NSLocalizedString(@"MyPlanVC_19", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    CGFloat y = statusRect.size.height + 44;
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,self.view.frame.size.height - y} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.tag = 1;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabview];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    
}

#pragma mark - 计算高度
- (void)CalculateHeight {
    CGFloat back_w = self.view.frame.size.width-20-1-14-12;
    CGFloat lab_w = back_w-16*2;
    CGFloat cell_h = 18+back_w*(246.0/328.0)+(13+18)+4+(15+18)+4+(15+18)+(10+25)+15;
    self.heightArr = [NSMutableArray array];
    for (int i = 0; i < self.list.data.count; i ++) {
        OrderListModel *model = self.list.data[i];
        CGFloat h_1 = 18;
        CGFloat h_2 = 18;
        CGSize size_1 = [Tools sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(lab_w, MAXFLOAT) string:model.analysis];
        CGSize size_2 = [Tools sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(lab_w, MAXFLOAT) string:model.effect];
        h_1 = size_1.height;
        h_2 = size_2.height;
        if (h_1 < 18) {
            h_1 = 18;
        }
        if (h_2 < 18) {
            h_2 = 18;
        }
        NSNumber *num = [NSNumber numberWithFloat:(cell_h+h_1+h_2)];
        [self.heightArr addObject:num];
    }
}

#pragma mark - 网络请求
- (void)requestListWithAddMore:(BOOL)more {
    NSInteger page = 1;
    if (more) {
        NSInteger shang = self.list.data.count / 10;
        NSInteger yushu = self.list.data.count % 10;
        page = yushu==0?(shang+1):shang;
        if (page == 0) {
            page = 1;
        }
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    [net requestWithUrl:@"order/listing" Parames:m_dic Success:^(id responseObject) {
        [self ParsingListData:responseObject addmore:more];
    } Failure:^(NSError *error) {
        [self requestFail:error addmore:more];
    }];
}

// 获取定制列表数据 - 成功
- (void)requestSuccess:(BOOL)addmore {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!addmore) {
            [SVProgressHUD dismiss];
            [self CalculateHeight];
            [self.tabview reloadData];
        }
    });
}
// 获取定制列表数据 - 失败
- (void)requestFail:(NSError *)error addmore:(BOOL)addmore {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!addmore) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        }
    });
}

#pragma mark - 解析数据
// 1、解析定制列表数据
- (void)ParsingListData:(id)responseObject addmore:(BOOL)addmore {
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
                OrderList *model = [MTLJSONAdapter modelOfClass:[OrderList class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    [self requestSuccess:addmore];
                    return ;
                }
                if (model.data == nil) {
                    model.data = [NSArray array];
                }
                [self AddToArray:model addmore:addmore];
                [self requestSuccess:addmore];
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
        [self requestFail:error addmore:addmore];
    });
}

- (void)AddToArray:(OrderList *)data addmore:(BOOL)addmore {
    if (self.list == nil ||
        self.list.data == nil ||
        self.list.data.count == 0) {
        self.list = data;
        return;
    }
    NSMutableArray *idArray = [NSMutableArray array];
    for (int i = 0; i < self.list.data.count; i ++) {
        OrderListModel *model = self.list.data[i];
        [idArray addObject:model.order_id];
    }
    
    NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.list.data];
//    NSInteger oldIndex = m_arr.count;
//    NSMutableArray *insertArr = [NSMutableArray array];
//    NSMutableArray *updateArr = [NSMutableArray array];
    for (int i = 0; i < data.data.count; i ++) {
        OrderListModel *model = data.data[i];
        if ([idArray containsObject:model.order_id]) {
            NSInteger index = [idArray indexOfObject:model.order_id];
            [m_arr replaceObjectAtIndex:index withObject:model];
            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            [updateArr addObject:indexPath];
        }
        else {
            [m_arr addObject:model];
            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+oldIndex inSection:0];
//            [insertArr addObject:indexPath];
        }
    }
    self.list.data = [NSArray arrayWithArray:m_arr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
