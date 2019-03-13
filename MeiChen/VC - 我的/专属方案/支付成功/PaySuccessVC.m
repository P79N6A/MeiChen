//
//  PaySuccessVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PaySuccessVC.h"
#import "ServersVC.h"
#import "PaySuccessView.h"
#import "PaySuccessCell.h"
#import "YuYueSurgery.h"

@interface PaySuccessVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) PaySuccessView *view_1;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) SurgeryList *data;
@end

@implementation PaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self requestListWith:self.order_id];
    [self BUildUI];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.surgery.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaySuccessCell *cell = [PaySuccessCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SurgeryListSurgery *model = self.data.surgery[indexPath.row];
    [cell loadModel:model indexPath:indexPath];
    [cell.bu addTarget:self action:@selector(YuYueButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)YuYueButtonMethod:(UIButton *)button {
    NSLog(@"立即预约");
    SurgeryListSurgery *model = self.data.surgery[button.tag];
    if ([model.is_allow_book integerValue] == 1) {
        YuYueSurgery *vc = [[YuYueSurgery alloc]init];
        vc.fromSuccessVC = YES;
        vc.order_id = model.order_id;
        vc.surgery_id = model.surgery_id;
        vc.doctor_id = model.doctor_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"PaySuccessVC_7", nil) preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"PaySuccessVC_8", nil) style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    if (self.isOfflinePay) {
        self.navview.titleLab.text = NSLocalizedString(@"PaySuccessVC_2", nil);
    }
    else {
        self.navview.titleLab.text = NSLocalizedString(@"PaySuccessVC_1", nil);
    }
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navview.frame), width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navview.frame))];
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scroll];
    
    self.view_1 = [[PaySuccessView alloc]init];
    if (self.isOfflinePay) {
        self.view_1.titleName.text = NSLocalizedString(@"PaySuccessVC_2", nil);
        self.view_1.message.text = NSLocalizedString(@"PaySuccessVC_3", nil);
    }
    else {
        self.view_1.titleName.text = NSLocalizedString(@"PaySuccessVC_1", nil);
        self.view_1.message.text = NSLocalizedString(@"PaySuccessVC_4", nil);
    }
    [_scroll addSubview:self.view_1];
    
    CGFloat y = CGRectGetMaxY(self.view_1.frame) + 70;
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,_scroll.frame.size.height - y} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.tag = 1;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabview];
    
    _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.tabview.frame));
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    ServersVC *vc = [[ServersVC alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    
}


#pragma mark - 网络请求
- (void)requestListWith:(NSString *)order_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"order_id"] = order_id;
    [net requestWithUrl:@"order/surgery-listing" Parames:m_dic Success:^(id responseObject) {
        [self ParsingListData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}
// 获取定制列表数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.tabview reloadData];
    });
}
// 获取定制列表数据 - 失败
- (void)requestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    });
}
#pragma mark - 解析数据
// 1、解析定制列表数据
- (void)ParsingListData:(id)responseObject {
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
                SurgeryList *model = [MTLJSONAdapter modelOfClass:[SurgeryList class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    return ;
                }
                self.data = model;
                [self requestSuccess];
                return;
                break;
            }
            default:
                break;
        }
        
        self.data = [self CustomModel];
        [self requestSuccess];
        return;
        
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [self requestFail:error];
    });
}

- (SurgeryList *)CustomModel {
    SurgeryList *list = [[SurgeryList alloc]init];
    
    list.order_id = @"1";
    
    itemModel *item_1 = [[itemModel alloc]init];
    item_1.item_name = @"鼻翼缩小";
    itemModel *item_2 = [[itemModel alloc]init];
    item_2.item_name = @"开内眼角";
    itemModel *item_3 = [[itemModel alloc]init];
    item_3.item_name = @"开外眼角";
    
    SurgeryListSurgery *surgery_1 = [[SurgeryListSurgery alloc]init];
    surgery_1.seq = @"1";
    surgery_1.is_allow_book = @"1";
    surgery_1.items = @[item_1];
    
    SurgeryListSurgery *surgery_2 = [[SurgeryListSurgery alloc]init];
    surgery_2.seq = @"2";
    surgery_2.is_allow_book = @"0";
    surgery_2.items = @[item_2,item_3];
    
    list.surgery = @[surgery_1, surgery_2];
    
    return list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
