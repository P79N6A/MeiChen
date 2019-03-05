//
//  CaseVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/10.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CaseVC.h"

#import "CustomSearchDetailNavView.h"   // 导航栏
#import "CaseMiddleView.h"              // 表头视图
#import "CaseVCData.h"                  // 案例详情数据
#import "CaseDetailCell.h"              // 表视图Cell
#import "SearchDetailVC.h"              // 标签搜索控制器
#import "ZanData.h"                     // 点赞请求
#import "ReviewVC.h"                    // 评论页控制器


@interface CaseVC () <CustomSearchDetailNavViewDelegate, CaseVCDataDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ZanDataDelegate, CaseDetailCellDelegate> {
    CGRect originalFrame;   // 背景图的原始位置
    CGFloat middle_h;
}
// 导航栏
@property (nonatomic, strong) CustomSearchDetailNavView *navView;
// 背景图
@property (nonatomic, strong) UIImageView *backImage;
// 表视图
@property (nonatomic, strong) UITableView *tabView;
// 表头视图
@property (nonatomic, strong) CaseMiddleView *caseMiddleView;

@property (nonatomic, strong) CaseVCData *data;
@property (nonatomic, strong) ZanData *zandata;

@end

@implementation CaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[CaseVCData alloc]init];
    self.data.delegate = self;
    self.data.listmodel = self.listmodel;
    [self.data requestCaseDetailData];
    
    self.zandata = [[ZanData alloc]init];
    self.zandata.delegate = self;
    
    [self BuildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - ZanDataDelegate
// 点赞
- (void)ZanData_Zan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 成功");
    [self.data UpdateZanDataWith:[NSIndexPath indexPathForRow:row inSection:type]];
}
- (void)ZanData_Zan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 失败");
}
// 取消点赞
- (void)ZanData_CancelZan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 成功");
    [self.data UpdateCancelZanDataWith:[NSIndexPath indexPathForRow:row inSection:type]];
}
- (void)ZanData_CancelZan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 失败");
}


