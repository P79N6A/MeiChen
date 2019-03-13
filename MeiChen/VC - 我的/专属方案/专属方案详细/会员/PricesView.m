//
//  PricesView.m
//  meirong
//
//  Created by yangfeng on 2019/3/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PricesView.h"

@implementation PricesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PricesView" owner:nil options:nil] firstObject];
        self.frame = frame;
        [self settingPrice_1:0];
        [self settingPrice_2:0];
        [self.pay setTitle:NSLocalizedString(@"MyPlanVC_25", nil) forState:(UIControlStateNormal)];
    }
    return self;
}

- (void)loadDataWith:(PlanDetailModel *)model {
    [self settingPrice_1:model.total_price];
    [self settingPrice_2:model.total_deduct];
}

- (void)settingPrice_1:(NSInteger)str {
    self.price_1.text = [NSString stringWithFormat:@"￥%ld",str];
}

- (void)settingPrice_2:(NSInteger)str {
    self.price_2.text = [NSString stringWithFormat:@"%@￥%ld",NSLocalizedString(@"MyPlanVC_24", nil),str];
}

@end
