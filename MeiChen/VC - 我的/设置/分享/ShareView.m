//
//  ShareView.m
//  meirong
//
//  Created by yangfeng on 2019/2/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ShareView.h"

@interface ShareView () {
    CGRect oldFrame;
    CGRect newFrame;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ShareView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 165;
        oldFrame = CGRectMake(0, height, width, vi_h);
        newFrame = CGRectMake(0, height-vi_h, width, vi_h);
        self.frame = oldFrame;

        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];

        self.lab_1.text = NSLocalizedString(@"SettingVC_13", nil);
        self.lab_2.text = NSLocalizedString(@"SettingVC_14", nil);
        self.lab_3.text = NSLocalizedString(@"SettingVC_15", nil);
        self.lab_4.text = NSLocalizedString(@"SettingVC_16", nil);
        self.lab_5.text = NSLocalizedString(@"SettingVC_17", nil);
        
        self.titleLab.text = NSLocalizedString(@"SettingVC_18", nil);
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    [window addSubview:self.backButton];
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = newFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = oldFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backButton removeFromSuperview];
    }];
}

- (void)HideMethod:(UIButton *)sender {
    [self hide];
}

- (IBAction)ButtonMethod:(UIButton *)sender {
    if (self.index) {
        self.index(sender.tag);
    }
}


- (IBAction)CloseMethod:(UIButton *)sender {
    [self hide];
}


@end
