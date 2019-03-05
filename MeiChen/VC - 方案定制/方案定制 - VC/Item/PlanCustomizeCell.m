//
//  PlanCustomizeCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/17.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanCustomizeCell.h"

@implementation PlanCustomizeCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlanCustomizeCell" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 27.0 / 2.0;
}

- (void)imvColorWith:(NSInteger)row {
    NSArray *arr = @[kColorRGB(0x74D9FF),kColorRGB(0x83EBC8),kColorRGB(0xFFD48A),
                     kColorRGB(0x51D6AF),kColorRGB(0xFF97C1),kColorRGB(0xFFD9AD),
                     kColorRGB(0xFFA4A2),kColorRGB(0xD4B2FF),kColorRGB(0x67D1FF),
                     kColorRGB(0x4198F9)];
    NSInteger k = 0;
    if (row < arr.count) {
        k = row;
    }
    else {
        k = row % arr.count;
    }
    self.icon.backgroundColor = arr[k];
}

@end
