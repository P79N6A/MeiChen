//
//  MyCardTabView.m
//  meirong
//
//  Created by yangfeng on 2019/3/12.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyCardTabView.h"

@implementation MyCardTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyCardTabView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bu_1 setTitle:NSLocalizedString(@"MyCardVC_5", nil) forState:(UIControlStateNormal)];
    [self.bu_2 setTitle:NSLocalizedString(@"MyCardVC_6", nil) forState:(UIControlStateNormal)];
    [self.bu_3 setTitle:NSLocalizedString(@"MyCardVC_7", nil) forState:(UIControlStateNormal)];
    [self.bu_4 setTitle:NSLocalizedString(@"MyCardVC_8", nil) forState:(UIControlStateNormal)];
    
    [self settingButton:self.bu_1];
    [self settingButton:self.bu_2];
    [self settingButton:self.bu_3];
    [self settingButton:self.bu_4];
}

- (void)settingButton:(UIButton *)button {
    [button sizeToFit]; // 这句代码非常重要
    
    //图片上文字下
    CGFloat imageW0 = button.imageView.frame.size.width;
    CGFloat imageH0 = button.imageView.frame.size.height;
    CGFloat titleW0 = button.titleLabel.frame.size.width;
    CGFloat titleH0 = button.titleLabel.frame.size.height;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW0, -imageH0 - 10, 0.f)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(-titleH0, 0.f, 0.f,-titleW0)];
}

@end
