//
//  PlanItemCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExcSolDetailItemCell.h"

@implementation ExcSolDetailItemCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    ExcSolDetailItemCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExcSolDetailItemCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 6.0;
}

-(void)setFrame:(CGRect)frame {
    frame.size.height -= 15;
    [super setFrame:frame];
}

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath item:(PlanDetailItem *)item {
    [self iconImageView:item.cover_img];
    [self label_1:item.item_name];
    [self label_2:item.brief];
    [self label_3:item.real_time_fee];
    [self label_4:item.booking_num];
}

- (void)iconImageView:(NSString *)url {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url]];
}
- (void)label_1:(NSString *)str {
    self.lab_1.text = str;
    self.lab_1.backgroundColor = [UIColor clearColor];
}
- (void)label_2:(NSString *)str {
    self.lab_2.text = str;
    self.lab_2.backgroundColor = [UIColor clearColor];
}
- (void)label_3:(NSString *)str {
    self.lab_3.text = [NSString stringWithFormat:@"￥%@",str];
    self.lab_3.backgroundColor = [UIColor clearColor];
}
- (void)label_4:(NSString *)str {
    self.lab_4.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"PlanListVC_2", nil),str];
    self.lab_4.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
