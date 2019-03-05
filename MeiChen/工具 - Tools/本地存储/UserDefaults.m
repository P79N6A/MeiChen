//
//  UserDefaults.m
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "UserDefaults.h"

#define ACCESS_TOKEN @"meichen_access_token"    // 用户令牌
#define SEARCH_HISTORY @"meichen_search_history"    // 搜索历史
#define USER_DATA @"meichen_user_data"                  // 用户信息

#define PLAN_SETTING_DATA @"meichen_plan_setting_data"   // 方案生成数据

@implementation UserDefaults

// 创建静态对象 防止外部访问
static UserDefaults *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+ (instancetype)shareInstance {
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}



// 用户令牌
- (void)WriteAccessTokenWith:(NSString *)string {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (string == nil) {
        [def removeObjectForKey:ACCESS_TOKEN];
    }
    else {
        [def setObject:string forKey:ACCESS_TOKEN];
    }
    [def synchronize];
}

- (NSString *)ReadAccessToken {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:ACCESS_TOKEN];
}


// 搜索历史
- (NSArray *)AddSeacrhHistoryWith:(NSString *)string {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [self ReadSeacrhHistory];
    NSMutableArray *m_arr;
    if (obj != nil && [obj isKindOfClass:[NSArray class]]) {
        m_arr = [NSMutableArray arrayWithArray:obj];
        if (![m_arr containsObject:string]) {
            [m_arr addObject:string];
        }
    }
    else {
        m_arr = [NSMutableArray arrayWithObject:string];
    }
    [def setObject:m_arr forKey:SEARCH_HISTORY];
    [def synchronize];
    return [m_arr copy];
}

- (NSArray *)ReduceSeacrhHistoryWith:(NSInteger)index {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [self ReadSeacrhHistory];
    if (obj != nil && [obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *m_arr = [NSMutableArray arrayWithArray:obj];
        if (m_arr.count > index) {
            [m_arr removeObjectAtIndex:index];
        }
        [def setObject:m_arr forKey:SEARCH_HISTORY];
        [def synchronize];
        return [m_arr copy];
    }
    return nil;
}
- (void)CleanSeacrhHistory {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:SEARCH_HISTORY];
    [def synchronize];
}
- (NSArray *)ReadSeacrhHistory {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:SEARCH_HISTORY];
    return obj == nil?@[]:[NSArray arrayWithArray:obj];
}


// 用户信息
// 保存用户信息
- (void)WriteUserDataWith:(NSDictionary *)diction {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (diction == nil) {
        [def removeObjectForKey:USER_DATA];
    }
    else {
        [def setObject:diction forKey:USER_DATA];
    }
    [def synchronize];
}
// 读取用户信息
- (NSDictionary *)ReadUserData {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:USER_DATA];
}


#pragma mark - 存储方案生成的时间
// 保存方案生成数据
- (void)WritePlanSettingData:(NSDictionary *)diction {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%0.f",time];
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:diction];
    m_dic[@"nowTime"] = timeStr;
    [def setObject:m_dic forKey:PLAN_SETTING_DATA];
    [def synchronize];
}
// 读取方案生成数据
- (NSDictionary *)ReadPlanSettingData {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:PLAN_SETTING_DATA];
    NSLog(@"方案生成数据 = %@",obj);
    if (obj == nil) {
        return nil;
    }
    else {
        return [NSDictionary dictionaryWithDictionary:obj];
    }
}

// 判断今天是否提交过方案
- (BOOL)HaveSubmitPlan {
    NSDictionary *dic = [self ReadPlanSettingData];
    if (dic == nil) {
        return NO;
    }
    NSString *timeStr = dic[@"nowTime"];
    NSInteger time = [timeStr integerValue];
    if (time == 0) {
        return NO;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str_1 = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *str_2 = [formatter stringFromDate:[NSDate date]];
    if ([str_1 isEqualToString:str_2]) {
        return YES;
    }
    return NO;
}
// 清除方案生成记录
- (void)CleanPlanRecode {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:PLAN_SETTING_DATA];
}

#pragma mark - 注册会员数
- (void)WriteRegisterNumberWith:(NSString *)str {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:str forKey:@"meichen_register_num"];
    [def synchronize];
}
// 读取用户信息
- (NSString *)ReadRegisterNumber {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:@"meichen_register_num"];
    if (obj == nil) {
        return @"3575";
    }
    return obj;
}

#pragma mark - 定制方案数
- (void)WritePlanNumberWith:(NSString *)str {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:str forKey:@"meichen_plan_num"];
    [def synchronize];
}
// 读取用户信息
- (NSString *)ReadPlanNumber {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:@"meichen_plan_num"];
    if (obj == nil) {
        return @"3092";
    }
    return obj;
}



@end
