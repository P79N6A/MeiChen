//
//  DataModel.m
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "RecommendModel.h"

// ********************************** //
#pragma mark - 推荐首页 - 热门数据模型
@implementation HotModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"menu":@"menu",
             @"list":@"list"
             };
}
+ (NSValueTransformer *)menuJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MenuModel class]];
}
+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ListModel class]];
}
@end

#pragma mark - 推荐首页 - 热门数据模型 - menu模型
@implementation MenuModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"key":@"key",
             @"name":@"title",
             @"val":@"val",
             @"is_default":@"is_default",
             @"guide":@"guide"
             };
}
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型
@implementation ListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"member_id":@"member_id",
             @"cover_img":@"cover_img",
             @"like_num":@"like_num",
             @"sample_id":@"sample_id",
             @"member":@"member",
             @"brief":@"brief",
             @"has_like":@"has_like",
             @"status":@"status"
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberModel class]];
}
+ (NSValueTransformer *)briefJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BriefModel class]];
}
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型 - member模型
@implementation MemberModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"nickname":@"nickname",
             @"mobile":@"mobile",
             @"avatar":@"avatar",
             @"member_id":@"member_id"
             };
}
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型 - brief模型
@implementation BriefModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"sample_id":@"sample_id",
             @"brief":@"brief"
             };
}
@end

#pragma mark - 推荐首页 - 热门数据模型 - 分类模型
@implementation TypeModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ListModel class]];
}
@end

// ********************************** //
#pragma mark - 所有分类菜单
@implementation AllMenuModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ChildMenuModel class]];
}
@end

#pragma mark - 所有分类菜单 - 子菜单模型
@implementation ChildMenuModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"key":@"key",
             @"val":@"val",
             @"title":@"title",
             @"sub":@"sub"};
}
+ (NSValueTransformer *)subJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ChildMenuModel_2 class]];
}
@end

#pragma mark - 所有分类菜单 - 子菜单模型 - 子菜单模型2
@implementation ChildMenuModel_2
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"key":@"key",
             @"val":@"val",
             @"title":@"title",
             @"sub":@"sub"
             };
}
+ (NSValueTransformer *)subJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ChildMenuModel_3 class]];
}
@end

#pragma mark - 所有分类菜单 - 子菜单模型 - 子菜单模型2 - 子菜单模型3
@implementation ChildMenuModel_3
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"key":@"key",
             @"val":@"val",
             @"title":@"title"
             };
}
@end


// ********************************** //
#pragma mark - 案例详细模型
@implementation CaseDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"member_id":@"member_id",
             @"fix_at":@"fix_at",
             @"sample_id":@"sample_id",
             @"pre_imgs":@"pre_imgs",
             @"member":@"member",
             @"tag":@"tag",
             @"card":@"card",
             @"item":@"item",
             @"daily":@"daily"
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberModel class]];
}
+ (NSValueTransformer *)tagJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[tagModel class]];
}
+ (NSValueTransformer *)cardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[cardModel class]];
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[itemModel class]];
}
+ (NSValueTransformer *)dailyJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[DailyModel class]];
}
@end

#pragma mark - 标签模型
@implementation tagModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"tag_id":@"tag_id",
             @"tag_name":@"tag_name",
             };
}
@end

#pragma mark - 会员卡模型
@implementation cardModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"level":@"level",
             @"member_id":@"member_id",
             @"title":@"title"
             };
}
@end

#pragma mark - 手术模型
@implementation itemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"item_id":@"item_id",
             @"item_name":@"item_name",
             };
}
@end

#pragma mark - 日记模型
@implementation DailyModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"daily_id":@"daily_id",
             @"sample_id":@"sample_id",
             @"photos":@"photos",
             @"title":@"title",
             @"brief":@"brief",
             @"view_num":@"view_num",
             @"like_num":@"like_num",
             @"comment_num":@"comment_num",
             @"photo_at":@"photo_at",
             @"has_like":@"has_like"
             };
}
@end

#pragma mark - 评论数组模型
@implementation revertArrayModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[reviewModel class]];
}
@end

