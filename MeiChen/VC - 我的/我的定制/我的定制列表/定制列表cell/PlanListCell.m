//
//  PlanListCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanListCell.h"

@implementation PlanListCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    PlanListCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)loadSinglePlanModel:(SinglePlanModel *)model {
    self.timeLab.text = [self timeStr:model.finish_at];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.item.cover_img]];
    self.name.text = model.item.item_name;
    self.detail.text = model.scheme;
    self.price.text = [NSString stringWithFormat:@"￥%@",model.item.fee];
    self.numLab.text = [self NumStr:model.item.booking_num];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 6.0;
}

- (NSString *)timeStr:(NSString *)str {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"PlanListVC_1", nil),time];
}

- (NSString *)NumStr:(NSString *)str {
    NSInteger k = [str integerValue];
    if (k < 10000) {
        return [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"PlanListVC_2", nil),k];
    }
    else {
        NSInteger shang = k / 10000;
        NSInteger yushu = k % 10000;
        return [NSString stringWithFormat:@"%@%ld.%ld%@+",NSLocalizedString(@"PlanListVC_2", nil),shang,yushu,NSLocalizedString(@"PlanListVC_3", nil)];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
