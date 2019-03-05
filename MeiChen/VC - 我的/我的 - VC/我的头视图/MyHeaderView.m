//
//  MyHeaderView.m
//  meirong
//
//  Created by yangfeng on 2019/1/29.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyHeaderView" owner:nil options:nil] firstObject];
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        self.frame = (CGRect){0,0,statusRect.size.width,232};
        self.backgroundColor = [UIColor clearColor];
        
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = self.icon.frame.size.width / 2.0;
        
        _backView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backView.layer.shadowOpacity = 0.3;
        _backView.layer.shadowOffset = CGSizeMake(0,0);
        _backView.layer.shadowRadius = 2;
        _backView.clipsToBounds = NO;
        _backView.layer.cornerRadius = 10.0;
        
        [self loadButton_1:NSLocalizedString(@"MyVC_1", nil)];
        [self loadButton_2:NSLocalizedString(@"MyVC_2", nil)];
        [self loadTitltLabel:NSLocalizedString(@"MyVC_3", nil)];
    }
    return self;
}

// 加载头像
- (void)loadIcon:(NSString *)str {
    [self.iconImv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    self.iconImv.backgroundColor = [UIColor clearColor];
    self.iconImv.layer.masksToBounds = YES;
    self.iconImv.layer.cornerRadius = self.iconImv.frame.size.height / 2.0;
}
// 加载昵称
- (void)loadName:(NSString *)str {
    self.name.text = str;
    self.name.backgroundColor = [UIColor clearColor];
}
// 加载介绍
- (void)loadDetail:(NSString *)str {
    self.detail.text = str;
    self.detail.backgroundColor = [UIColor clearColor];
}
// 专属方案
- (void)loadButton_1:(NSString *)str {
    [self.bu_1 setTitle:[NSString stringWithFormat:@"  %@",str] forState:UIControlStateNormal];
    self.bu_1.backgroundColor = [UIColor clearColor];
}
// 我的服务
- (void)loadButton_2:(NSString *)str {
    [self.bu_2 setTitle:[NSString stringWithFormat:@"  %@",str] forState:UIControlStateNormal];
    self.bu_2.backgroundColor = [UIColor clearColor];
}
// 我的变美过程
- (void)loadTitltLabel:(NSString *)str {
    self.titleLab.text = str;
    self.titleLab.backgroundColor = [UIColor clearColor];
}

- (void)LoadUserData {
    if ([UserData shareInstance].user != nil) {
        [self loadIcon:[UserData shareInstance].user.avatar];
        [self loadName:[UserData shareInstance].user.nickname];
        [self loadDetail:[UserData shareInstance].user.motto];
    }
}

@end
