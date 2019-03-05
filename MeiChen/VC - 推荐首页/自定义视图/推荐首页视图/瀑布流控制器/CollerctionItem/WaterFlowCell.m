//
//  WaterFlowCell.m
//  meirong
//
//  Created by yangfeng on 2018/12/14.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "WaterFlowCell.h"

@implementation WaterFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.height / 2.0;

}

- (void)loadData:(id)data {
    if (![data isKindOfClass:[ListModel class]]) {
        return;
    }
    ListModel *model = (ListModel *)data;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.cover_img]];
    self.titleLab.text = model.brief.brief;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.member.avatar]];
    self.name.text = model.member.nickname;
    if ([model.like_num integerValue] > 10000) {
        NSInteger k = [model.like_num integerValue] / 10000;
        [self.zan setTitle:[NSString stringWithFormat:@" %ld%@",k,NSLocalizedString(@"tuijian_2", nil)] forState:UIControlStateNormal];
    }
    else {
        [self.zan setTitle:[NSString stringWithFormat:@" %@",model.like_num] forState:UIControlStateNormal];
    }
    if (model.has_like == 1) {
        self.zan.selected = YES;
    }
    else {
        self.zan.selected = NO;
    }
}

@end
