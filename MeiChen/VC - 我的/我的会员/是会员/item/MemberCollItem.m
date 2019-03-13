//
//  MemberCollItem.m
//  meirong
//
//  Created by yangfeng on 2019/3/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MemberCollItem.h"
#import "Card_1.h"
#import "Card_2.h"

@interface MemberCollItem () {
    Card_1 *card_1;
    Card_2 *card_2;
}
@end

@implementation MemberCollItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MemberCollItem" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        card_1 = [[Card_1 alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        card_2 = [[Card_2 alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadDataWith:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [self addSubview:card_1];
    }
    else {
        [self addSubview:card_2];
    }
}

@end
