//
//  MyShareCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareCell.h"

@implementation MyShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 12.0;
    
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
