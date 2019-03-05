//
//  ShowIcon.m
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ShowIcon.h"

@interface ShowIcon () {
    UIImageView *imView;
    CGRect oldFrame;
    CGFloat radius;
}
@end

@implementation ShowIcon

- (void)ShowIconImageFromImv:(UIImageView *)imv {
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    oldFrame = [imv convertRect:imv.bounds toView:windows];
    radius = imv.layer.cornerRadius;
    
    imView = [[UIImageView alloc]initWithFrame:oldFrame];
    imView.backgroundColor = [UIColor blackColor];
    imView.contentMode = imv.contentMode;
    imView.image = imv.image;
    imView.layer.masksToBounds = YES;
    imView.layer.cornerRadius = radius;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod)];
    imView.userInteractionEnabled = YES;
    [imView addGestureRecognizer:tapGesture];
    
    [windows addSubview:imView];
    [windows bringSubviewToFront:imView];
    
    [UIView animateWithDuration:0.3 animations:^{
        imView.frame = ({
            CGRect frame = oldFrame;
            frame.size = [UIScreen mainScreen].bounds.size;
            frame.origin = CGPointMake(0, 0);
            frame;
        });
        imView.layer.cornerRadius = 0.0;
    }];
}

- (void)ImageViewMethod {
    [UIView animateWithDuration:0.3 animations:^{
        imView.frame = oldFrame;
        imView.layer.cornerRadius = radius;
    } completion:^(BOOL finished) {
        [imView removeFromSuperview];
    }];
}


@end
