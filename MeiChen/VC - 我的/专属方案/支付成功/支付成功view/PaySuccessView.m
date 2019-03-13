//
//  PaySuccessView.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PaySuccessView.h"

@implementation PaySuccessView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PaySuccessView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.frame = CGRectMake(0, 0, width, 300);
    }
    return self;
}

@end
