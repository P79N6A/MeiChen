//
//  ChangePhoneVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ChangePhoneVC.h"
#import "UserService.h"

@interface ChangePhoneVC () <CustomNavViewDelegate> {
    NetWork *net;
}
@property (nonatomic, strong) ByronMethod *method;
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITextField *tf_1;
@property (nonatomic, strong) UIButton *pin;
@property (nonatomic, strong) UITextField *tf_2;
@property (nonatomic, strong) UIButton *queue;
@property (nonatomic, strong) UserService *service;
@end



@implementation ChangePhoneVC

// 懒加载
- (UserService *)service {
    if (_service == nil) {
        _service = [[UserService alloc]init];
    }
    return _service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.method = [[ByronMethod alloc]init];
    net = [[NetWork alloc]init];
    [self BUildUI];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = kColorRGB(0xf0f0f0);
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;
    // 1
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ChangePhone_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    // 2
    UILabel *lab_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, y, width, 40)];
    lab_1.text = [UserData shareInstance].user.mobile;
    lab_1.textColor = kColorRGB(0x21C9D9);
    lab_1.font = [UIFont fontWithName:@"PingFang-SC-Bold" size: 20];
    lab_1.textAlignment = NSTextAlignmentCenter;
    lab_1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lab_1];
    // 3
    UILabel *lab_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_1.frame), width, 15)];
    lab_2.text = NSLocalizedString(@"ChangePhone_2", nil);
    lab_2.textColor = kColorRGB(0x333333);
    lab_2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    lab_2.textAlignment = NSTextAlignmentCenter;
    lab_2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lab_2];
    // 3_1
    UILabel *lab_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_2.frame), width, 20)];
    lab_3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lab_3];
    // 4
    self.tf_1 = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_3.frame)+10, width, 50)];
    self.tf_1.backgroundColor = [UIColor whiteColor];
    self.tf_1.clearButtonMode = UITextFieldViewModeAlways;
    UILabel *leflab = [[UILabel alloc]init];
    leflab.frame = CGRectMake(0, 0, 80, self.tf_1.frame.size.height);
    leflab.text = NSLocalizedString(@"ChangePhone_3", nil);
    leflab.textColor = kColorRGB(0x333333);
    leflab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    leflab.textAlignment = NSTextAlignmentCenter;
    self.tf_1.leftView = leflab;
    self.tf_1.leftViewMode = UITextFieldViewModeAlways;
    self.pin = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, self.tf_1.frame.size.height)];
    [self.pin setTitle:NSLocalizedString(@"ChangePhone_5", nil) forState:(UIControlStateNormal)];
    [self.pin setTitleColor:kColorRGB(0x21C9D9) forState:(UIControlStateNormal)];
    self.pin.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    [self.pin addTarget:self action:@selector(PinMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tf_1.rightView = self.pin;
    self.tf_1.rightViewMode = UITextFieldViewModeAlways;
    self.tf_1.placeholder = NSLocalizedString(@"ChangePhone_6", nil);
    [self.view addSubview:self.tf_1];
    // 5
    UIView *line_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tf_1.frame), width, 1)];
    line_1.backgroundColor = kColorRGB(0xf0f0f0);
    [self.view addSubview:line_1];
    // 6
    self.tf_2 = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line_1.frame), width, 50)];
    self.tf_2.backgroundColor = [UIColor whiteColor];
    self.tf_2.clearButtonMode = UITextFieldViewModeAlways;
    UILabel *leflab_2 = [[UILabel alloc]init];
    leflab_2.frame = CGRectMake(0, 0, 80, self.tf_1.frame.size.height);
    leflab_2.text = NSLocalizedString(@"ChangePhone_4", nil);
    leflab_2.textColor = kColorRGB(0x333333);
    leflab_2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    leflab_2.textAlignment = NSTextAlignmentCenter;
    self.tf_2.leftView = leflab_2;
    self.tf_2.leftViewMode = UITextFieldViewModeAlways;
    self.tf_2.placeholder = NSLocalizedString(@"ChangePhone_7", nil);
    [self.view addSubview:self.tf_2];
    // 7
    CGFloat left = 16;
    self.queue = [[UIButton alloc]initWithFrame:CGRectMake(left, CGRectGetMaxY(self.tf_2.frame)+30, width-left*2, 45)];
    [self.queue setTitle:NSLocalizedString(@"ChangePhone_8", nil) forState:(UIControlStateNormal)];
    [self.queue setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.queue setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:(UIControlStateNormal)];
    [self.queue addTarget:self action:@selector(QueueButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    self.queue.layer.masksToBounds = YES;
    self.queue.layer.cornerRadius = self.queue.frame.size.height / 2.0;
    self.queue.backgroundColor = kColorRGB(0xDBDBDB);
    [self.view addSubview:self.queue];
}

- (void)QueueButtonMethod:(UIButton *)button {
    if (self.tf_1.text.length == 0) {
        return;
    }
    if (![ByronRegular ByronRegularIsMobile:self.tf_1.text]) {
        return;
    }
    [self requestChangePhone:self.tf_1.text sms:self.tf_2.text];
}

- (void)PinMethod:(UIButton *)sender {
    if (![ByronRegular ByronRegularIsMobile:self.tf_1.text]) {
        return;
    }
    sender.enabled = NO;
    [self.method countDownWithTime:59 countDownUnderway:^(NSInteger restCountDownNum) {
        NSMutableString *m_str = [NSMutableString string];
        [m_str appendString:NSLocalizedString(@"login_4", nil)];
        [m_str appendString:[NSString stringWithFormat:@"(%ld)",restCountDownNum]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setTitle:m_str forState:UIControlStateNormal];
            [sender setTitleColor:kColorRGB(0xcccccc) forState:UIControlStateNormal];
        });
    } countDownCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [sender setTitle:NSLocalizedString(@"login_4", nil) forState:UIControlStateNormal];
            [sender setTitleColor:kColorRGB(0x21C9D9) forState:UIControlStateNormal];
        });
    }];
    
    [SVProgressHUD show];
    
    [self.service sendPinWithPhoneNumber:self.tf_1.text results:^(BOOL results, NSInteger pin, NSString *message) {
        if (results) {
            [SVProgressHUD dismiss];
            self.tf_2.text = [NSString stringWithFormat:@"%ld",pin];
        }
        else {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }];
}

- (void)requestChangePhone:(NSString *)mobile sms:(NSString *)sms {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"current_mobile"] = [UserData shareInstance].user.mobile;
    m_dic[@"new_mobile"] = mobile;
    m_dic[@"sms_code"] = sms;
    m_dic[@"uuid"] = [ByronMethod getUUID];
    NSLog(@"更新手机号码 m_dic = %@",m_dic);
    [SVProgressHUD show];
    [net requestWithUrl:@"member/mobile-reset" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"更新手机号码 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [[UserData shareInstance] requestUserData:^(NSError *error) {
                    if (error == nil) {
                        [SVProgressHUD dismiss];
                        [self CustomNavView_LeftItem:nil];
                    }
                    else {
                        [SVProgressHUD showInfoWithStatus:error.description];
                    }
                }];
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
        [SVProgressHUD showInfoWithStatus:error.description];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.description];
    }];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
