//
//  UserDefaults.h
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (instancetype)shareInstance;

// 用户令牌
// 存储用户令牌
- (void)WriteAccessTokenWith:(NSString *)string;
// 读取用户令牌
- (NSString *)ReadAccessToken;



// 搜索历史
// 添加一个搜索历史
- (NSArray *)AddSeacrhHistoryWith:(NSString *)string;
// 删除一个搜索历史
- (NSArray *)ReduceSeacrhHistoryWith:(NSInteger)index;
- (void)CleanSeacrhHistory;
// 读取搜索历史列表
- (NSArray *)ReadSeacrhHistory;



// 用户信息
// 保存用户信息
- (void)WriteUserDataWith:(NSDictionary *)diction;
// 读取用户信息
- (NSDictionary *)ReadUserData;


#pragma mark - 存储方案生成的时间
// 保存方案生成数据
- (void)WritePlanSettingData:(NSDictionary *)diction;
// 读取方案生成数据
- (NSDictionary *)ReadPlanSettingData;
// 判断今天是否提交过方案
- (BOOL)HaveSubmitPlan;
// 清除方案生成记录
- (void)CleanPlanRecode;

#pragma mark - 注册会员数
- (void)WriteRegisterNumberWith:(NSString *)str;
// 读取用户信息
- (NSString *)ReadRegisterNumber;

#pragma mark - 定制方案数
- (void)WritePlanNumberWith:(NSString *)str;
// 读取用户信息
- (NSString *)ReadPlanNumber;

@end
