//
//  HistoryCell.m
//  meirong
//
//  Created by yangfeng on 2018/12/28.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
    
}

@end
