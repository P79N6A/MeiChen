//
//  WeChatLogin.m
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "WeChat.h"

/****************微信登录***************
 1、在微信开放平台注册开发者帐号，并拥有一个已审核通过的移动应用，获得 AppID 和 AppSecret
 2、第三方发起微信授权登录请求，微信用户允许授权第三方应用后，微信会拉起应用或重定向到第三方网站，并且带上授权临时票据code参数；
 3、通过code参数加上AppID和AppSecret等，通过API换取access_token；
 4、通过access_token进行接口调用，获取用户基本数据资源或帮助用户实现基本操作。
 
 *************************************/


@implementation WeChat

- (BOOL)haveWeChat {
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"支持微信");
        return YES;
    }
    NSLog(@"不支持微信");
    return NO;
}

// 请求CODE  移动应用微信授权登录
-(void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";     // 应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.state = @"123"; // 用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

// 通过code获取access_token
- (void)AccessTokenWith:(NSString *)code Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask {
    
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid="];
    [m_str appendString:APPID];
    [m_str appendString:@"&secret="];
    [m_str appendString:SECRET];
    [m_str appendString:@"&code="];
    [m_str appendString:code];
    [m_str appendString:@"&grant_type="];
    [m_str appendString:@"authorization_code"];
    
    [[self class] RequestWith:@"GET" url:m_str Success:^(id responseObject) {
        NSLog(@"通过code获取access_token = %@",responseObject);
        NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *reAccessToken = [refreshDict objectForKey:@"access_token"];
        if (reAccessToken) {
            NSString *open_id = [NSString stringWithFormat:@"%@",responseObject[@"openid"]];
            // 获取微信用户信息
            [self WeChatUserInfoMessageWithAccessToken:reAccessToken openid:open_id Success:^(id responseObject) {
                successTask(responseObject);
            } Failure:^(NSError *error) {
                failureTask(error);
            }];
        }
        else {
            NSLog(@"access_token 过期 = %@",responseObject);
            [self sendAuthRequest];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@"通过code获取access_token error = %@",error);
        failureTask(error);
    }];
}

// 刷新access_token
- (void)RefreshToken:(NSString *)refreshToken {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid="];
    [m_str appendString:APPID];
    [m_str appendString:@"&grant_type="];
    [m_str appendString:@"refresh_token"];
    [m_str appendString:@"&refresh_token="];
    [m_str appendString:refreshToken];
    
    [[self class] RequestWith:@"GET" url:m_str Success:^(id responseObject) {
        NSLog(@"刷新access_token = %@",responseObject);
        
    } Failure:^(NSError *error) {
        NSLog(@"刷新access_token error = %@",error);
    }];
}

// 获取微信用户信息
- (void)WeChatUserInfoMessageWithAccessToken:(NSString *)accessToken openid:(NSString *)openid Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask{
    
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:@"https://api.weixin.qq.com/sns/userinfo?access_token="];
    [m_str appendString:accessToken];
    [m_str appendString:@"&openid="];
    [m_str appendString:openid];
    
    [[self class] RequestWith:@"GET" url:m_str Success:^(id responseObject) {
        NSLog(@"获取微信用户信息 = %@",responseObject);
        successTask(responseObject);
        
    } Failure:^(NSError *error) {
        NSLog(@"获取微信用户信息 error = %@",error);
        failureTask(error);
    }];
}


#pragma mark 微信网络请求
+ (NSURLSessionDataTask *)RequestWith:(NSString *)method url:(NSString *)url Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask {
    
    NSLog(@"url = %@",url);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = nil;
    
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.0;
    
    if ([method isEqualToString:@"GET"]) {
        return [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else if ([method isEqualToString:@"PUT"]) {
        return [manager PUT:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else if ([method isEqualToString:@"DELETE"]) {
        return [manager DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else {
        NSURLSessionDataTask *task = [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            //        NSLog(@"进度更新 = %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureTask(error);
        }];
        return task;
    }
}

#pragma mark - 微信分享
- (void)WeChatShareImage:(UIImage *)image {
    
    [Tools saveImage:image imageName:@"curt"];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"curt"
                                                         ofType:@"png"];
    message.thumbData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}


@end
