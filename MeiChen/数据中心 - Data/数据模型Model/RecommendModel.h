//
//  DataModel.h
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

#pragma mark - 一、- 推荐首页 - 热门数据模型
@interface HotModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *menu;
@property (nonatomic, copy) NSArray *list;
@end

#pragma mark - 推荐首页 - 热门数据模型 - menu模型
@interface MenuModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *guide;
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型
@class MemberModel;
@class BriefModel;
@interface ListModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *status;
@property (nonatomic) NSInteger has_like;
@property (nonatomic, strong) MemberModel *member;
@property (nonatomic, strong) BriefModel *brief;
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型 - member模型
@interface MemberModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *member_id;
@end

#pragma mark - 推荐首页 - 热门数据模型 - list模型 - brief模型
@interface BriefModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, strong) NSString *brief;
@end

#pragma mark - 推荐首页 - 热门数据模型 -分类模型
@interface TypeModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark -  二、-所有分类菜单
@interface AllMenuModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 所有分类菜单 - 子菜单模型
@interface ChildMenuModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSArray *sub;
@end

#pragma mark - 所有分类菜单 - 子菜单模型 - 子菜单模型2
@interface ChildMenuModel_2 : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSArray *sub;
@end

#pragma mark - 所有分类菜单 - 子菜单模型 - 子菜单模型2 - 子菜单模型3
@interface ChildMenuModel_3 : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *title;
@end

#pragma mark - 三、- 案例详细模型
@class cardModel;
@interface CaseDetailModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *fix_at;
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, copy) NSArray *pre_imgs;
@property (nonatomic, strong) MemberModel *member;
@property (nonatomic, copy) NSArray *tag;
@property (nonatomic, strong) cardModel *card;
@property (nonatomic, copy) NSArray *item;
@property (nonatomic, copy) NSArray *daily;
@end

#pragma mark - 标签模型
@interface tagModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *tag_id;
@property (nonatomic, strong) NSString *tag_name;
@end

#pragma mark - 会员卡模型
@interface cardModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *title;
@end

#pragma mark - 手术模型
@interface itemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *item_name;
@end

#pragma mark - 日记模型
@interface DailyModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *daily_id;
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *view_num;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSString *photo_at;
@property (nonatomic) NSInteger has_like;
@end

#pragma mark - 评论数组模型
@interface revertArrayModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 评论模型
@interface revertModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *foreign_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_at;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) MemberModel *member;
@end


#pragma mark - 被评论模型
@interface reviewModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *foreign_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_at;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) MemberModel *member;
@property (nonatomic, strong) revertModel *sub;
@end


#pragma mark - 四、- 用户模型
@interface UserModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *create_at;
@property (nonatomic, strong) NSString *update_at;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *is_able;
@property (nonatomic, strong) NSString *link_heads;
@property (nonatomic, strong) NSString *pid;
@end


#pragma mark - 五、- 方案定制页数据
@interface PlanModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end


#pragma mark - 方案定制页数据 - 模特照片数组模型
@interface PlanImagesModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 方案定制页数据 - 模特照片模型
@interface ImageModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *img;
@property (nonatomic) NSInteger row;
@end

#pragma mark - 方案定制页数据 - 类型
@class PlanRemarkModel;
@interface PlanStyleModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *tag_id;
@property (nonatomic, strong) NSString *tag_name;
@property (nonatomic, strong) NSString *tag_type;
@property (nonatomic, strong) PlanRemarkModel *remark;
@property (nonatomic, strong) NSString *pid;
@end

#pragma mark - 方案定制页数据 - 部位
@interface PlanRemarkModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *front;
@property (nonatomic, strong) NSString *part;
@property (nonatomic, strong) NSString *front_more;
@property (nonatomic, strong) NSString *part_more;
@property (nonatomic, copy) NSArray *front_photo;
@property (nonatomic, copy) NSArray *part_photo;
@end


#pragma mark - 六、- 定制列表数据
@interface PlanListModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 定制列表数据 - 单个定制数据
@class PlanItemModel;
@interface SinglePlanModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *imitate_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *finish_at;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) PlanItemModel *item;
@end



#pragma mark - 定制列表数据 - 单个定制数据 - item
@interface PlanItemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *item_name;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *booking_num;
@end

