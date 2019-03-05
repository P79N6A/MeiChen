//
//  UIView+Cutter.m
//  meirong
//
//  Created by yangfeng on 2018/12/22.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "UIView+Cutter.h"

@implementation UIView (Cutter)

/**
 *  根据视图尺寸获取视图截屏
 *
 *  @return UIImage 截取的图片
 */
- (UIImage*)viewCutter
{
    NSLog(@"self.bounds.size w = %f, h = %f", self.bounds.size.width, self.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[[UIScreen mainScreen] scale]);
    
    // 方法一 有时导航条无法正常获取
    // [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 方法二 iOS7.0 后推荐使用
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}


@end
