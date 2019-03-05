//
//  LoginData.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "LoginData.h"

@implementation LoginData

// 创建静态对象 防止外部访问
static LoginData *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
+ (instancetype)shareInstance {
    return [[self alloc]init];
}
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}







@end
