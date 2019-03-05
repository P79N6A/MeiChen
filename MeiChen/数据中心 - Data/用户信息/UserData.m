//
//  UserData.m
//  meirong
//
//  Created by yangfeng on 2019/1/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "UserData.h"

#define MEMBER_INFO @"member/info"  // 用户信息

@interface UserData () {
    NetWork *net;
}
@end

@implementation UserData

+ (instancetype)shareInstance {
    static UserData *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserData alloc]init];
    });
    return user;
}

- (instancetype)init {
    if (self = [super init]) {
        id obj = [[UserDefaults shareInstance] ReadUserData];
        NSLog(@"obj = %@",obj);
        net = [[NetWork alloc]init];
        if (obj == nil) {
            _user = nil;
        }
        else {
            _user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:obj error:nil];
        }
    }
    return self;
}


#pragma mark - 获取用户信息
- (void)requestUserData:(void (^)(NSError *error))callbacks {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    [net requestWithUrl:MEMBER_INFO Parames:m_dic Success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                
                break;
            }
            case 1: {
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                NSMutableDictionary *m_data = [NSMutableDictionary dictionary];
                for (NSString *key in  [data allKeys]) {
                    id obj = data[key];
                    m_data[key] = [NSString stringWithFormat:@"%@",obj];
                }
                [[UserDefaults shareInstance] WriteUserDataWith:m_data];
                _user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:m_data error:nil];
                callbacks(nil);
                return ;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        callbacks(error);
        
    } Failure:^(NSError *error) {
        callbacks(error);
    }];
}


@end
