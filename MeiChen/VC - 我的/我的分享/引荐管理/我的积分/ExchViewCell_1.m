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
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 23.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
