//
//  NewPerferCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "NewPerferCell.h"

@implementation NewPerferCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    NewPerferCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewPerferCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)loadData:(NSIndexPath *)indexPath model:(PlanDetailCoupons *)model {
    self.name.text = model.coupon.title;
    self.price.text = [NSString stringWithFormat:@"-￥%@",model.coupon.value];
    if (model.is_gray == 1) {
        self.backBu.hidden = NO;
    }
    else {
        self.backBu.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
