//
//  ServerModel.h
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 一、
#pragma mark - 我的服务 - 侧边栏专属方案
@interface SideBarSurgeryModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *is_allow_book;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *doctor_id;
@property (nonatomic, strong) NSString *is_book;
@property (nonatomic, strong) NSString *is_success;
@property (nonatomic, strong) NSString *process;
@end

#pragma mark - 我的服务 - 侧边栏专属方案
@interface SideBarModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, copy) NSArray *surgery;
@end


#pragma mark - 我的服务 - 侧边栏专属方案
@interface SideBarListModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSArray *data;
@end





#pragma mark - 二、
#pragma mark - 我的服务 - fiche
@interface FicheModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *process;
@property (nonatomic) NSInteger is_points_get;
@property (nonatomic) NSInteger is_do_action;
@property (nonatomic, strong) NSString *action;
@property (nonatomic) NSInteger foreign_id;
@end

#pragma mark - 我的服务 - board
@interface BoardModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *unit;
@end

#pragma mark - 我的服务 - order
@interface OrderModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *diagnose_at;
@end

#pragma mark - 我的服务 - 手术详细
@interface SurgeryModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *surgery_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *is_confirm;
@property (nonatomic, strong) NSString *is_success;
@property (nonatomic, strong) NSString *book_date;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *is_book;
@property (nonatomic, strong) NSString *success_at;
@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) BoardModel *board;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, copy) NSArray *fiche;
@end

