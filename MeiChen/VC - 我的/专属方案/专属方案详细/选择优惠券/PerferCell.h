//
//  PerferCell.h
//  meirong
//
//  Created by yangfeng on 2019/3/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *select;

@property (weak, nonatomic) IBOutlet UIButton *backBu;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath item:(PlanDetailCoupons *)item select:(NSArray *)select;
- (void)NotDelect:(NSArray *)select;

@end
