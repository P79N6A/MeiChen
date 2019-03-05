//
//  ProView.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ProView.h"

@interface ProView ()
@property (nonatomic, strong) UIView *prov;
@end

@implementation ProView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ProView" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        self.view_1.layer.masksToBounds = YES;
        self.view_1.layer.cornerRadius = 5.0;
        
        self.view_2.layer.masksToBounds = YES;
        self.view_2.layer.cornerRadius = 5.0;
        
        self.childView_1.layer.masksToBounds = YES;
        self.childView_1.layer.cornerRadius = 3.0;
        
        self.childView_2.layer.masksToBounds = YES;
        self.childView_2.layer.cornerRadius = 3.0;
        
        self.progress.layer.cornerRadius = 2.5;
        self.progress.layer.masksToBounds = YES;
        
        self.prov = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.progress.frame.size.width, self.progress.frame.size.height)];
        self.prov.backgroundColor = kColorRGB(0x418DD9);
        self.prov.layer.cornerRadius = 2.5;
        self.prov.layer.masksToBounds = YES;
        [self.progress addSubview:self.prov];
    }
    return self;
}

- (void)settingProgressValue:(CGFloat)value {
    CGFloat p = 0;
    if (value<=10) {
        self.lab_1.text = @"P1";
        self.lab_2.text = @"P2";
        self.value_1.text = @"1";
        self.value_2.text = @"10";
        p = value/10.0;
    }
    else if (value>10&&value<=100) {
        self.lab_1.text = @"P2";
        self.lab_2.text = @"P3";
        self.value_1.text = @"10";
        self.value_2.text = @"100";
        p = (value-10.0)/(100.0-10.0);
    }
    else if (value>100&&value<=500) {
        self.lab_1.text = @"P3";
        self.lab_2.text = @"P4";
        self.value_1.text = @"100";
        self.value_2.text = @"500";
        p = (value-100.0)/(500.0-100.0);
    }
    if (p>8.0/self.progress.frame.size.width) {
        self.view_1.backgroundColor = kColorRGB(0x418DD9);
    }
    if (p>(self.progress.frame.size.width-8.0)/self.progress.frame.size.width) {
        self.view_2.backgroundColor = kColorRGB(0x418DD9);
    }
    NSLog(@"p = %f",p);
    CGFloat width = [UIScreen mainScreen].bounds.size.width-12*2;
    self.prov.frame = CGRectMake(0, 0, width*p, self.prov.frame.size.height);
    NSLog(@"progress = %@",NSStringFromCGRect(self.progress.frame));
    NSLog(@"progress = %@",NSStringFromCGRect(self.prov.frame));
    NSLog(@"width = %f",width);
}





@end
