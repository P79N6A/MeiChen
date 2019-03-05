//
//  ZanData.m
//  meirong
//
//  Created by yangfeng on 2019/1/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ZanData.h"

#define ZAN_URL @"sample/do-like"   // 点赞的url
#define CANCELZAN_URL @"sample/dis-like"   // 取消点赞的url

@interface ZanData () {
    NetWork *net;
}
@end

@implementation ZanData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
    }
    return self;
}

#pragma mark - 取消请求
// 取消请求
- (void)CancelNetWork {
    [net cancelRequest];
}

#pragma mark - 点赞请求
- (void)requestZanWithId:(NSString *)foreign_id type:(NSString *)asset_type row:(NSInteger)row type:(NSInteger)type {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"foreign_id"] = foreign_id;
    m_dic[@"asset_type"] = asset_type;
    
    [net requestWithUrl:ZAN_URL Parames:m_dic Success:^(id responseObject) {
        NSLog(@"点赞请求 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            [self ZanSuccessWithRow:row type:type];
        }
        else {
            [self ZanFail:nil row:row type:type];
        }
    } Failure:^(NSError *error) {
        [self ZanFail:error row:row type:type];
    }];
}
- (void)ZanSuccessWithRow:(NSInteger)row type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZanData_Zan_SuccessWithRow:type:)]) {
            [self.delegate ZanData_Zan_SuccessWithRow:row type:type];
        }
    });
}
- (void)ZanFail:(NSError *)error row:(NSInteger)row type:(NSInteger)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZanData_Zan_Fail:row:type:)]) {
            [self.delegate ZanData_Zan_Fail:error row:row type:type];
        }
    });
}

#pragma mark - 取消点赞请求
- (void)requestCancelZanWithId:(NSString *)foreign_id type:(NSString *)asset_type row:(NSInteger)row type:(NSInteger)type {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"foreign_id"] = foreign_id;
    m_dic[@"asset_type"] = asset_type;
    [net requestWithUrl:CANCELZAN_URL Parames:m_dic Success:^(id responseObject) {
        NSLog(@"取消点赞请求 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            [self CancelZanSuccessWithRow:row type:type];
        }
        else {
            [self CancelZanFail:nil row:row type:type];
        }
    } Failure:^(NSError *error) {
        [self CancelZanFail:error row:row type:type];
    }];
}
- (void)CancelZanSuccessWithRow:(NSInteger)row type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZanData_CancelZan_SuccessWithRow:type:)]) {
            [self.delegate ZanData_CancelZan_SuccessWithRow:row type:type];
        }
    });
}
- (void)CancelZanFail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZanData_CancelZan_Fail:row:type:)]) {
            [self.delegate ZanData_CancelZan_Fail:error row:row type:type];
        }
    });
}

@end
