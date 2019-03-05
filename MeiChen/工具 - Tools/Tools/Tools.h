//
//  Tools.h
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (instancetype)shareInstance;

+ (void)SetSVProgressHUD;

+ (BOOL)JumpToLoginVC:(id)response;

/** 分享 */
+ (void)mq_share:(NSArray *)items target:(id)target;

// 保存图片
+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName;

// 取出图片
+ (UIImage *)getImageWithName:(NSString *)imageName;

// 保存日志文件
+ (void)redirectFileToDocumentFolder:(NSDictionary *)diction filename:(NSString *)filename;

// 计算字符串尺寸
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string;

@end
