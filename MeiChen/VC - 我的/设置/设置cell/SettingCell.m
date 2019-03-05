//
//  SettingCell.m
//  meirong
//
//  Created by yangfeng on 2019/2/21.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SettingCell.h"
#import "UserService.h"
#import "LoginVC.h"

@interface SettingCell () {
    NSString *imvStr;
}

@end

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.hidden = YES;
    self.quit.hidden = YES;
    self.message.hidden = NO;
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.width / 2.0;
    
    self.message.backgroundColor = [UIColor clearColor];
    self.message.layer.masksToBounds = YES;
    self.message.layer.cornerRadius = 0;
    self.message.textColor = kColorRGB(0x999999);
    
    self.icon.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(TagMethod:)];
    //为图片添加手势
    [self.icon addGestureRecognizer:tap];
}

//点击事件
- (void)TagMethod:(UIGestureRecognizer *)tap {
    NSLog(@"imvStr = %@",imvStr);
    if (imvStr != nil) {
        //具体的实现
        [[imageBrowser shareInstance] showImagesWith:@[imvStr] index:0];
    }
}

- (void)loadImvUrl:(NSString *)url {
    imvStr = url;
}

- (IBAction)QuitMethod:(UIButton *)sender {
    [self LoginOutMethod:nil];
}

- (void)LoginOutMethod:(UIButton *)sender {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    NSLog(@"用户登出 = %@",m_dic);
    UserService *service = [[UserService alloc]init];
    [SVProgressHUD show];
    [service LoginOutWith:m_dic results:^(BOOL results, NSString *message) {
        if (results) {
            NSLog(@"登出成功");
            [[UserDefaults shareInstance] WriteAccessTokenWith:nil];
            NSLog(@"登出成功 = %@",[[UserDefaults shareInstance] ReadAccessToken]);
            LoginVC *vc = [[LoginVC alloc]init];
            vc.autoAuthorization = NO;
            UIWindow *windows = [UIApplication sharedApplication].keyWindow;
            windows.rootViewController = vc;
            [windows makeKeyAndVisible];
        }
        else {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
