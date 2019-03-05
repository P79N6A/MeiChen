//
//  UserService.h
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserService : NSObject

// 获取验证码
- (void)sendPinWithPhoneNumber:(NSString *)phone results:(void (^)(BOOL results, NSInteger pin,NSString *message))results;

// 微信登录
- (void)WeChatLoginWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *accessToken, BOOL signup, NSString *message))results;

// 手机登录
- (void)MobileLoginWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *accessToken, NSString *message))results;

// 用户登出
- (void)LoginOutWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *message))results;

// 用户手机修改
- (void)ModifyMobileWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *message))results;

@end
