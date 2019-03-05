//
//  imageBrowser.m
//  meirong
//
//  Created by yangfeng on 2019/1/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "imageBrowser.h"

@interface imageBrowser () <UIScrollViewDelegate> {
    CGFloat gap;
}

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UILabel *lab;

@end

@implementation imageBrowser

+ (instancetype)shareInstance {
    static imageBrowser *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[imageBrowser alloc]init];
    });
    return tools;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = ({
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = frame.size.width;
            frame;
        });
        gap = 5.0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)addUI {
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(-gap, 0, CGRectGetWidth(self.frame) + gap * 2, CGRectGetHeight(self.frame))];
    self.scroll.delegate = self;
    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.pagingEnabled = YES;
    
    CGFloat lab_h = 15;
    CGFloat left = 20;
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(left, CGRectGetHeight(self.frame) - left - lab_h, CGRectGetWidth(self.frame) - left * 2, lab_h)];
    self.lab.backgroundColor = [UIColor clearColor];
    self.lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    self.lab.textColor = [UIColor whiteColor];
    
    [self addSubview:self.scroll];
    [self addSubview:self.lab];
}

- (void)showImagesWith:(NSArray *)array index:(NSInteger)index {
    [self showImageBrowserWith:array index:index];
}

// 图片地址
- (void)showImageBrowserWith:(NSArray *)array index:(NSInteger)index {
    if (array.count == 0) {
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self addUI];
    [self.scroll setContentOffset:CGPointMake(index * CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame)) animated:NO];
    for (int i = 0; i < array.count; i ++) {
        CGRect rect = ({
            CGRect fr = self.scroll.frame;
            fr.origin.x = i * self.scroll.frame.size.width + gap;
            fr.origin.y = 0;
            fr.size.width = self.frame.size.width;
            fr;
        });
        id obj = array[i];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:rect];
        imv.backgroundColor = [UIColor clearColor];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        if ([obj isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:array[i]];
            [imv sd_setImageWithURL:url];
        }
        else if ([obj isKindOfClass:[UIImage class]]) {
            imv.image = obj;
        }
        imv.userInteractionEnabled = YES;
        
        // 点击手势
        UITapGestureRecognizer *tapGesture_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageBrowser)];
        [imv addGestureRecognizer:tapGesture_1];
        
        [self.scroll addSubview:imv];
    }
    self.scroll.contentSize = CGSizeMake(array.count * CGRectGetWidth(self.scroll.frame), CGRectGetHeight(self.scroll.frame));
    
    [self CurrentLabelTitle:index];

    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:self];
    [windows bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = [UIScreen mainScreen].bounds;
    }];
}

- (void)hideImageBrowser {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = ({
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = frame.size.width;
            frame;
        });
    } completion:^(BOOL finished) {
        [self.lab removeFromSuperview];
        [self.scroll removeFromSuperview];
    }];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger k = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self CurrentLabelTitle:k];
}

- (void)CurrentLabelTitle:(NSInteger)index {
    NSInteger k = self.scroll.contentSize.width / self.scroll.frame.size.width;
    self.lab.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, k];
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    NSLog(@"处理缩放手势");
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

@end
