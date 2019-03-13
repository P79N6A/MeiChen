//
//  UIImage+ImgSize.h
//  meirong
//
//  Created by yangfeng on 2018/12/26.
//  Copyright © 2018年 yangfeng. All rights reserved.
//



@interface UIImage (ImgSize)
+ (CGSize)getImageSizeWithURL:(id)URL;

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

+ (UIImage *)imageWithBgColor:(UIColor *)color;

//+ (UIImage *)imageWithlineColor:(UIColor *)color;

@end
