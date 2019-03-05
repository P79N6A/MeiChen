//
//  WatingPlanVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/23.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "WatingPlanVC.h"
#import "timecutdownView.h"

@interface WatingPlanVC () <CustomNavViewDelegate> {
    NetWork *net;
}

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) timecutdownView *timeview;
@end

@implementation WatingPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    
    [self CreateUI];
    
    self.timeview = [[timecutdownView alloc]init];
    [self.countdownView addSubview:self.timeview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 判断是否需要弹出浮窗
    [[FloatWindows shareInstance] dissmissWindow];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.setting.layer.masksToBounds = YES;
    self.setting.layer.cornerRadius = self.setting.frame.size.height / 2.0;
    
    self.timeview.frame = CGRectMake(0, 0, self.countdownView.frame.size.width, self.countdownView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self AddCircleView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 判断是否需要弹出浮窗
    [[FloatWindows shareInstance] CanShowFloatingWindows];
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsWhiteBack];
    self.navview.backgroundColor = [UIColor clearColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"WatingPlanVC_1", nil);
    self.navview.titleLab.textColor = [UIColor whiteColor];
    [self.view addSubview:self.navview];
    
    self.lab_1.text = NSLocalizedString(@"WatingPlanVC_2", nil);
    self.lab_2.text = NSLocalizedString(@"WatingPlanVC_3", nil);
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:NSLocalizedString(@"WatingPlanVC_8", nil)];
    [m_str appendString:self.fake_member_num];
    [m_str appendString:NSLocalizedString(@"WatingPlanVC_9", nil)];
    [m_str appendString:self.fake_former_num];
    [m_str appendString:NSLocalizedString(@"WatingPlanVC_10", nil)];
    self.lab_3.text = m_str;
    
    [self.setting setTitle:NSLocalizedString(@"WatingPlanVC_4", nil) forState:UIControlStateNormal];
}

- (void)AddCircleView {
    [self.timeview circleProgressView];
    NSDictionary *dic = [[UserDefaults shareInstance] ReadPlanSettingData];
    NSInteger start_Time = [dic[@"nowTime"] integerValue];
    NSInteger gap_Time = [dic[@"hour"] integerValue];
    [self.timeview AutoCircleWithStartTime:start_Time gapTime:gap_Time];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    switch (self.from) {
        case 1: {
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        default: {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

- (IBAction)AlertMethod:(UIButton *)sender {
    [self showAlert];
}

- (void)showAlert {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"WatingPlanVC_5", nil) message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"WatingPlanVC_6", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self requestCancelPlan];
    }];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"WatingPlanVC_7", nil) style:(UIAlertActionStyleDefault) handler:nil];
    
    [action_1 setValue:kColorRGB(0x666666) forKey:@"titleTextColor"];
    [action_2 setValue:kColorRGB(0x21C9D9) forKey:@"titleTextColor"];
    
    [controller addAction:action_1];
    [controller addAction:action_2];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 取消定制
- (void)requestCancelPlan {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    [SVProgressHUD show];
    [net requestWithUrl:@"former/cancel-appeal" Parames:m_dic Success:^(id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                if ([Tools JumpToLoginVC:responseObject]) {
                    [SVProgressHUD dismiss];
                }
                break;
            }
            case 1: {
                [SVProgressHUD dismiss];
                NSDictionary *da = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                NSInteger cancel = [da[@"cancel"] integerValue];
                if (cancel == 1) {
                    [[UserDefaults shareInstance] CleanPlanRecode];
                    [self.navigationController popToRootViewControllerAnimated:YES];
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
        [SVProgressHUD showErrorWithStatus:mess];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
