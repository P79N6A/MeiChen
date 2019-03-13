//
//  ServerPlanListCell.h
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerPlanListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UIImageView *icon;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadData:(SideBarSurgeryModel *)model;

@end
