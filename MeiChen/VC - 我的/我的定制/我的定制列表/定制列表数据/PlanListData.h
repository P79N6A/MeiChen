//
//  PlanListData.h
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlanListDataDelegate <NSObject>

@optional
- (void)request_PlanListData_Success;
- (void)request_PlanListData_Fail:(NSError *)error;

@end

@interface PlanListData : NSObject

@property (nonatomic, weak)id <PlanListDataDelegate> delegate;

#pragma mark - 获取 定制列表 数据
- (NSInteger)numbersOfRow;
- (SinglePlanModel *)ItemWithRow:(NSInteger)row;

#pragma mark - 获取定制列表数据
- (void)requestPlanListData:(NSString *)page;

@end
