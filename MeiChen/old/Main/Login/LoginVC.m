//
//  LoginVC.m
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "LoginVC.h"
#import "Tools.h"
#import "UserService.h"
#import "WeChat.h"
#import "TabBar.h"
#import "UserData.h"

#define bu_gap 19
#define bu_width 80

// 类拓展
@interface LoginVC () {
    BOOL isSend;
    NSDictionary *WeChatInfo;
    
    UIButton *button2;
    UIView *line2;
}

@property (nonatomic, strong) ByronMethod *method;
@property (nonatomic, strong) WeChat *wechat;
@property (nonatomic, strong) UserService *service;
@property (nonatomic, strong) UserData *user;

@end

@implementation LoginVC

// 懒加载
- (UserService *)service {
    if (_service == nil) {
        _service = [[UserService alloc]init];
    }
    return _service;
}

- (WeChat *)wechat{
    if (_wechat == nil) {
        _wechat = [[WeChat alloc]init];
    }
    return _wechat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"LoginVC viewDidLoad");
    [self initDataWithControl];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    button2.frame = CGRectMake(self.pinTF.frame.size.width - bu_width, 0, bu_width, self.pinTF.frame.size.height);
    line2.frame = CGRectMake(0, self.pinTF.frame.size.height - 0.3, self.pinTF.frame.size.width, 0.3);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!isSend) {
        CGFloat new_y = CGRectGetMaxY(self.phoneTF.frame) + bu_gap;
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, new_y, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.autoAuthorization) {
        [self WeChatAuthorizationMethod:nil];
        self.backImv.hidden = NO;
        self.autoAuthorization = NO;
    }
    else {
        self.backImv.hidden = YES;
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 注册监听事件
    [center addObserver:self selector:@selector(NotificationWithWeChatLogin:) name:WECHAT_NOTIFICATION object:nil]; // 微信授权确定 监听
    [center addObserver:self selector:@selector(NotificationWithWeChatCencelLogin:) name:WECHATCENTER_NOTIFICATION object:nil]; // 微信授权取消 监听
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 移除通知
    [center removeObserver:self];
    [SVProgressHUD dismiss];
}

// 初始化数据
- (void)initDataWithControl {
    
    self.method = [[ByronMethod alloc]init];
    
    self.iconImv.layer.masksToBounds = YES;
    self.iconImv.layer.cornerRadius = self.iconImv.frame.size.width / 2.0;
    
    self.titleLab.text = NSLocalizedString(@"login_1", nil);
    self.phoneTF.placeholder = NSLocalizedString(@"login_2", nil);
    self.pinTF.placeholder = NSLocalizedString(@"login_7", nil);
    self.detailLab.text = NSLocalizedString(@"login_6", nil);
    
    [self.loginButton setTitle:NSLocalizedString(@"login_3", nil) forState:UIControlStateNormal];
    [self.loginButton setTitleColor:kColorRGB(0xcccccc) forState:UIControlStateNormal];
    
    self.loginButton.adjustsImageWhenHighlighted = NO;
    
    self.phoneTF.leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    
    button2 = [[UIButton alloc]init];
    [button2 setTitle:NSLocalizedString(@"login_4", nil) forState:UIControlStateNormal];
    [button2 setTitleColor:kColorRGB(0xcccccc) forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:12];
    [button2 addTarget:self action:@selector(PinButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.pinTF.rightView = button2;
    self.pinTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.pinTF.leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bu_width, 10)];
    self.pinTF.leftViewMode = UITextFieldViewModeAlways;
    
    line2 = [[UIView alloc]init];
    line2.backgroundColor = kColorRGB(0x7284f7);
    [self.pinTF addSubview:line2];
    
    self.pinTF.hidden = YES;
}



#pragma mark - 通知 - 微信用户授权通知
// 微信用户确认授权
- (void)NotificationWithWeChatLogin:(NSNotification *)notification {
    NSString *code = notification.userInfo[@"code"];
    [SVProgressHUD show];
    // 获取微信的accessToken
    [self.wechat AccessTokenWith:code Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject allKeys] containsObject:@"openid"]) {
            WeChatInfo = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *openid = [NSString stringWithFormat:@"%@",responseObject[@"openid"]];
            // 调用微信登录的方法
            [self WeChatLoginWithOpenid:openid];
        }
        if ([[responseObject allKeys] containsObject:@"headimgurl"]) {
            NSURL *iconUrl = [NSURL URLWithString:responseObject[@"headimgurl"]];
            [self.iconImv sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"iconImvDef"]];
        }
    } Failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"svp_1", nil)];
        self.iconImv.image = [UIImage imageNamed:@"iconImvDef"];
        WeChatInfo = nil;
        self.backImv.hidden = YES;
    }];
}
// 微信用户取消授权
- (void)NotificationWithWeChatCencelLogin:(NSNotification *)notification {
    NSLog(@"微信用户取消授权");
    self.iconImv.image = [UIImage imageNamed:@"iconImvDef"];
    WeChatInfo = nil;
    self.backImv.hidden = YES;
}


