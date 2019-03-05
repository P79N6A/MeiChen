//
//  ExampleView.m
//  meirong
//
//  Created by yangfeng on 2019/1/28.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExampleView.h"

@interface ExampleView () <UIScrollViewDelegate> {
    CGFloat gap;
    BOOL isload;
}
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIPageControl *page;
@end

@implementation ExampleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.frame = ({
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = frame.size.width;
            frame;
        });
        gap = 5.0;
    }
    return self;
}

- (void)buildUI:(NSInteger)count {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    UILabel *lab_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, bounds.size.width, 18)];
    lab_1.text = self.titleStr;
    lab_1.textColor = [UIColor whiteColor];
    lab_1.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 20];
    lab_1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab_1];
    
    UILabel *lab_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_1.frame) + 20, bounds.size.width, 15)];
    lab_2.text = self.messageStr;
    lab_2.textColor = [UIColor whiteColor];
    lab_2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    lab_2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab_2];
    
    CGFloat scr_w = CGRectGetWidth(bounds) + gap * 2;
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(-gap, (bounds.size.height - scr_w) / 2.0, scr_w, scr_w)];
    self.scroll.delegate = self;
    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.pagingEnabled = YES;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scroll];
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scroll.frame), bounds.size.width, 20)];
    self.page.numberOfPages = count;
    self.page.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.page.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.page.currentPage = 0;
    [self addSubview:self.page];
    
    CGFloat bu_h = 50;
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake((bounds.size.width - bu_h) / 2.0, bounds.size.height - bu_h - 40, bu_h, bu_h)];
    [bu setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(CloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bu];
}

- (void)ShowImages:(NSArray *)array {
    [self buildUI:array.count];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    for (int i = 0; i < array.count; i ++) {
        CGRect rect = ({
            CGRect fr = self.scroll.frame;
            fr.origin.x = i * self.scroll.frame.size.width + gap;
            fr.origin.y = 0;
            fr.size.width = width;
            fr.size.height = width;
            fr;
        });
        NSString *model = array[i];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:rect];
        imv.backgroundColor = [UIColor clearColor];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.userInteractionEnabled = YES;
        [imv sd_setImageWithURL:[NSURL URLWithString:model]];
        [self.scroll addSubview:imv];
    }
    self.scroll.contentSize = CGSizeMake(array.count * CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame));
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:self];
    [windows bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = [UIScreen mainScreen].bounds;
    }];
}

- (void)HideImages {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = ({
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = frame.size.width;
            frame;
        });
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)CloseButtonMethod:(UIButton *)sender {
    [self HideImages];
}

- (void)CloseButton {
    [self HideImages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger k = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.page.currentPage = k;
}

@end
