//
//  ExchViewCell_1.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchViewCell_1.h"

@implementation ExchViewCell_1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bu_1.layer.masksToBounds = YES;
    self.bu_1.layer.cornerRadius = 10.0;
    
    self.bu_2.layer.masksToBounds = YES;
    self.bu_2.layer.cornerRadius = 10.0;
    
    self.bu_3.layer.masksToBounds = YES;
    self.bu_3.layer.cornerRadius = 10.0;
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 23.0;
    
    self.bu_1.hidden = YES;
    self.bu_2.hidden = YES;
    self.bu_3.hidden = YES;
}

- (void)loadData:(CommissionStreamModel *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLab.text = model.nickname;
    self.proLab.text = NSLocalizedString(@"ExchangeVC_8", nil);
    self.lab_1.text = [NSString stringWithFormat:@"%@: %@%@",
                       NSLocalizedString(@"ExchangeVC_9", nil),
                       model.total_price,
                       NSLocalizedString(@"ExchangeVC_10", nil)];
    self.lab_2.text = [NSString stringWithFormat:@"+%@%@",
                       model.commission.points,
                       NSLocalizedString(@"ExchangeVC_11", nil)];

    if (model.item.count>=1) {
        itemModel *item = model.item[0];
        [self.bu_1 setTitle:[NSString stringWithFormat:@"  %@  ",item.item_name] forState:(UIControlStateNormal)];
        self.bu_1.hidden = NO;
    }
    if (model.item.count>=2) {
        itemModel *item = model.item[1];
        [self.bu_2 setTitle:[NSString stringWithFormat:@"  %@  ",item.item_name] forState:(UIControlStateNormal)];
        self.bu_2.hidden = NO;
    }
    if (model.item.count>=3) {
        itemModel *item = model.item[2];
        [self.bu_3 setTitle:[NSString stringWithFormat:@"  %@  ",item.item_name] forState:(UIControlStateNormal)];
        self.bu_3.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
