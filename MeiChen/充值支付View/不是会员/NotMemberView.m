//
//  NotMemberView.m
//  meirong
//
//  Created by yangfeng on 2019/3/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "NotMemberView.h"

@interface NotMemberView () {
    CGRect oldFrame;
    CGRect newFrame;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation NotMemberView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NotMemberView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 245.0/667.0*height;
        oldFrame = CGRectMake(0, height, width, vi_h);
        newFrame = CGRectMake(0, height-vi_h, width, vi_h);
        self.frame = oldFrame;
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.titleLab.text = NSLocalizedString(@"ChongZhi_11", nil);
        self.message.text = NSLocalizedString(@"ChongZhi_12", nil);
        [self.select_1 setTitle:NSLocalizedString(@"ChongZhi_4", nil) forState:(UIControlStateNormal)];
        [self.select_2 setTitle:NSLocalizedString(@"ChongZhi_10", nil) forState:(UIControlStateNormal)];
        [self.queue setTitle:NSLocalizedString(@"ChongZhi_5", nil) forState:(UIControlStateNormal)];
    
        self.select_1.selected = NO;
        self.select_2.selected = YES;
    }
    return self;
}



- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.select_1.selected = NO;
        self.select_2.selected = YES;

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        [window addSubview:self.backButton];
        [window addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = newFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    });
}

- (void)hide:(BOOL)remove {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = oldFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            if (remove) {
                [self removeFromSuperview];
                [self.backButton removeFromSuperview];
            }
        }];
    });
}

- (void)HideMethod:(UIButton *)sender {
    [self hide:YES];
}

- (IBAction)CloseMethod:(UIButton *)sender {
    [self hide:YES];
}

- (IBAction)SelectMethod_1:(UIButton *)sender {
    self.select_2.selected = NO;
    self.select_1.selected = YES;
}

- (IBAction)SelectMethod_2:(UIButton *)sender {
    self.select_1.selected = NO;
    self.select_2.selected = YES;
}

- (IBAction)QueueMethod:(UIButton *)sender {
    if (self.select_1.selected) {
        NSLog(@"线下支付");
        if (self.index) {
            self.index(0);
        }
    }
    else {
        if (self.index) {
            self.index(1);
        }
    }
}

@end
