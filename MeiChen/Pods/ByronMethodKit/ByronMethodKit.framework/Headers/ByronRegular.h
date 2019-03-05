//
//  ByronRegular.h
//  ByronMethodKit
//
//  Created by 杨峰 on 2018/12/17.
//  Copyright © 2018年 杨峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByronRegular : NSObject

//判断手机号码格式是否正确
+ (BOOL)ByronRegularIsMobile:(NSString *)mobile;

// 判断字符串是否全为数字
+ (BOOL)ByronRegularIsAllNumber:(NSString *)str;

@end
