//
//  ByronImage.h
//  ByronMethodKit
//
//  Created by 杨峰 on 2018/11/1.
//  Copyright © 2018年 杨峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ByronImage : NSObject

// 判断是否为gif图片
- (BOOL)ByronImageIsGifTypeWithUrlString:(NSString *)urlStr;

// 判断是否为png图片
- (BOOL)ByronImageIsPngTypeWithUrlString:(NSString *)urlStr;

// 判断是否为gif/png图片
- (BOOL)ByronImageIsGifOrPngTypeWithUrlString:(NSString *)urlStr;

// 通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)ByronImageContentTypeForImageData:(NSData *)data;

// 使用了贝塞尔曲线"切割"个这个图片, 给UIImageView 添加了的圆角
- (void)CircleImageView:(UIImageView *)imageView image:(UIImage *)image radius:(NSInteger)radius;

@end