#pragma mark - TextField方法
// 手机号码输入框内容改变
- (IBAction)PhoneTFEditingChanged:(UITextField *)sender {
    if (([ByronRegular ByronRegularIsMobile:sender.text] && !isSend) ||
        ([ByronRegular ByronRegularIsMobile:sender.text] && self.pinTF.text.length == 4 && isSend)) {
        NSLog(@"手机号正确");
        [self.loginButton setTitleColor:kColorRGB(0x7284f7) forState:UIControlStateNormal];
    }
    else  {
        NSLog(@"手机号不正确 x");
        [self.loginButton setTitleColor:kColorRGB(0x999999) forState:UIControlStateNormal];
    }
}
// 验证码输入框内容改变
- (IBAction)PinEditingChanged:(UITextField *)sender {
    // 只取前面四位
    if (sender.text.length >= 4 && isSend) {
        sender.text = [sender.text substringToIndex:4];
        [self.loginButton setTitleColor:kColorRGB(0x7284f7) forState:UIControlStateNormal];
    }
    else if (isSend) {
        [self.loginButton setTitleColor:kColorRGB(0x999999) forState:UIControlStateNormal];
    }
}


#pragma mark - 按钮方法
// 发送验证码
- (void)PinButtonMethod:(UIButton *)sender {
    NSLog(@"发送验证码");
    
    if (![ByronRegular ByronRegularIsMobile:self.phoneTF.text]) {
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
            [sender setTitleColor:kColorRGB(0x7284f7) forState:UIControlStateNormal];
        });
        
    }];
    
    [SVProgressHUD show];
    
    [self.service sendPinWithPhoneNumber:self.phoneTF.text results:^(BOOL results, NSInteger pin, NSString *message) {
        if (results) {
            [SVProgressHUD dismiss];
            self.pinTF.text = [NSString stringWithFormat:@"%ld",pin];
        }
        else {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }];
}

// 登录按钮
- (IBAction)LoginButtonMethod:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        return;
    }
    if (![ByronRegular ByronRegularIsMobile:self.phoneTF.text]) {
        return;
    }
    
    isSend = YES;
    
    if (self.loginButton.frame.origin.y ==
        CGRectGetMaxY(self.phoneTF.frame) + bu_gap) {
        
        CGRect newRect = self.pinTF.frame;
        self.pinTF.frame = self.phoneTF.frame;
        
        [self PinButtonMethod:button2];
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.loginButton setTitle:NSLocalizedString(@"login_5", nil) forState:UIControlStateNormal];
            
            self.pinTF.hidden = NO;
            self.pinTF.frame = newRect;
            
            self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, CGRectGetMaxY(self.pinTF.frame) + bu_gap, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
            [self.loginButton setTitleColor:kColorRGB(0x999999) forState:UIControlStateNormal];
            
            [self.pinTF becomeFirstResponder];
            
        }];
    }

    if ([ByronRegular ByronRegularIsMobile:self.phoneTF.text] && isSend && self.pinTF.text.length == 4) {
        NSLog(@"login");
        [self PhoneLoign];
    }
    
}

// 微信授权按钮
- (IBAction)WeChatAuthorizationMethod:(UIButton *)sender {
    if ([self.wechat haveWeChat]) {
        [self.wechat sendAuthRequest];
    }
    else {
        NSLog(@"微信应用程序没有安装");
        UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"alert_2", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_1", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.backImv.hidden = YES;
        }];
        
        [control addAction:action];
        [self presentViewController:control animated:YES completion:nil];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

// 微信登录
- (void)WeChatLoginWithOpenid:(NSString *)openid {

    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"openid"] = openid;
    NSLog(@"微信登录 = %@",m_dic);
    [SVProgressHUD show];
    [self.service WeChatLoginWith:m_dic results:^(BOOL results, NSString *accessToken, BOOL signup, NSString *message) {
        if (results) {
            if (signup) {
                [SVProgressHUD dismiss];
                // 跳转到注册界面
                NSLog(@"跳转到注册界面");
                self.backImv.hidden = YES;
            }
            else if (accessToken != nil){
                // 跳转到主页
                [[UserDefaults shareInstance] WriteAccessTokenWith:accessToken];
                [[UserData shareInstance] requestUserData:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    if (error == nil) {
                        [self jumpToHomePage];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:error.description];
                        self.backImv.hidden = YES;
                    }
                }];
            }
            else {
                [SVProgressHUD showErrorWithStatus:message];
                self.backImv.hidden = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:message];
            self.backImv.hidden = YES;
        }
    }];
}

