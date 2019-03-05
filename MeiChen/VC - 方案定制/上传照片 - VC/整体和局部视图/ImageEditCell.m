//
//  ImageEditCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/19.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ImageEditCell.h"

@implementation ImageEditCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ImageEditCell" owner:nil options:nil] firstObject];
        
    }
    return self;
}

- (void)SettingDeleteButtonWidth:(NSInteger)width {
    self.deleteBu.frame = ({
        CGRect frame = self.deleteBu.frame;
        frame.size.width = width;
        frame.size.height = width;
        frame.origin.x = self.frame.size.width - width;
        frame.origin.y = 0;
        frame;
    });
}

@end
