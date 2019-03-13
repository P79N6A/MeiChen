//
//  ServerPlanListView.h
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockModelTag)(SideBarSurgeryModel *model);
@interface ServerPlanListView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITableView *tabview;

@property (nonatomic, strong) NSMutableArray *m_array;

@property (copy, nonatomic) blockModelTag index;

- (void)show;

- (void)settingCurrentIndexPathWith:(NSString *)order_id surgery_id:(NSString *)surgery_id;

@end

