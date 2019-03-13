//
//  PerferCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PerferCell.h"

@implementation PerferCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    PerferCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PerferCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.select.selected = NO;
    self.backBu.hidden = YES;
}

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath item:(PlanDetailCoupons *)item select:(NSArray *)select {
    self.name.text = [NSString stringWithFormat:@"%@%@:%@",
                      item.coupon.value,
                      NSLocalizedString(@"MyPlanVC_16", nil),
                      item.coupon.title];
    
    for (int i = 0; i < select.count; i++) {
        PlanDetailCoupons *model = select[i];
        if ([item.coupon_id isEqualToString:model.coupon_id]) {
            self.select.selected = YES;
        }
    }
    if (item.is_gray == 1) {
        self.backBu.hidden = NO;
        self.select.selected = NO;
    }
    else {
        self.backBu.hidden = YES;
    }
}

- (void)NotDelect:(NSArray *)select {
    self.name.text = NSLocalizedString(@"MyPlanVC_27", nil);
    if (select.count == 0) {
        self.select.selected = YES;
    }
    else {
        self.select.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
