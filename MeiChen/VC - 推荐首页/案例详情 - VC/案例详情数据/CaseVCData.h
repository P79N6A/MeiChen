//
//  CaseVCData.h
//  meirong
//
//  Created by yangfeng on 2019/1/10.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaseVCDataDelegate <NSObject>

@optional
// 案例详情请求
- (void)CaseVCData_requestSuccess;
- (void)CaseVCData_requestFail:(NSError *)error;

// 更新成功
- (void)CaseVCData_UpdateFinish:(NSIndexPath *)indexPath;

@end

@interface CaseVCData : NSObject

@property (nonatomic,weak) id <CaseVCDataDelegate> delegate;

@property (nonatomic, strong) ListModel *listmodel;

#pragma mark - 读取数据
- (NSInteger)numOfSections;
- (NSInteger)numOfRowsInSection:(NSInteger)section;
- (NSInteger)numbersWithModel:(DailyModel *)model;
- (DailyModel *)DailyModelWithIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightWithIndexPath:(NSIndexPath *)indexPath;
- (CaseDetailModel *)CaseDetailModel;
- (void)ChangeTheOrder;

// 获取年份
- (NSString *)timeComponentsYear:(NSInteger)time;

// 点赞成功
- (void)UpdateZanDataWith:(NSIndexPath *)indexPath;
// 点赞失败
- (void)UpdateCancelZanDataWith:(NSIndexPath *)indexPath;

#pragma mark - 案例详情 请求
- (void)requestCaseDetailData;

@end
