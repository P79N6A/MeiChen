//
//  MyShareModel.m
//  meirong
//
//  Created by yangfeng on 2019/3/12.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareModel.h"

#pragma mark - 1、我的分享

#pragma mark - 我的分享 - base_info
@implementation BaseInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"member_id":@"member_id",
             @"sex":@"sex",
             @"mobile":@"mobile",
             @"avatar":@"avatar",
             @"nickname":@"nickname",
             @"realname":@"realname",
             @"motto":@"motto"
             };
}
@end


#pragma mark - 我的分享 - card
@implementation ShareCardModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"card_id":@"card_id",
             @"card_title":@"card_title",
             @"period":@"period",
             @"accu_money":@"accu_money",
             @"plus_money":@"plus_money",
             @"discount":@"discount",
             @"points_deduct_rate":@"points_deduct_rate",
             @"points_get_multiple":@"points_get_multiple",
             @"minterms":@"minterms"
             };
}
@end

#pragma mark - 我的分享 - share_minterms
@implementation ShareMintermsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"minterm_id":@"minterm_id",
             @"hospital_id":@"hospital_id",
             @"term_name":@"term_name",
             @"cover_img":@"cover_img",
             @"detail":@"detail",
             @"term_type":@"term_type",
             @"dots":@"dots",
             @"spend_points":@"spend_points",
             @"is_booking":@"is_booking"
             };
}
@end


#pragma mark - 我的分享
@implementation ShareModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"base_info":@"base_info",
             @"card":@"card",
             @"commission_points":@"commission_points",
             @"commission_num_direct":@"commission_num_direct",
             @"share_minterms":@"share_minterms",
             @"share_times_sum":@"share_times_sum",
             @"share_times_used":@"share_times_used",
             @"share_times_remain":@"share_times_remain"
             };
}
+ (NSValueTransformer *)base_infoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BaseInfoModel class]];
}
+ (NSValueTransformer *)cardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ShareCardModel class]];
}
+ (NSValueTransformer *)share_mintermsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ShareMintermsModel class]];
}
@end



#pragma mark - 2、我的积分

#pragma mark - 我的积分 - commission_stream - commission
@implementation CommissionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"stream_id":@"stream_id",
             @"member_id":@"member_id",
             @"title":@"title",
             @"label":@"label",
             @"points":@"points",
             @"create_at":@"create_at",
             @"remark":@"remark",
             @"foreign_id":@"foreign_id",
             @"foreign_table":@"foreign_table"
             };
}
@end

#pragma mark - 我的积分 - commission_stream
@implementation CommissionStreamModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"order_id":@"order_id",
             @"member_id":@"member_id",
             @"agent_id":@"agent_id",
             @"total_price":@"init_total_price",
             @"item":@"item",
             @"commission":@"commission",
             @"avatar":@"avatar",
             @"nickname":@"nickname"
             };
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[itemModel class]];
}
+ (NSValueTransformer *)commissionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CommissionModel class]];
}
@end

#pragma mark - 我的积分
@implementation JiFenModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commission_stream":@"commission_stream",
             @"commission_points":@"commission_points"
             };
}
+ (NSValueTransformer *)commission_streamJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CommissionStreamModel class]];
}
@end



#pragma mark - 3、我的好友

#pragma mark - 我的好友 - friends - friend
@implementation Friend
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"avatar":@"avatar",
             @"nickname":@"nickname",
             @"member_id":@"member_id",
             @"commission_num_indirect":@"commission_num_indirect"
             };
}
@end

#pragma mark - 我的好友 - grade_info - current_grage
@implementation CurrentGrageModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"grade_id":@"grade_id",
             @"min_heads":@"min_heads",
             @"max_heads":@"max_heads",
             @"grade_title":@"grade_title"
             };
}
@end

#pragma mark - 我的好友 - grade_info - next_grage
@implementation NextGrageModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"grade_id":@"grade_id",
             @"min_heads":@"min_heads",
             @"max_heads":@"max_heads",
             @"grade_title":@"grade_title"
             };
}
@end

#pragma mark - 我的好友 - grade_info
@implementation GradeInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"current_grage":@"current_grage",
             @"next_grage":@"next_grage"
             };
}
+ (NSValueTransformer *)current_grageJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CurrentGrageModel class]];
}
+ (NSValueTransformer *)next_grageJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[NextGrageModel class]];
}
@end

#pragma mark - 我的好友
@implementation FriendModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commission_num_indirect":@"commission_num_indirect",
             @"friends":@"friends",
             @"grade_info":@"grade_info"
             };
}
+ (NSValueTransformer *)friendsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Friend class]];
}
+ (NSValueTransformer *)grade_infoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GradeInfoModel class]];
}
@end






