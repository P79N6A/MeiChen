//
//  WeChatLogin.h
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <WXApi.h>

@interface WeChat : NSObject <WXApiDelegate>

- (BOOL)haveWeChat;

// 请求CODE  移动应用微信授权登录
-(void)sendAuthRequest;

// 通过code获取access_token
- (void)AccessTokenWith:(NSString *)code Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask;

// 刷新access_token
- (void)RefreshToken:(NSString *)refreshToken;

#pragma mark - 微信分享
- (void)WeChatShareImage:(UIImage *)image;

@end
