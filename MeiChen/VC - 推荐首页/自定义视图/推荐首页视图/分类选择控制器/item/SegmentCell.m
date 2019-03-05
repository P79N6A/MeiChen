//
//  SegmentCell.m
//  meirong
//
//  Created by yangfeng on 2018/12/17.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "SegmentCell.h"

@implementation SegmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)colorLayer:(UIView *)view {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame =self.titleLab.frame;
    [layer setColors:@[(id)kColorRGB(0x25E6E6).CGColor, (id)kColorRGB(0x23A7C2).CGColor]];
    [self.bgView.layer addSublayer:layer];
    //颜色上下渐变
    [layer setStartPoint:CGPointMake(0, 0)];
    [layer setEndPoint:CGPointMake(1, 1)];
    layer.mask=self.titleLab.layer;
    self.titleLab.frame=layer.bounds;
}



//- (void)colorLayerWithText:(NSString *)text font:(UIFont *)font is:(BOOL)is {
//    
//    NSLog(@"view = %@",self.bgView.subviews);
//    
//    for (UILabel *vi in self.bgView.subviews) {
//        [vi removeFromSuperview];
//    }
//    
//    self.lab=[[UILabel alloc]initWithFrame:self.bgView.frame];
//    self.lab.text=text;
//    self.lab.font=font;
//    [self.bgView addSubview:self.lab];
//    
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    layer.frame =self.lab.frame;
//    if (is) {
//        [layer setColors:@[(id)kColorRGB(0x25E6E6).CGColor, (id)kColorRGB(0x23A7C2).CGColor]];
////        self.bgView.hidden = YES;
//    }
//    else {
//        [layer setColors:@[(id)[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0].CGColor]];
////        self.bgView.hidden = NO;
//    }
//
//    [self.bgView.layer addSublayer:layer];
//    
//    //颜色上下渐变
//    [layer setStartPoint:CGPointMake(0, 0)];
//    [layer setEndPoint:CGPointMake(1, 1)];
//
//    //一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
//    layer.mask=self.lab.layer;
//
//    // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
//    self.lab.frame=layer.bounds;
//    
//    NSLog(@"lab = %@",self.lab.superview);
//}



@end
