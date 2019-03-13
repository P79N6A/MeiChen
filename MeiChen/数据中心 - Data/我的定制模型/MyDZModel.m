//
//  MyDZModel.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyDZModel.h"


#pragma mark - 我的定制详情数据 - list
@implementation MyDZListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"pre_img":@"pre_img",
             @"done_img":@"done_img",
             @"imitate_id":@"imitate_id",
             @"item_id":@"item_id",
             @"scheme":@"scheme",
             @"has_seen":@"has_seen",
             @"member_id":@"member_id",
             @"item":@"item",
             };
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PlanItemModel class]];
}
@end


#pragma mark - 我的定制详情数据 - sample
@implementation MyDZSampleModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"member_id":@"member_id",
             @"cover_img":@"cover_img",
             @"like_num":@"like_num",
             @"sample_id":@"sample_id",
             @"status":@"status",
             @"brief":@"brief",
             };
}
@end


#pragma mark - 我的定制详情数据
@implementation MyDZDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sample":@"sample",
             @"has_card":@"has_card_calc",
             @"has_coupon":@"has_coupon_calc",
             @"list":@"list",
             @"card_calc":@"card_calc",
             @"coupons":@"coupons",
             @"coupon_calc":@"coupon_calc",
             @"init_total_price":@"init_total_price",
             @"total_deduct":@"total_deduct",
             @"total_price":@"total_price",
             };
}
+ (NSValueTransformer *)sampleJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MyDZSampleModel class]];
}
+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MyDZListModel class]];
}
+ (NSValueTransformer *)card_calcJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlanDetailCardCalc class]];
}
+ (NSValueTransformer *)couponsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlanDetailCoupons class]];
}
+ (NSValueTransformer *)coupon_calcJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlanDetailCouponCalc class]];
}
@end