#pragma mark - 被评论模型
@implementation reviewModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"comment_id":@"comment_id",
             @"member_id":@"member_id",
             @"foreign_id":@"foreign_id",
             @"content":@"content",
             @"create_at":@"create_at",
             @"pid":@"pid",
             @"member":@"member",
             @"sub":@"sub",
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberModel class]];
}
+ (NSValueTransformer *)subJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[revertModel class]];
}
@end

#pragma mark - 评论模型
@implementation revertModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"comment_id":@"comment_id",
             @"member_id":@"member_id",
             @"foreign_id":@"foreign_id",
             @"content":@"content",
             @"create_at":@"create_at",
             @"pid":@"pid",
             @"member":@"member"
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberModel class]];
}
@end


#pragma mark - 用户模型
@implementation UserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"member_id":@"member_id",
             @"uuid":@"uuid",
             @"sex":@"sex",
             @"mobile":@"mobile",
             @"avatar":@"avatar",
             @"nickname":@"nickname",
             @"create_at":@"create_at",
             @"update_at":@"update_at",
             @"openid":@"openid",
             @"motto":@"motto",
             @"realname":@"realname",
             @"card":@"card",
             @"is_able":@"is_able",
             @"link_heads":@"link_heads",
             @"pid":@"pid",
             };
}
@end


#pragma mark - 方案定制页数据
@implementation PlanModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlanStyleModel class]];
}
@end


#pragma mark - 方案定制页数据 - 模特照片数组模型
@implementation PlanImagesModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ImageModel class]];
}
@end

#pragma mark - 方案定制页数据 - 模特照片模型
@implementation ImageModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"img":@"img",
             @"row":@"row"
             };
}
@end

#pragma mark - 方案定制页数据 - 类型
@implementation PlanStyleModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"tag_id":@"tag_id",
             @"tag_name":@"tag_name",
             @"tag_type":@"tag_type",
             @"remark":@"remark",
             @"pid":@"pid"
             };
}

@end

#pragma mark - 方案定制页数据 - 部位
@implementation PlanRemarkModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"front":@"front",
             @"part":@"part",
             @"front_more":@"front_more",
             @"part_more":@"part_more",
             @"front_photo":@"front_photo",
             @"part_photo":@"part_photo"
             };
}
@end

#pragma mark - 六、- 定制列表数据
@implementation PlanListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SinglePlanModel class]];
}
@end

#pragma mark - 定制列表数据 - 单个定制数据
@implementation SinglePlanModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"imitate_id":@"imitate_id",
             @"item_id":@"item_id",
             @"finish_at":@"finish_at",
             @"item":@"item",
             @"scheme":@"scheme"
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PlanItemModel class]];
}
@end

#pragma mark - 定制列表数据 - 单个定制数据 - item
@implementation PlanItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"item_name":@"item_name",
             @"fee":@"fee",
             @"cover_img":@"cover_img",
             @"booking_num":@"booking_num",
             @"brief":@"brief",
             };
}
@end

#pragma mark - 专属方案数据 - 专属方案详细
@implementation PlanDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"title":@"title",
             @"order_id":@"order_id",
             @"total_price_origin":@"init_total_price",
             @"item":@"item",
             @"has_card":@"has_card",
             @"card_calc":@"card_calc",
             @"has_coupon":@"has_coupon",
             @"coupons":@"coupons",
             @"coupon_calc":@"coupon_calc",
             @"total_deduct":@"total_deduct",
             @"total_price":@"total_price",
             @"member_id":@"member_id",
             @"pre_total_price":@"pre_total_price",
             @"discount_deduct":@"discount_deduct",
             @"points_deduct":@"points_deduct",
             @"coupon_deduct":@"coupon_deduct",
             };
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlanDetailItem class]];
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

#pragma mark - 专属方案数据 - 专属方案详细 - item
@implementation PlanDetailItem
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"order_id":@"order_id",
             @"item_id":@"item_id",
             @"real_time_fee":@"real_time_fee",
             @"surgery_id":@"surgery_id",
             @"item_name":@"item_name",
             @"brief":@"brief",
             @"booking_num":@"booking_num",
             @"cover_img":@"cover_img"
             };
}
@end

