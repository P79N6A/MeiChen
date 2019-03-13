//
//  Card_1.m
//  meirong
//
//  Created by yangfeng on 2019/3/12.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "Card_1.h"

@implementation Card_1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Card_1" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.height/2.0;
    
    self.unit_1.text = NSLocalizedString(@"MyCardVC_2", nil);
    self.unit_2.text = NSLocalizedString(@"MyCardVC_3", nil);
    self.unit_3.text = NSLocalizedString(@"MyCardVC_4", nil);
    
    self.value_1.text = @"0";
    self.value_2.text = @"0";
    self.value_3.text = @"0";
    
    self.name.text = @"尊享会员";
    self.time.text = @"2019-12-12到期";
    
    self.icon.backgroundColor = kColorRGB(0xf0f0f0);
}



@end
