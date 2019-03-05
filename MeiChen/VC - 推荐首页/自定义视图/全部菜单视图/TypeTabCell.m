//
//  TypeTabCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "TypeTabCell.h"

@implementation TypeTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didSelectWithRow:(NSInteger)row tag:(NSInteger)tag {
    if (row == tag) {
        self.imv.image = [UIImage imageNamed:@"竖条"];
        self.titleLab.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    }
    else {
        self.imv.image = [UIImage new];
        self.titleLab.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