#pragma mark - 专属方案数据 - 专属方案详细 - card_calc
@implementation PlanDetailCardCalc
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"remark":@"remark",
             @"key":@"key",
             @"val":@"val"
             };
}
@end

#pragma mark - 专属方案数据 - 专属方案详细 - coupons
@implementation PlanDetailCoupons
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"get_id":@"get_id",
             @"member_id":@"member_id",
             @"coupon_id":@"coupon_id",
             @"is_used":@"is_used",
             @"receive_at":@"receive_at",
             @"start_on":@"start_on",
             @"expire_on":@"expire_on",
             @"order_id":@"order_id",
             @"coupon":@"coupon",
             @"is_gray":@"is_gray"
             };
}
+ (NSValueTransformer *)couponJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PlanDetailCouponsCoupon class]];
}
@end


#pragma mark - 专属方案数据 - 专属方案详细 - coupons
@implementation PlanDetailCouponsCoupon
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"coupon_id":@"coupon_id",
             @"title":@"title",
             @"value":@"value",
             @"start_on":@"start_on",
             @"expire_on":@"expire_on",
             @"expire_after_days":@"expire_after_days",
             @"threshold":@"threshold",
             @"detail":@"detail",
             @"is_pick":@"is_pick",
             @"is_share":@"is_share",
             @"card_id":@"card_id"
             };
}
@end

#pragma mark - 专属方案数据 - 专属方案详细 - coupon_calc
@implementation PlanDetailCouponCalc
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"remark":@"remark",
             @"key":@"key",
             @"val":@"val"
             };
}
@end




#pragma mark - 七、- 我的日记本
@implementation MyDiaryData
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MyDiaryModel class]];
}
@end

#pragma mark - 我的日记本
@implementation MyDiaryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"sample_id":@"sample_id",
             @"create_at":@"create_at",
             @"cover_img":@"cover_img",
             @"views_num":@"views_num",
             @"like_num":@"like_num",
             @"comment_num":@"comment_num",
             @"status":@"status",
             @"pass_daily_num":@"pass_daily_num",
             @"item":@"item"
             };
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[itemModel class]];
}
@end

#pragma mark - 我的日记本 - 日记本详情
@implementation DiaryDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"member_id":@"member_id",
             @"fix_at":@"fix_at",
             @"sample_id":@"sample_id",
             @"member":@"member",
             @"cover_img":@"cover_img",
             @"pre_imgs":@"pre_imgs",
             @"item":@"item",
             @"daily":@"daily"
             };
}
+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MemberModel class]];
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[itemModel class]];
}
+ (NSValueTransformer *)dailyJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[DailyDetailItem class]];
}
@end

#pragma mark - 我的日记本 - 日记本详情 - 日记item
@implementation DailyDetailItem
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"daily_id":@"daily_id",
             @"sample_id":@"sample_id",
             @"photos":@"photos",
             @"brief":@"brief",
             @"photo_at":@"photo_at",
             @"status":@"status"
             };
}
@end


#pragma mark - 我的日记本 - images
@implementation AddUpdateModel

@end


#pragma mark - 八、- 专属方案 - 列表
@implementation OrderList
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderListModel class]];
}
@end

#pragma mark - 专属方案 - 列表
@implementation OrderListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"order_id":@"order_id",
             @"member_id":@"member_id",
             @"cover_img":@"cover_img",
             @"analysis":@"analysis",
             @"effect":@"effect",
             @"is_pay":@"is_pay",
             @"item":@"item"
             };
}
+ (NSValueTransformer *)itemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderItemModel class]];
}
@end

#pragma mark - 专属方案 - 列表
@implementation OrderItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"order_id":@"order_id",
             @"item_id":@"item_id",
             @"real_time_fee":@"real_time_fee",
             @"surgery_id":@"surgery_id",
             @"item_name":@"item_name"
             };
}
@end















