//
//  MyDZModel.h
//  meirong
//
//  Created by yangfeng on 2019/3/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

#pragma mark - 我的定制详情数据 - list
@class PlanItemModel;
@interface MyDZListModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *pre_img;
@property (nonatomic, strong) NSString *done_img;
@property (nonatomic, strong) NSString *imitate_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *has_seen;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) PlanItemModel *item;
@end

#pragma mark - 我的定制详情数据 - sample
@interface MyDZSampleModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *brief;
@end


#pragma mark - 我的定制详情数据
@interface MyDZDetailModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *sample;
@property (nonatomic) NSInteger has_card;
@property (nonatomic) NSInteger has_coupon;
@property (nonatomic, strong) MyDZListModel *list;
@property (nonatomic, copy) NSArray *card_calc;
@property (nonatomic, copy) NSArray *coupons;
@property (nonatomic, copy) NSArray *coupon_calc;
@property (nonatomic) NSInteger init_total_price;
@property (nonatomic) NSInteger total_deduct;
@property (nonatomic) NSInteger total_price;
@end
