//
//  MyShareItem.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareItem.h"

@implementation MyShareItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyShareItem" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0;
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 11.0;
    
    self.imv.layer.masksToBounds = YES;
}

- (void)loadData:(ShareMintermsModel *)model {
    self.lab.text = model.term_name;
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.cover_img]];
    if (model.is_booking == 1) {
        [self.button setTitle:NSLocalizedString(@"MyShareVC_11", nil) forState:(UIControlStateNormal)];
        [self.button setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:(UIControlStateNormal)];
        self.button.backgroundColor = [UIColor clearColor];
    }
    else {
        [self.button setTitle:NSLocalizedString(@"MyShareVC_12", nil) forState:(UIControlStateNormal)];
        [self.button setBackgroundImage:nil forState:(UIControlStateNormal)];
        self.button.backgroundColor = kColorRGB(0xcccccc);
    }
}

@end