#pragma mark - CaseVCDataDelegate
// 案例详情请求
- (void)CaseVCData_requestSuccess {
    NSLog(@"案例详情请求 - 成功");
    [self updateTableView];
}
- (void)CaseVCData_requestFail:(NSError *)error {
    NSLog(@"案例详情请求 - 失败");
}
// 更新成功
- (void)CaseVCData_UpdateFinish:(NSIndexPath *)indexPath {
    NSLog(@"更新成功");
    [UIView performWithoutAnimation:^{
        [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        [self scrollViewDidScroll:self.tabView];
    }];
}

- (void)updateTableView {
    [self.caseMiddleView loadModel:[self.data
                                     CaseDetailModel]];
    [self.tabView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"sections = %ld",[self.data numOfSections]);
    return [self.data numOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rows = %ld",[self.data numOfRowsInSection:section]);
    return [self.data numOfRowsInSection:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    CaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CaseDetailCell" owner:nil options:nil] firstObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DailyModel *model = [self.data DailyModelWithIndexPath:indexPath];
    NSInteger k = [self.data numOfRowsInSection:indexPath.section];
    if (k - 1 > indexPath.row) {
        cell.line_2.hidden = NO;
    }
    else {
        cell.line_2.hidden = YES;
    }
    cell.delegate = self;
    [cell loadDataWithModel:model indexPath:indexPath];
    [cell loadTime_2:[self.data numbersWithModel:model]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.data heightWithIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    DailyModel *model = [self.data DailyModelWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    NSString *year = [NSString stringWithFormat:@"%@%@",[self.data timeComponentsYear:[model.photo_at integerValue]],NSLocalizedString(@"CaseDetailVC_8", nil)];
    UILabel *lab = [[UILabel alloc]init];
    CGFloat lab_h = 44;
    if (section == 0) {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, middle_h + lab_h);
        self.caseMiddleView.frame = CGRectMake(0, 0, view.frame.size.width, middle_h);
        lab.frame = CGRectMake(12, view.frame.size.height - lab_h, tableView.frame.size.width - 12 * 2, lab_h);
        [view addSubview:self.caseMiddleView];
    }
    else {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, lab_h);
        lab.frame = CGRectMake(12, 0, tableView.frame.size.width - 12 * 2, lab_h);
    }
    lab.text = year;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = kColorRGB(0x999999);
    [view addSubview:lab];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return middle_h + 44;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ROW = %ld",indexPath.row);
}

#pragma mark - CaseDetailCellDelegate
// 评论
- (void)CaseDetailCellDidSelectMessageIndexPath:(NSIndexPath *)indexPath {
    ReviewVC *vc = [[ReviewVC alloc]init];
    vc.model = [self.data DailyModelWithIndexPath:indexPath];
    vc.louzhuId = self.data.CaseDetailModel.member_id;
    [self.navigationController pushViewController:vc animated:YES];
}
// 点赞
- (void)CaseDetailCellDidSelectZan:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    DailyModel *model = [self.data DailyModelWithIndexPath:indexPath];
    if (sender.selected) {
        [self.zandata requestCancelZanWithId:model.daily_id type:@"sample_daily" row:indexPath.row type:indexPath.section];
    }
    else {
        [self.zandata requestZanWithId:model.daily_id type:@"sample_daily" row:indexPath.row type:indexPath.section];
    }
}


#pragma mark - UI
- (void)BuildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat bu_h = 45;
    CGFloat middle_w = CGRectGetWidth(self.view.frame);
    middle_h = middle_w * 410.0 / 375.0;
    
    // 导航栏
    self.navView = [[CustomSearchDetailNavView alloc]init];
    self.navView.delegate = self;
    self.navView.index = 3;
    self.navView.titleLab.text = NSLocalizedString(@"CaseDetailVC_1", nil);
    self.navView.titleLab.backgroundColor = [UIColor clearColor];
    self.navView.titleLab.textColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.line.alpha = 0;
    
    // 背景图
    UIImage *image = [UIImage imageNamed:@"案例背景"];
    CGFloat back_w = CGRectGetWidth(self.view.frame);
    CGFloat back_h = image.size.height / image.size.width * back_w;
    if (statusRect.size.height > 20) {
        back_h += statusRect.size.height - 20;
    }
    originalFrame = CGRectMake(0, 0, back_w, back_h);
    self.backImage = [[UIImageView alloc]initWithFrame:originalFrame];
    self.backImage.image = image;
    
    // 初始化表头
    self.caseMiddleView = [[CaseMiddleView alloc]init];
    self.caseMiddleView.backgroundColor = [UIColor clearColor];
    [self.caseMiddleView.bu_1 addTarget:self action:@selector(TagSearchMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.caseMiddleView.bu_2 addTarget:self action:@selector(TagSearchMethod:) forControlEvents:UIControlEventTouchUpInside];
    __weak CaseVC *weakSelf = self;
    self.caseMiddleView.sorting = ^{
        [weakSelf.data ChangeTheOrder];
        [weakSelf.tabView reloadData];
    };
    
    // 表视图
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusRect.size.height + 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - statusRect.size.height - 44 - bu_h) style:UITableViewStyleGrouped];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tabView setBackgroundColor:[UIColor clearColor]];
    self.tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 预约相同案例
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bu_h, CGRectGetWidth(self.view.frame), bu_h)];
    [bu addTarget:self action:@selector(ButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [bu setTitle:NSLocalizedString(@"CaseDetailVC_14", nil) forState:UIControlStateNormal];
    [bu setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 添加视图
    [self.view addSubview:self.backImage];
    [self .view addSubview:self.tabView];
    [self.view addSubview:self.navView];
    [self.view addSubview:bu];
}

#pragma mark - 标签搜索
- (void)TagSearchMethod:(UIButton *)sender {
    SearchDetailVC *vc = [[SearchDetailVC alloc]init];
    vc.index = 3;
    vc.searchTitle = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - CustomSearchDetailNavViewDelegate
- (void)CustomSearchDetailNavView_ClickedBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    // 改变状态栏的背景颜色
    CGFloat headerHeight = CGRectGetHeight(self.backImage.frame) - CGRectGetHeight(self.navView.frame);
    if (yOffset < headerHeight) {
        CGFloat apl = yOffset / headerHeight;
        self.navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:apl];
        self.navView.line.alpha = 0;
        self.navView.titleLab.textColor = [UIColor colorWithWhite:(1 - apl) alpha:1.0];
        [self.navView.back setImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
    }
    else {
        self.navView.backgroundColor = [UIColor whiteColor];
        self.navView.line.alpha = 1.0;
        self.navView.titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.navView.back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }
    
    // 往上移动和往下放大
    if (yOffset > 0) {
        self.backImage.frame = ({
            CGRect frame = originalFrame;
            frame.origin.y = originalFrame.origin.y - yOffset;
            frame;
        });
    }
    else {
        self.backImage.frame = ({
            CGRect frame = originalFrame;
            frame.size.height = originalFrame.size.height - yOffset;
            frame.size.width = frame.size.height / (originalFrame.size.height / originalFrame.size.width);
            frame.origin.x = originalFrame.origin.x - (frame.size.width - originalFrame.size.width) / 2.0;
            frame;
        });
    }
}

- (void)ButtonMethod:(UIButton *)sender {
    NSLog(@"预约同款");
}


- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

@end
