//
//  UIScrollView+Cutter.m
//  meirong
//
//  Created by yangfeng on 2018/12/22.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "UIScrollView+Cutter.h"

@implementation UIScrollView (Cutter)

/**
 *  根据视图尺寸获取视图截屏（一屏无法显示完整）,适用于UIScrollView UITableviewView UICollectionView UIWebView
 *
 *  @return UIImage 截取的图片
 */
- (UIImage *)scrollViewCutterWithWidth:(CGFloat)width
{
    //保存
    CGPoint savedContentOffset = self.contentOffset;
    CGRect savedFrame = self.frame;
    self.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, width, self.contentSize.height);
    UIImage *image = [self viewCutter];
    //还原数据
    self.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    return image;
}

@end
