//
//  UserService.m
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "UserService.h"

// 获取手机验证码的url
#define SMS_CODE @"member/sms-code"
// 微信登录的url
#define WX_LOGIN @"member/wx-login"
// 手机登录的url
#define MOBILE_LOGIN @"member/mobile-login"
// 用户登出
#define LOGIN_OUT @"member/logout"
// 用户信息修改
#define USER_MESSAGE_CHANGE @"member/update"
// 用户手机修改
#define MOBILE_CHANGE @"member/mobile-reset"

@implementation UserService

// 获取验证码
- (void)sendPinWithPhoneNumber:(NSString *)phone results:(void (^)(BOOL results, NSInteger pin, NSString *message))results {
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"mobile"] = phone;
    
    [AFNetWork RequestWith:@"POST" url:SMS_CODE Parames:m_dic File:nil Success:^(id responseObject) {
        NSLog(@"获取验证码的请求 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[response allKeys] containsObject:@"code"]) {
                NSInteger code = [response[@"code"] integerValue];
                switch (code) {
                    case 1: {
                        if ([[response allKeys] containsObject:@"data"]) {
                            NSDictionary *data = [NSDictionary dictionaryWithDictionary:response[@"data"]];
                            if ([[data allKeys] containsObject:@"sms_code"]) {
                                NSInteger pinInt = [data[@"sms_code"] integerValue];
                                results(YES, pinInt, nil);
                                return;
                            }
                        }
                        break;
                    } // success
                    default:
                        break;
                }
            }
        }
        if ([[responseObject allKeys] containsObject:@"message"]) {
            results(NO, 0, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
            return;
        }
        results(NO, 0, NSLocalizedString(@"svp_2",nil));
        
    } Failure:^(NSError *error) {
        NSLog(@"获取验证码的请求 network error = %@",error);
        results(NO, 0, NSLocalizedString(@"svp_1",nil));
    }];
}

// 微信登录
- (void)WeChatLoginWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *accessToken, BOOL signup, NSString *message))results {
    
    [AFNetWork RequestWith:@"POST" url:WX_LOGIN Parames:[diction mutableCopy] File:nil Success:^(id responseObject) {
        NSLog(@"微信登录的请求 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[response allKeys] containsObject:@"code"]) {
                NSInteger code = [response[@"code"] integerValue];
                switch (code) {
                    case 1: {
                        if ([[response allKeys] containsObject:@"data"]) {
                            NSDictionary *data = [NSDictionary dictionaryWithDictionary:response[@"data"]];
                            if ([[data allKeys] containsObject:@"signup"]) {
                                NSInteger siup = [data[@"signup"] integerValue];
                                if (siup == 1) {
                                    // 跳转到注册界面
                                    results(YES, nil, YES, nil);
                                    return;
                                }
                                else if ([[data allKeys] containsObject:@"access_token"]) {
                                    NSString *token = [NSString stringWithFormat:@"%@",data[@"access_token"]];
                                    results(YES, token, NO, nil);
                                    return;
                                }
                            }
                            else if ([[data allKeys] containsObject:@"access_token"]) {
                                NSString *token = [NSString stringWithFormat:@"%@",data[@"access_token"]];
                                results(YES, token, NO, nil);
                                return;
                            }
                        }
                        break;
                    } // success
                    default:
                        break;
                }
            }
        }
        if ([[responseObject allKeys] containsObject:@"message"]) {
            results(NO, nil, NO, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
            return;
        }
        results(NO, nil, NO, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
        
    } Failure:^(NSError *error) {
        NSLog(@"微信登录的请求 network error = %@",error);
        results(NO, nil, NO, NSLocalizedString(@"svp_1",nil));
    }];
}

// 手机登录
- (void)MobileLoginWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *accessToken, NSString *message))results {
    
    [AFNetWork RequestWith:@"POST" url:MOBILE_LOGIN Parames:[diction mutableCopy] File:nil Success:^(id responseObject) {
        NSLog(@"手机登录的请求 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[response allKeys] containsObject:@"code"]) {
                NSInteger code = [response[@"code"] integerValue];
                switch (code) {
                    case 1: {
                        if ([[response allKeys] containsObject:@"data"]) {
                            NSDictionary *data = [NSDictionary dictionaryWithDictionary:response[@"data"]];
                            if ([[data allKeys] containsObject:@"access_token"]) {
                                NSString *token = [NSString stringWithFormat:@"%@",data[@"access_token"]];
                                results(YES, token, nil);
                                return;
                            }
                        }
                        break;
                    } // success
                    default:
                        break;
                }
            }
        }
        if ([[responseObject allKeys] containsObject:@"message"]) {
            results(NO, nil, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
            return;
        }
        results(NO, nil, NSLocalizedString(@"svp_2",nil));
        
    } Failure:^(NSError *error) {
        NSLog(@"手机登录的请求 network error = %@",error);
        results(NO, nil, NSLocalizedString(@"svp_1",nil));
    }];
}

// 用户登出
- (void)LoginOutWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *message))results {
    [AFNetWork RequestWith:@"POST" url:LOGIN_OUT Parames:[diction mutableCopy] File:nil Success:^(id responseObject) {
        NSLog(@"用户登出的请求 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[response allKeys] containsObject:@"code"]) {
                NSInteger code = [response[@"code"] integerValue];
                switch (code) {
                    case 0: {
                        if ([Tools JumpToLoginVC:response]) {return;}
                        break;
                    }
                    case 1: {
                        results(YES, nil);
                        return;
                        break;
                    } // success
                    default:
                        break;
                }
            }
        }
        if ([[responseObject allKeys] containsObject:@"message"]) {
            results(NO, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
            return;
        }
        results(NO, NSLocalizedString(@"svp_2",nil));
        
    } Failure:^(NSError *error) {
        NSLog(@"用户登出的请求 network error = %@",error);
        results(NO, NSLocalizedString(@"svp_1",nil));
    }];
}

// 用户手机修改
- (void)ModifyMobileWith:(NSDictionary *)diction results:(void (^)(BOOL results, NSString *message))results {
    [AFNetWork RequestWith:@"POST" url:USER_MESSAGE_CHANGE Parames:[diction mutableCopy] File:nil Success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[response allKeys] containsObject:@"code"]) {
                NSInteger code = [response[@"code"] integerValue];
                switch (code) {
                    case 0: {
                        if ([Tools JumpToLoginVC:response]) {return;}
                        break;
                    }
                    case 1: {
                        results(YES, nil);
                        return;
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        if ([[responseObject allKeys] containsObject:@"message"]) {
            results(NO, [NSString stringWithFormat:@"%@",responseObject[@"message"]]);
            return;
        }
        results(NO, NSLocalizedString(@"svp_2",nil));
        
    } Failure:^(NSError *error) {
        NSLog(@"用户手机修改的请求 network error = %@",error);
        results(NO, NSLocalizedString(@"svp_1",nil));
    }];
}

@end
