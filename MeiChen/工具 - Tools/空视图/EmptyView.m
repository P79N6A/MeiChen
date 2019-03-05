//
//  EmptyView.m
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (IBAction)TouchMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(EmptyViewDidTouch)]) {
        [self.delegate EmptyViewDidTouch];
    }
}


@end
