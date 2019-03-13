//
//  CardView_1.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CardView_1.h"

@implementation CardView_1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CardView_1" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.select_2.selected = YES;
        [self settingLab_5:@"0"];
        [self settingDetail_4:0];
        [self settingLab_6];
        [self settingPrice_1:0];
    }
    return self;
}

- (void)loadDataWith:(MyDZDetailModel *)model coupon_deduct:(NSInteger)coupon_deduct {
    for (int i = 0; i < model.card_calc.count; i ++) {
        PlanDetailCardCalc *calc = model.card_calc[i];
        
        if ([calc.key isEqualToString:@"card_title"]) {
            [self settingLab_1:calc.val]; // 会员等级
        }
        else if ([calc.key isEqualToString:@"discount"]) {
            [self settingLab_2:calc.val];// 会员折扣
        }
        else if ([calc.key isEqualToString:@"discount_deduct"]) {
            [self settingDetail_1:calc.val];// 会员折扣扣减
        }
        else if ([calc.key isEqualToString:@"points_get_multiple"]) {
            [self settingLab_3:calc.val];// 积分倍数
        }
        else if ([calc.key isEqualToString:@"points_get"]) {
            [self settingDetail_2:calc.val];// 本次可累计积分
        }
        else if ([calc.key isEqualToString:@"points_deduct_rate"]) {
            [self settingLab_4:calc.val];// 积分抵扣比例
        }
        else if ([calc.key isEqualToString:@"points_use"]) {
            [self settingDetail_3_1:calc.val];// 最终可用积分
        }
        else if ([calc.key isEqualToString:@"points_deduct"]) {
            [self settingDetail_3_2:calc.val];// 可用积分抵扣
        }
    }
    for (int i = 0; i < model.coupon_calc.count; i ++) {
        PlanDetailCouponCalc *calc = model.coupon_calc[i];
        if ([calc.key isEqualToString:@"valid_coupon_num"]) {
            [self settingLab_5:calc.val]; // 可用有效优惠券数
        }
    }
    [self settingDetail_4:coupon_deduct];
    [self settingLab_6];
    [self settingPrice_1:model.total_price];
}

- (void)settingPrice_1:(NSInteger)str {
    self.price_1.text = [NSString stringWithFormat:@"￥%ld",str];
}

- (void)settingLab_6 {
    self.lab_6.text = NSLocalizedString(@"MyPlanVC_9", nil);
}

- (void)settingDetail_4:(NSInteger)str {
    self.detail_4.text = [NSString stringWithFormat:@"-￥%ld",str];
}

- (void)settingLab_5:(NSInteger)str {
    self.lab_5.text = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"MyPlanVC_20", nil),str,NSLocalizedString(@"MyPlanVC_21", nil)];
}

// 可用积分抵扣
- (void)settingDetail_3_2:(NSString *)str {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:self.detail_3.text];
    NSString *str_1 = [NSString stringWithFormat:@"%@%@",str,
                       NSLocalizedString(@"MyPlanVC_16", nil)];
    [m_str appendString:str_1];
    self.detail_3.text = m_str;
}
// 最终可用积分
- (void)settingDetail_3_1:(NSString *)str {
    self.detail_3.text = [NSString stringWithFormat:@"%@%@%@",
                          NSLocalizedString(@"MyPlanVC_14", nil),str,
                          NSLocalizedString(@"MyPlanVC_15", nil)];
}
// 积分抵扣比例
- (void)settingLab_4:(NSString *)str {
    self.lab_4.text = [NSString stringWithFormat:@"%@%@%%",NSLocalizedString(@"MyPlanVC_12", nil),str];
}
// 本次可累计积分
- (void)settingDetail_2:(NSString *)str {
    self.detail_2.text = [NSString stringWithFormat:@"%@%@%@",
                          NSLocalizedString(@"MyPlanVC_17", nil),str,
                          NSLocalizedString(@"MyPlanVC_18", nil)];
}
// 积分倍数     1.3倍积分
- (void)settingLab_3:(NSString *)str {
    self.lab_3.text = [NSString stringWithFormat:@"%@%@",str,NSLocalizedString(@"MyPlanVC_13", nil)];
}
// 会员折扣扣减    -￥2660
- (void)settingDetail_1:(NSString *)str {
    self.detail_1.text = [NSString stringWithFormat:@"-￥%@",str];
}
// 会员折扣8.6折
- (void)settingLab_2:(NSString *)str {
    self.lab_2.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"MyPlanVC_10", nil),str,NSLocalizedString(@"MyPlanVC_11", nil)];
}

// 会员
- (void)settingLab_1:(NSString *)str {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:NSLocalizedString(@"MyPlanVC_7", nil)];
    [m_str appendString:str];
    [m_str appendString:@","];
    [m_str appendString:NSLocalizedString(@"MyPlanVC_8", nil)];
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:m_str];
    NSRange range = [m_str rangeOfString:str];
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x333333) range:NSMakeRange(0, m_str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] range:NSMakeRange(0, m_str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x21C9D9) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:range];
    
    self.lab_1.attributedText = attribut;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
