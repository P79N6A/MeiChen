//
//  NewPerferCell.h
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPerferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIButton *backBu;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadData:(NSIndexPath *)indexPath model:(PlanDetailCoupons *)model;

@end
