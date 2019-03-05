//
//  HistoryHeader.m
//  meirong
//
//  Created by yangfeng on 2018/12/28.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "HistoryHeader.h"


@implementation HistoryHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HistoryHeader" owner:nil options:nil] firstObject];
    }
    return self;
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