// 手机登录
- (void)PhoneLoign {

    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"mobile"] = self.phoneTF.text;
    m_dic[@"sms_code"] = self.pinTF.text;
    m_dic[@"uuid"] = [ByronMethod getUUID];
    
    if (WeChatInfo) {
        if ([[WeChatInfo allKeys] containsObject:@"headimgurl"]) {
            m_dic[@"avatar"] = [NSString stringWithFormat:@"%@",WeChatInfo[@"headimgurl"]];
        }
        if ([[WeChatInfo allKeys] containsObject:@"nickname"]) {
            m_dic[@"nickname"] = [NSString stringWithFormat:@"%@",WeChatInfo[@"nickname"]];
        }
        if ([[WeChatInfo allKeys] containsObject:@"openid"]) {
            m_dic[@"openid"] = [NSString stringWithFormat:@"%@",WeChatInfo[@"openid"]];
        }
    }
    
    NSLog(@"手机登录 = %@",m_dic);
    [SVProgressHUD show];
    [self.service MobileLoginWith:m_dic results:^(BOOL results, NSString *accessToken, NSString *message) {
        if (results) {
            NSLog(@"accessToken = %@",accessToken);
            // 跳转到主页
            [[UserDefaults shareInstance] WriteAccessTokenWith:accessToken];
            [[UserData shareInstance] requestUserData:^(NSError *error) {
                [SVProgressHUD dismiss];
                // 取消倒计时
                [self.method cancelTimer];
                [[UserDefaults shareInstance] WriteAccessTokenWith:accessToken];
                
                if (error == nil) {
                    [self jumpToHomePage];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:error.description];
                    self.backImv.hidden = YES;
                }
            }];
        }
        else {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }];
}

- (void)jumpToHomePage {
    TabBar *vc = [[TabBar alloc]init];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    windows.rootViewController = vc;
    [windows makeKeyAndVisible];
}

//
//- (IBAction)UserMessageMethod:(UIButton *)sender {
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = access_Token;
//    NSLog(@"用户信息 = %@",m_dic);
//
//    [self.service UserMessageWith:m_dic results:^(BOOL results, UserModel *usermodel, NSString *message) {
//        if (results) {
//            [UserModel LogUserModel:usermodel];
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:message];
//        }
//    }];
//}
//
//
//
//- (IBAction)LoginOut:(UIButton *)sender {
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = access_Token;
//    NSLog(@"用户登出 = %@",m_dic);
//
//    [self.service LoginOutWith:m_dic results:^(BOOL results, NSString *message) {
//        if (results) {
//            NSLog(@"登出成功");
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:message];
//        }
//    }];
//}
//
//- (IBAction)UserMessageChange:(UIButton *)sender {
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = access_Token;
//    m_dic[@"avatar"] = @"avatar_1";
//    m_dic[@"nickname"] = @"nickname_1";
//    m_dic[@"motto"] = @"motto_1";
//    NSLog(@"用户信息修改 = %@",m_dic);
//
//    [self.service ModifyUserMessageWith:m_dic results:^(BOOL results, NSString *message) {
//        if (results) {
//            NSLog(@"用户信息修改成功");
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:message];
//        }
//    }];
//}
//
//
//- (IBAction)PhoneNumberChange:(UIButton *)sender {
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = access_Token;
//    m_dic[@"current_mobile"] = @"18002265157";
//    m_dic[@"new_mobile"] = @"18318206223";
//    m_dic[@"sms_code"] = pinStr;
//    m_dic[@"uuid"] = [ByronMethod getUUID];
//    NSLog(@"用户手机修改 = %@",m_dic);
//
//    [self.service ModifyMobileWith:m_dic results:^(BOOL results, NSString *message) {
//        if (results) {
//            NSLog(@"用户手机修改成功");
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:message];
//        }
//    }];
//}

- (IBAction)AppFirstPage:(UIButton *)sender {
    
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
//
//    [self.service2 request:m_dic callback:^(HomeModel *model, NSError *error) {
//        if (error == nil) {
//            NSLog(@"获取首页 热门案例分类 success");
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:error.description];
//        }
//    }];
}

- (IBAction)TagSearchMethod:(UIButton *)sender {
    
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
//    m_dic[@"key_word"] = @"换";
//
//    [self.service2 requestTag:m_dic callback:^(NSArray<ListModel *> *array, NSError *error) {
//        if (error == nil) {
//            NSLog(@"获取 标签搜索案例 success");
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:error.description];
//        }
//    }];
}


- (void)dealloc {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
