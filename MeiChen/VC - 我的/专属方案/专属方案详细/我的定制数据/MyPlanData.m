//
//  MyPlanData.m
//  meirong
//
//  Created by yangfeng on 2019/1/28.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanData.h"

@interface MyPlanData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}

@end

@implementation MyPlanData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
    }
    return self;
}

#pragma mark - 立即支付
- (void)requestPayWithPoint:(BOOL)point_deduct Coupon:(BOOL)coupon_deduct coupon:(NSArray *)array text:(NSString *)text {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"order_id"] = self.model.order_id;
    m_dic[@"is_points_deduct"] = point_deduct?@"1":@"0";
    m_dic[@"is_coupon_deduct"] = coupon_deduct?@"1":@"0";
    m_dic[@"coupon"] = array;
    m_dic[@"remark"] = text;
    [net requestWithUrl:@"order/do-submit" Parames:m_dic Success:^(id responseObject) {
        [self ParsingPayData:responseObject];
    } Failure:^(NSError *error) {
        [self PayFail:error];
    }];
}
// 立即支付 - 成功
- (void)PaySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(MyPlanData_Pay_Success)]) {
            [self.delegate MyPlanData_Pay_Success];
        }
    });
}
// 立即支付 - 失败
- (void)PayFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(MyPlanData_Pay_Fail:)]) {
            [self.delegate MyPlanData_Pay_Fail:error];
        }
    });
}




#pragma mark - 下载定制详情
- (void)requestMyPlanDetailWithOrder_id:(NSString *)order_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"order_id"] = order_id;
    [net requestWithUrl:@"order/detail" Parames:m_dic Success:^(id responseObject) {
        [self ParsingPlanDetailData:responseObject];
    } Failure:^(NSError *error) {
        [self DownLoadMyPlanDetailFail:error];
    }];
}
// 下载定制详情 - 成功
- (void)DownLoadMyPlanDetailSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(MyPlanData_DownLoadDetailData_Success)]) {
            [self.delegate MyPlanData_DownLoadDetailData_Success];
        }
    });
}
// 下载定制详情 - 失败
- (void)DownLoadMyPlanDetailFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(MyPlanData_DownLoadDetailData_Fail:)]) {
            [self.delegate MyPlanData_DownLoadDetailData_Fail:error];
        }
    });
}

#pragma mark - 解析数据
// 1、解析定制详细数据
- (void)ParsingPlanDetailData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                PlanDetailModel *model = [MTLJSONAdapter modelOfClass:[PlanDetailModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                if (model == nil) {
                    NSLog(@"model == nil");
                    [self DownLoadMyPlanDetailSuccess];
                    return;
                }
                self.model = model;
//                self.model = [self settingModel:model];
                [self DownLoadMyPlanDetailSuccess];
                return;
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
        [self DownLoadMyPlanDetailFail:error];
    });
}

