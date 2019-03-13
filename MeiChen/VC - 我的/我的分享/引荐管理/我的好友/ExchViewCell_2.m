//
//  ExchViewCell_2.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchViewCell_2.h"

@implementation ExchViewCell_2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 23.0;
}

- (void)loadData:(Friend *)model {
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLab.text = model.nickname;
    self.lab_2.text = [NSString stringWithFormat:@"%@: %ld%@",
                       NSLocalizedString(@"ExchangeVC_14", nil),
                       model.commission_num_indirect,
                       NSLocalizedString(@"ExchangeVC_13", nil)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
