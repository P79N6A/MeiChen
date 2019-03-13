//
//  ServerModel.m
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServerModel.h"

#pragma mark - 我的服务 - 侧边栏专属方案
@implementation SideBarSurgeryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"surgery_id":@"surgery_id",
             @"order_id":@"order_id",
             @"is_allow_book":@"is_allow_book",
             @"seq":@"seq",
             @"doctor_id":@"doctor_id",
             @"is_book":@"is_book",
             @"is_success":@"is_success",
             @"process":@"process"
             };
}
@end

#pragma mark - 我的服务 - 侧边栏专属方案
@implementation SideBarModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"order_id":@"order_id",
             @"surgery":@"surgery"
             };
}
+ (NSValueTransformer *)surgeryJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SideBarSurgeryModel class]];
}
@end

#pragma mark - 我的服务 - 侧边栏专属方案
@implementation SideBarListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"data":@"data"};
}
+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SideBarModel class]];
}
@end


#pragma mark - 我的服务 - fiche
@implementation FicheModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"name":@"name",
             @"date":@"date",
             @"points":@"points",
             @"process":@"process",
             @"is_points_get":@"is_points_get",
             @"is_do_action":@"is_do_action",
             @"action":@"action",
             @"foreign_id":@"foreign_id",
             };
}
@end


#pragma mark - 我的服务 - board
@implementation BoardModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"brief":@"brief",
             @"val":@"val",
             @"unit":@"unit",
             };
}
@end

#pragma mark - 我的服务 - order
@implementation OrderModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"diagnose_at":@"diagnose_at",
             };
}
@end

#pragma mark - 我的服务 - 手术详细
@implementation SurgeryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"surgery_id":@"surgery_id",
             @"member_id":@"member_id",
             @"order_id":@"order_id",
             @"is_confirm":@"is_confirm",
             @"is_success":@"is_success",
             @"book_date":@"book_date",
             @"seq":@"seq",
             @"is_book":@"is_book",
             @"success_at":@"success_at",
             @"order":@"order",
             @"items":@"items",
             @"board":@"board",
             @"tips":@"tips",
             @"fiche":@"fiche",
             };
}
+ (NSValueTransformer *)orderJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderModel class]];
}
+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[itemModel class]];
}
+ (NSValueTransformer *)boardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BoardModel class]];
}

+ (NSValueTransformer *)ficheJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FicheModel class]];
}
@end




