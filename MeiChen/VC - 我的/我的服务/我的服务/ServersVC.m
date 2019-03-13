//
//  ServersVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServersVC.h"
#import "ServersView.h"
#import "timecutdownView.h"
#import "ServerPlanListView.h"
#import "MessageView.h"

@interface ServersVC () <CustomNavViewDelegate> {
    NetWork *net;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) ServersView *BaseView;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) timecutdownView *timeview;
@property (nonatomic, strong) ServerPlanListView *rightView;
@property (nonatomic, strong) MessageView *messvi;
@property (nonatomic, strong) SurgeryModel *data;
@end

@implementation ServersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self requestSurgeryData:nil];
    [self BUildUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.timeview.frame = CGRectMake(0, 0, self.BaseView.proView.frame.size.width, self.BaseView.proView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self AddCircleView];
}


- (void)ReloadData {
    // 1. 加载 标题
    NSMutableString *m_title = [NSMutableString string];
    [m_title appendString:self.data.order.title];
    [m_title appendString:@"-"];
    [m_title appendString:NSLocalizedString(@"ServersVC_14", nil)];
    [m_title appendString:self.data.seq];
    self.navview.titleLab.text = m_title;
    
    // 2. 加载 美臣消息
    self.messvi.lab_3.text = self.data.tips;
    
    // 3. 加载
    [self.BaseView loadDataWith:self.data];
}




#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsWhiteBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ServersVC_1", nil);
    self.navview.titleLab.textColor = [UIColor whiteColor];
    self.navview.line.hidden = YES;
    self.navview.backgroundColor = kColorRGB(0x7CE8EB);
    [self.navview.rightItem setImage:[UIImage imageNamed:@"列表"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.navview];
    
    __weak typeof(self) weakSelf = self;
    self.rightView = [[ServerPlanListView alloc]init];
    self.rightView.index = ^(SideBarSurgeryModel *model) {
        NSLog(@"surgery_id = %@, %@",model.surgery_id, model.process);
        [SVProgressHUD show];
        [weakSelf requestSurgeryData:model.surgery_id];
    };
}
- (void)BUildDataView {
    if (_scroll != nil) {
        NSLog(@"scroll 已经存在，不需要创建新的ui");
        return;
    }
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat y = CGRectGetMaxY(self.navview.frame);
    CGFloat gap = 12;
    
    // 滚动图
    self.scroll = [[UIScrollView alloc]initWithFrame:(CGRect){0,y,width,height-y}];
    self.scroll.bounces = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroll];
    
    CGFloat bas_h = (681.0/375.0)*width;
    self.BaseView = [[ServersView alloc]initWithFrame:CGRectMake(0, 0, width, bas_h)];
    self.timeview = [[timecutdownView alloc]init];
    [self.timeview settingLineWidth:5];
    [self.BaseView.proView addSubview:self.timeview];
    [_scroll addSubview:self.BaseView];
    
    _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.BaseView.frame));
    
    self.messvi = [[MessageView alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(self.navview.frame)+gap, width-gap*2, 25)];
    [self.view addSubview:self.messvi];
}
- (void)AddCircleView {
    [self.timeview circleProgressView];
    [self.timeview SettingLabStr:@"2天"];
    [self.timeview SettingProgress:0.6];
}
#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    if (self.data != nil) {
        [self.rightView settingCurrentIndexPathWith:self.data.order_id surgery_id:self.data.surgery_id];
    }
    [self.rightView show];
}

#pragma mark - 网络请求手术详情数据
- (void)requestSurgeryData:(NSString *)surgery_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    NSString *url = @"follow/focus";
    if (surgery_id != nil) {
        m_dic[@"surgery_id"] = surgery_id;
        url = @"follow/detail";
    }
    [net requestWithUrl:url Parames:m_dic Success:^(id responseObject) {
        [self ParsingSurgeryData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}
// 获取定制列表数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.rightView settingCurrentIndexPathWith:self.data.order_id surgery_id:self.data.surgery_id];
        [self BUildDataView];
        [self ReloadData];
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
- (void)ParsingSurgeryData:(id)responseObject {
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
                SurgeryModel *model = [MTLJSONAdapter modelOfClass:[SurgeryModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                if (model != nil) {
                    self.data = model;
                    [self requestSuccess];
                    return;
                }
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
        [self requestFail:error];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
