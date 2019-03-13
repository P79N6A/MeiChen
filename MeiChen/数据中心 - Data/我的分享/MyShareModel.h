//
//  MyShareModel.h
//  meirong
//
//  Created by yangfeng on 2019/3/12.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 1、我的分享
#pragma mark - 我的分享 - base_info
@interface BaseInfoModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *motto;
@end


#pragma mark - 我的分享 - card
@interface ShareCardModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *card_id;
@property (nonatomic, strong) NSString *card_title;
@property (nonatomic, strong) NSString *period;
@property (nonatomic, strong) NSString *accu_money;
@property (nonatomic, strong) NSString *plus_money;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *points_deduct_rate;
@property (nonatomic, strong) NSString *points_get_multiple;
@property (nonatomic, strong) NSString *minterms;
@end

#pragma mark - 我的分享 - share_minterms
@interface ShareMintermsModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *minterm_id;
@property (nonatomic, strong) NSString *hospital_id;
@property (nonatomic, strong) NSString *term_name;
@property (nonatomic, strong) NSString *cover_img;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *term_type;
@property (nonatomic, strong) NSString *dots;
@property (nonatomic, strong) NSString *spend_points;
@property (nonatomic) NSInteger is_booking;
@end


#pragma mark - 我的分享
@interface ShareModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) BaseInfoModel *base_info;
@property (nonatomic, strong) ShareCardModel *card;
@property (nonatomic) NSInteger commission_points;
@property (nonatomic) NSInteger commission_num_direct;
@property (nonatomic, copy) NSArray *share_minterms;
@property (nonatomic) NSInteger share_times_sum;
@property (nonatomic) NSInteger share_times_used;
@property (nonatomic) NSInteger share_times_remain;
@end



#pragma mark - 2、我的积分

#pragma mark - 我的积分 - commission_stream - commission
@interface CommissionModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *stream_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *create_at;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *foreign_id;
@property (nonatomic, strong) NSString *foreign_table;
@end

#pragma mark - 我的积分 - commission_stream
@interface CommissionStreamModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *agent_id;
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, copy) NSArray *item;
@property (nonatomic, strong) CommissionModel *commission;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@end

#pragma mark - 我的积分
@interface JiFenModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *commission_stream;
@property (nonatomic) NSInteger commission_points;
@end


#pragma mark - 3、我的好友

#pragma mark - 我的好友 - friends - friend
@interface Friend : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) NSInteger member_id;
@property (nonatomic) NSInteger commission_num_indirect;
@end

#pragma mark - 我的好友 - grade_info - current_grage
@interface CurrentGrageModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *grade_id;
@property (nonatomic, strong) NSString *min_heads;
@property (nonatomic, strong) NSString *max_heads;
@property (nonatomic, strong) NSString *grade_title;
@end

#pragma mark - 我的好友 - grade_info - next_grage
@interface NextGrageModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *grade_id;
@property (nonatomic, strong) NSString *min_heads;
@property (nonatomic, strong) NSString *max_heads;
@property (nonatomic, strong) NSString *grade_title;
@end

#pragma mark - 我的好友 - grade_info
@interface GradeInfoModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) CurrentGrageModel *current_grage;
@property (nonatomic, strong) NextGrageModel *next_grage;
@end

#pragma mark - 我的好友
@interface FriendModel : MTLModel <MTLJSONSerializing>
@property (nonatomic) NSInteger commission_num_indirect;
@property (nonatomic, copy) NSArray *friends;
@property (nonatomic, strong) GradeInfoModel *grade_info;
@end


















