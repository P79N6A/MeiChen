//
//  ChangeNameVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ChangeNameVC.h"

@interface ChangeNameVC () <CustomNavViewDelegate, UITextFieldDelegate> {
    NetWork *net;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITextField *tf;

@end

@implementation ChangeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self BUildUI];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = kColorRGB(0xf0f0f0);
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;

    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ChangeNameVC_1", nil);
    self.navview.line.hidden = NO;
    [self.navview.rightItem setTitle:NSLocalizedString(@"ChangeNameVC_2", nil) forState:UIControlStateNormal];
    [self isRightItem:NO];
    self.navview.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
    [self.view addSubview:self.navview];
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(0, y+10, width, 50)];
    self.tf.backgroundColor = [UIColor whiteColor];
    self.tf.clearButtonMode = UITextFieldViewModeAlways;
    self.tf.delegate = self;
    
    UILabel *leflab = [[UILabel alloc]init];
    leflab.frame = CGRectMake(0, 0, 80, self.tf.frame.size.height);
    leflab.text = NSLocalizedString(@"ChangeNameVC_3", nil);
    leflab.textColor = kColorRGB(0x333333);
    leflab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    leflab.textAlignment = NSTextAlignmentCenter;
    
    self.tf.leftView = leflab;
    self.tf.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf.text = [UserData shareInstance].user.nickname;
    [self.tf becomeFirstResponder];
    [self.tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.navview.rightItem.enabled = NO;
    
    [self.view addSubview:self.tf];
}

- (void)textFieldDidChange:(id)sender {
    [self isUserName:self.tf.text];
}

- (void)isRightItem:(BOOL)is {
    if (is) {
        [self.navview.rightItem setTitleColor:kColorRGB(0x21C9D9) forState:UIControlStateNormal];
        self.navview.rightItem.enabled = YES;
    }
    else {
        [self.navview.rightItem setTitleColor:kColorRGB(0x666666) forState:UIControlStateNormal];
        self.navview.rightItem.enabled = NO;
    }
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    if (![self isUserName:self.tf.text]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"SettingVC_12", nil)];
        return;
    }
    [self requestUserDataWith:[UserData shareInstance].user.avatar nickname:self.tf.text motto:[UserData shareInstance].user.motto];
}

- (BOOL)isUserName:(NSString *)testString {
    // 判定输入框不为空格以及空
    NSString *textField=[self.tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([textField length] == 0) {
        [self isRightItem:NO];
        return NO;
    }
    
    NSInteger maxCount = 15;
    if (self.tf.text.length > maxCount) {
        // 超出限制字数时所要做的事
        self.tf.text = [self.tf.text substringToIndex:maxCount];
    }
    
    if (self.tf.text.length > 1 &&
             self.tf.text.length <= maxCount) {
        [self isRightItem:YES];
        return YES;
    }
    [self isRightItem:NO];
    return NO;
}

- (void)requestUserDataWith:(NSString *)avatar nickname:(NSString *)nickname motto:(NSString *)motto {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"avatar"] = avatar;
    m_dic[@"nickname"] = nickname;
    m_dic[@"motto"] = motto;
    NSLog(@"更新用户信息 m_dic = %@",m_dic);
    [SVProgressHUD show];
    [net requestWithUrl:@"member/update" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"更新用户信息 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [[UserData shareInstance] requestUserData:^(NSError *error) {
                    NSLog(@"error = %@",error);
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






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
