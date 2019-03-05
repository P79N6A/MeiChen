//
//  PlanListVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanListVC.h"
#import "PlanListData.h"
#import "PlanListCell.h"
#import "MyPlanVC.h"


@interface PlanListVC () <CustomNavViewDelegate,PlanListDataDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) PlanListData *data;

@end

@implementation PlanListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[PlanListData alloc]init];
    self.data.delegate = self;
    [SVProgressHUD show];
    [self.data requestPlanListData:@"1"];
    [self BUildUI];
}

#pragma mark - 数据回调
- (void)request_PlanListData_Success {
    [SVProgressHUD dismiss];
    [self.tabview reloadData];
}
- (void)request_PlanListData_Fail:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data numbersOfRow];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.rowHeight = 172;
    PlanListCell *cell = [PlanListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadSinglePlanModel:[self.data ItemWithRow:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tag = %ld, row = %ld",tableView.tag, indexPath.row);
    MyPlanVC *vc = [[MyPlanVC alloc]init];
    SinglePlanModel *model = [self.data ItemWithRow:indexPath.row];
    vc.order_id = model.imitate_id;
    vc.titleStr = NSLocalizedString(@"MyPlanVC_1", nil);
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
    self.navview.titleLab.text = NSLocalizedString(@"MyVC_5", nil);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