#pragma mark - 专属方案数据 - 专属方案详细
@class PlanDetailListModel;
@class PlanCardModel;
@interface PlanDetailModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic) NSInteger pre_total_price;
@property (nonatomic) NSInteger discount_deduct;
@property (nonatomic) NSInteger points_deduct;
@property (nonatomic) NSInteger coupon_deduct;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *total_price_origin;
@property (nonatomic, copy) NSArray *item;
@property (nonatomic) NSInteger is_card_member;
@property (nonatomic) NSInteger has_card;
@property (nonatomic, copy) NSArray *card_calc;
@property (nonatomic) NSInteger has_coupon;
@property (nonatomic, copy) NSArray *coupons;
@property (nonatomic, copy) NSArray *coupon_calc;
@property (nonatomic) NSInteger total_deduct;
@property (nonatomic) NSInteger total_price;
@end

#pragma mark - 专属方案数据 - 专属方案详细 - item
@interface PlanDetailItem : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *real_time_fee;
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *item_name;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *booking_num;
@property (nonatomic, strong) NSString *cover_img;
@end

#pragma mark - 专属方案数据 - 专属方案详细 - card_calc
@interface PlanDetailCardCalc : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@end

#pragma mark - 专属方案数据 - 专属方案详细 - coupons
@class PlanDetailCouponsCoupon;
@interface PlanDetailCoupons : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *get_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *coupon_id;
@property (nonatomic, strong) NSString *is_used;
@property (nonatomic, strong) NSString *receive_at;
@property (nonatomic, strong) NSString *start_on;
@property (nonatomic, strong) NSString *expire_on;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) PlanDetailCouponsCoupon *coupon;
@property (nonatomic) NSInteger is_gray;
@end

#pragma mark - 专属方案数据 - 专属方案详细 - coupons
@interface PlanDetailCouponsCoupon : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *coupon_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *start_on;
@property (nonatomic, strong) NSString *expire_on;
@property (nonatomic, strong) NSString *expire_after_days;
@property (nonatomic, strong) NSString *threshold;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *is_pick;
@property (nonatomic, strong) NSString *is_share;
@property (nonatomic, strong) NSString *card_id;
@end

#pragma mark - 专属方案数据 - 专属方案详细 - coupon_calc
@interface PlanDetailCouponCalc : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *key;
@property (nonatomic) NSInteger val;
@end

#pragma mark - 专属方案数据 - 手术列表
@interface SurgeryList : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, copy) NSArray *surgery;
@end

#pragma mark - 专属方案数据 - 手术列表 - items
@interface SurgeryListItem : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *real_time_fee;
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *item_name;
@end

#pragma mark - 专属方案数据 - 手术列表 - surgery
@interface SurgeryListSurgery : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *is_allow_book;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *doctor_id;
@property (nonatomic, copy) NSArray *items;
@end









#pragma mark - 七、- 我的日记本数据
@interface MyDiaryData : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 我的日记本
@interface MyDiaryModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, strong) NSString *create_at;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *views_num;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *pass_daily_num;
@property (nonatomic, copy) NSArray *item;

@end

#pragma mark - 我的日记本 - 日记本详情
@interface DiaryDetailModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *fix_at;
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, strong) MemberModel *member;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, copy) NSArray *pre_imgs;
@property (nonatomic, copy) NSArray *item;
@property (nonatomic, copy) NSArray *daily;

@end

#pragma mark - 我的日记本 - 日记本详情 - 日记item
@interface DailyDetailItem : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *daily_id;
@property (nonatomic, strong) NSString *sample_id;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *photo_at;
@property (nonatomic, strong) NSString *status;
@end

#pragma mark - 我的日记本 - images
@interface AddUpdateModel : NSObject
// 0 -> 新增， 1 -> 更新
@property (nonatomic) NSInteger status;
@property (nonatomic, strong) NSString *str;
@end


#pragma mark - 八、- 专属方案 - 列表
@interface OrderList : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end

#pragma mark - 专属方案 - 列表
@interface OrderListModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *analysis;
@property (nonatomic, strong) NSString *effect;
@property (nonatomic, strong) NSString *is_pay;
@property (nonatomic, copy) NSArray *item;
@end

#pragma mark - 专属方案 - 列表
@interface OrderItemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *real_time_fee;
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *item_name;
@end

















