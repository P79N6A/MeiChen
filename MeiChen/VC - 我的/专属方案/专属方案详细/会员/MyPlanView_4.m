//
//  MyPlanView_4.m
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanView_4.h"

@implementation MyPlanView_4

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyPlanView_4" owner:nil options:nil] firstObject];
        self.frame = frame;
        [self settingLab_1:@"0"];
        [self settingDetail_1:0];
        [self settingLab_2];
        [self settingPrice_1:0];
        [self settingPrice_2:0];
        [self.pay setTitle:NSLocalizedString(@"MyPlanVC_25", nil) forState:(UIControlStateNormal)];
    }
    return self;
}

- (void)loadDataWith:(PlanDetailModel *)model {
    for (int i = 0; i < model.coupon_calc.count; i ++) {
        PlanDetailCouponCalc *calc = model.coupon_calc[i];
        if ([calc.key isEqualToString:@"valid_coupon_num"]) {
            [self settingLab_1:calc.val]; // 可用有效优惠券数
        }
    }
    [self settingDetail_1:model.coupon_deduct];
    [self settingPrice_1:model.total_price];
    [self settingPrice_2:model.total_deduct];
}

- (void)settingLab_2 {
    self.lab_2.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"MyPlanVC_22", nil)];
    self.tf.placeholder = NSLocalizedString(@"MyPlanVC_23", nil);
}

- (void)settingDetail_1:(NSInteger)str {
    self.detail_1.text = [NSString stringWithFormat:@"-￥%ld",str];
}

- (void)settingLab_1:(NSInteger)str {
    self.lab_1.text = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"MyPlanVC_20", nil),str,NSLocalizedString(@"MyPlanVC_21", nil)];
}

- (void)settingPrice_1:(NSInteger)str {
    self.price_1.text = [NSString stringWithFormat:@"￥%ld",str];
}

- (void)settingPrice_2:(NSInteger)str {
    self.price_2.text = [NSString stringWithFormat:@"%@￥%ld",NSLocalizedString(@"MyPlanVC_24", nil),str];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
