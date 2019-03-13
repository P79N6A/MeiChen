//
//  UserData.h
//  meirong
//
//  Created by yangfeng on 2019/1/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendModel.h"

@interface UserData : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong, readonly) UserModel *user;

#pragma mark - 获取用户信息
- (void)requestUserData:(void (^)(NSError *error))callbacks;


@end
