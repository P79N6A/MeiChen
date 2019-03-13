//
//  YuYueSurgeryView.m
//  meirong
//
//  Created by yangfeng on 2019/3/13.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "YuYueSurgeryView.h"

@implementation YuYueSurgeryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YuYueSurgeryView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.Lab.text = @"";
    self.lab_1.text = NSLocalizedString(@"YuYueSurgery_2", nil);
    self.lab_2.text = NSLocalizedString(@"YuYueSurgery_3", nil);
    self.lab_3.text = NSLocalizedString(@"YuYueSurgery_4", nil);
    self.message.text = NSLocalizedString(@"YuYueSurgery_5", nil);
    
    [self.more setTitle:NSLocalizedString(@"YuYueSurgery_7", nil) forState:(UIControlStateNormal)];
    [self.bu_1 setTitle:NSLocalizedString(@"YuYueSurgery_8", nil) forState:(UIControlStateNormal)];
    [self.bu_2 setTitle:NSLocalizedString(@"YuYueSurgery_9", nil) forState:(UIControlStateNormal)];
    [self.queue setTitle:NSLocalizedString(@"YuYueSurgery_6", nil) forState:(UIControlStateNormal)];
    self.bu_1.selected = NO;
    self.bu_2.selected = NO;
    self.bu_1.layer.masksToBounds = YES;
    self.bu_1.layer.cornerRadius = 2.0;
    self.bu_2.layer.masksToBounds = YES;
    self.bu_2.layer.cornerRadius = 2.0;
    
    [self.bu_1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [self.bu_1 setTitleColor:kColorRGB(0x333333) forState:(UIControlStateNormal)];
    
    [self.bu_2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [self.bu_2 setTitleColor:kColorRGB(0x333333) forState:(UIControlStateNormal)];
    
    [self.bu_1 setTintColor:[UIColor clearColor]];
    [self.bu_2 setTintColor:[UIColor clearColor]];
    
    [self NotSelectButton:self.bu_1];
    [self NotSelectButton:self.bu_2];
}

- (void)SelectButton:(UIButton *)sender {
    sender.backgroundColor = kColorRGB(0x5CDAE6);
    sender.layer.borderWidth = 1.0;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)NotSelectButton:(UIButton *)sender{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.borderWidth = 1.0;
    sender.layer.borderColor = kColorRGB(0xE6E6E6).CGColor;
}


- (IBAction)BUttonMethod_1:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self SelectButton:self.bu_1];
    }
    else {
        [self NotSelectButton:self.bu_1];
    }
}

- (IBAction)BUttonMethod_2:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self SelectButton:self.bu_2];
    }
    else {
        [self NotSelectButton:self.bu_2];
    }
}



@end
