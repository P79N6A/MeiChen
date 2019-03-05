//
//  UIScrollView+Cutter.h
//  meirong
//
//  Created by yangfeng on 2018/12/22.
//  Copyright © 2018年 yangfeng. All rights reserved.
//



@interface UIScrollView (Cutter)

/**
 *  根据视图尺寸获取视图截屏（一屏无法显示完整）,适用于UIScrollView UITableviewView UICollectionView UIWebView
 *
 *  @return UIImage 截取的图片
 */
- (UIImage *)scrollViewCutterWithWidth:(CGFloat)width;

@end
