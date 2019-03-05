//
//  PlanItemCell.h
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath item:(PlanDetailItem *)item;

- (void)iconImageView:(NSString *)url;
- (void)label_1:(NSString *)str;
- (void)label_2:(NSString *)str;
- (void)label_3:(NSString *)str;
- (void)label_4:(NSString *)str;

@end
