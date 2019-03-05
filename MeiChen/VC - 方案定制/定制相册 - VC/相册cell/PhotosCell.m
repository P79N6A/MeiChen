//
//  PhotosCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosCell.h"

@implementation PhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PhotosCell" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.button setTintColor:[UIColor clearColor]];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}





@end
