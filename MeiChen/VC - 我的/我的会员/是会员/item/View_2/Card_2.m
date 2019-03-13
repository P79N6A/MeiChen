//
//  Card_2.m
//  meirong
//
//  Created by yangfeng on 2019/3/12.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "Card_2.h"

@implementation Card_2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Card_2" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = self.button.frame.size.height/2.0;
    
    self.circle_1.layer.masksToBounds = YES;
    self.circle_1.layer.cornerRadius = self.circle_1.frame.size.height/2.0;
    
    self.circle_2.layer.masksToBounds = YES;
    self.circle_2.layer.cornerRadius = self.circle_2.frame.size.height/2.0;
    
    self.circle_3.layer.masksToBounds = YES;
    self.circle_3.layer.cornerRadius = self.circle_3.frame.size.height/2.0;
    
}

@end
