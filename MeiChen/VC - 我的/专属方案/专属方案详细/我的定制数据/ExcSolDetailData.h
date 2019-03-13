//
//  MyPlanData.h
//  meirong
//
//  Created by yangfeng on 2019/1/28.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyPlanDataDelegate <NSObject>
@optional
// 下载定制详情
- (void)MyPlanData_DownLoadDetailData_Success;
- (void)MyPlanData_DownLoadDetailData_Fail:(NSError *)error;

// 支付
- (void)MyPlanData_Pay_Success;
- (void)MyPlanData_Pay_Fail:(NSError *)error;
// 线下支付
- (void)MyPlanData_PayOffline;
// 购买一卡通
- (void)MyPlanData_BuyCard;
// 支付成功 更新定制详情
- (void)MyPlanData_UpdateData;


@end

@interface ExcSolDetailData : NSObject
@property (nonatomic, weak)id<MyPlanDataDelegate> delegate;
@property (nonatomic, strong) PlanDetailModel *model;
@property (nonatomic, strong) RechargeView *showview;
@property (nonatomic, strong) PayMethodView *payview;
@property (nonatomic, strong) NotMemberView *notView;

@property (nonatomic) BOOL isPayOffLine;

#pragma mark - 下载定制详情
- (void)requestMyPlanDetailWithOrder_id:(NSString *)order_id;
#pragma mark - 立即支付
- (void)requestPayWithPoint:(BOOL)point_deduct Coupon:(BOOL)coupon_deduct coupon:(NSArray *)array text:(NSString *)text;
@end