- (PlanDetailModel *)settingModel:(PlanDetailModel *)mo {
    PlanDetailModel *model = mo;
    
    PlanDetailCouponsCoupon *coupon_1 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_1.title = @"新人优惠券";
    coupon_1.value = @"600";
    
    PlanDetailCouponsCoupon *coupon_2 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_2.title = @"店庆优惠券";
    coupon_2.value = @"200";
    
    PlanDetailCouponsCoupon *coupon_3 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_3.title = @"老板送的优惠券";
    coupon_3.value = @"150";
    
    PlanDetailCoupons *coupons_1 = [[PlanDetailCoupons alloc]init];
    coupons_1.is_gray = @"0";
    coupons_1.coupon = coupon_1;
    coupons_1.coupon_id = @"1";
    
    PlanDetailCoupons *coupons_2 = [[PlanDetailCoupons alloc]init];
    coupons_2.is_gray = @"0";
    coupons_2.coupon = coupon_2;
    coupons_2.coupon_id = @"2";
    
    PlanDetailCoupons *coupons_3 = [[PlanDetailCoupons alloc]init];
    coupons_3.is_gray = @"1";
    coupons_3.coupon = coupon_3;
    coupons_3.coupon_id = @"3";
    
    // 优惠券
    model.coupons = @[coupons_1,coupons_2,coupons_3];
    
    PlanDetailCouponCalc *calc_1 = [[PlanDetailCouponCalc alloc]init];
    calc_1.remark = @"可用有效优惠券数";
    calc_1.key = @"valid_coupon_num";
    calc_1.val = @"2";
    
    PlanDetailCouponCalc *calc_2 = [[PlanDetailCouponCalc alloc]init];
    calc_2.remark = @"有效优惠券扣减";
    calc_2.key = @"valid_coupon_deduct";
    calc_2.val = @"800";
    
    // 会员等级
    PlanDetailCardCalc *cardcalc_1 = [[PlanDetailCardCalc alloc]init];
    cardcalc_1.remark = @"会员等级";
    cardcalc_1.key = @"card_title";
    cardcalc_1.val = @"神级会员";
    
    // 会员折扣
    PlanDetailCardCalc *cardcalc_2 = [[PlanDetailCardCalc alloc]init];
    cardcalc_2.remark = @"会员折扣";
    cardcalc_2.key = @"discount";
    cardcalc_2.val = @"8.6";
    
    // 会员折扣扣减
    PlanDetailCardCalc *cardcalc_3 = [[PlanDetailCardCalc alloc]init];
    cardcalc_3.remark = @"会员折扣扣减";
    cardcalc_3.key = @"discount_deduct";
    cardcalc_3.val = @"2660";
    
    // 积分倍数
    PlanDetailCardCalc *cardcalc_4 = [[PlanDetailCardCalc alloc]init];
    cardcalc_4.remark = @"积分倍数";
    cardcalc_4.key = @"points_get_multiple";
    cardcalc_4.val = @"1.3";
    
    // 本次可累计积分
    PlanDetailCardCalc *cardcalc_5 = [[PlanDetailCardCalc alloc]init];
    cardcalc_5.remark = @"本次可累计积分";
    cardcalc_5.key = @"points_get";
    cardcalc_5.val = @"24700";
    
    // 积分抵扣比例
    PlanDetailCardCalc *cardcalc_6 = [[PlanDetailCardCalc alloc]init];
    cardcalc_6.remark = @"积分抵扣比例";
    cardcalc_6.key = @"points_deduct_rate";
    cardcalc_6.val = @"10";
    
    // 会员累计积
    PlanDetailCardCalc *cardcalc_7 = [[PlanDetailCardCalc alloc]init];
    cardcalc_7.remark = @"会员累计积";
    cardcalc_7.key = @"points_current";
    cardcalc_7.val = @"5000";
    
    // 本次订单最大抵扣可用积分
    PlanDetailCardCalc *cardcalc_8 = [[PlanDetailCardCalc alloc]init];
    cardcalc_8.remark = @"本次订单最大抵扣可用积分";
    cardcalc_8.key = @"points_use_max";
    cardcalc_8.val = @"190000";
    
    // 最终可用积分
    PlanDetailCardCalc *cardcalc_9 = [[PlanDetailCardCalc alloc]init];
    cardcalc_9.remark = @"最终可用积分";
    cardcalc_9.key = @"points_use";
    cardcalc_9.val = @"5000";
    
    // 可用积分抵扣
    PlanDetailCardCalc *cardcalc_10 = [[PlanDetailCardCalc alloc]init];
    cardcalc_10.remark = @"可用积分抵扣";
    cardcalc_10.key = @"points_deduct";
    cardcalc_10.val = @"50";
    
    model.card_calc = @[cardcalc_1,cardcalc_2,cardcalc_3,
                        cardcalc_4,cardcalc_5,cardcalc_6,
                        cardcalc_7,cardcalc_8,cardcalc_9,
                        cardcalc_10];
    
    model.has_card = 1;
    
    // 优惠券统计
    model.coupon_calc = @[calc_1,calc_2];
    
    model.pre_total_price = 19000;
    model.discount_deduct = 2660;   // 折扣扣除
    model.points_deduct = 50;    // 点扣除
    model.coupon_deduct = 800; //息票中扣除
    model.total_deduct = model.discount_deduct+model.points_deduct+model.coupon_deduct;
    model.total_price = model.pre_total_price-model.total_deduct;
    
    return model;
}

// 1、解析支付数据
- (void)ParsingPayData:(id)responseObject {
    // 异步解析数据
    NSLog(@"解析支付数据 = %@",responseObject); dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                if ([data[@"charge"] integerValue] == 1) {
                    // 账户余额不足,请充值
                }
                else {
                    
                }
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
//                [self PaySuccess];
                return;
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
        [self PayFail:error];
    });
}









@end
