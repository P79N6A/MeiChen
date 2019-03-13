//
//  ServersItem.m
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServersItem.h"

@implementation ServersItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ServersItem" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12;
    
    self.icon.layer.shadowColor = [UIColor blackColor].CGColor;
    self.icon.layer.shadowOpacity = 0.3;
    self.icon.layer.shadowOffset = CGSizeMake(0,0);
    self.icon.layer.shadowRadius = 2;
    self.icon.clipsToBounds = NO;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 7.0;
    self.icon.backgroundColor = kColorRGB(0xf0f0f0);
    
    self.icon2.hidden = YES;
    
    self.butt.layer.masksToBounds = YES;
    self.butt.layer.borderWidth = 2;
    self.butt.layer.borderColor = kColorRGB(0xcccccc).CGColor;
    self.butt.layer.cornerRadius = self.butt.frame.size.height/2.0;
}

- (void)loadData:(FicheModel *)model {
    NSDictionary *colorDic = @{@"diagnose":kColorRGB(0x8AE599),
                               @"surgery":kColorRGB(0x4CC3FF),
                               @"change_drug":kColorRGB(0xF0D860),
                               @"review":kColorRGB(0xAA99FF),
                               @"stitch":kColorRGB(0xFFB2F2),
                               };
    UIColor *color = colorDic[model.name];
    
    [self.icon setImage:[UIImage imageNamed:model.name] forState:(UIControlStateNormal)];
    if (color != nil) {
        self.icon.backgroundColor = color;
    }
    self.name.text = model.title;
    self.time.text = model.date;
    self.price.text = model.points;
    if (model.is_points_get == 1) {
        self.icon2.hidden = NO;
    }
    else {
        self.icon2.hidden = YES;
    }
    
    UIColor *defColor = kColorRGB(0xB3B3B3);
    [self.butt setTitle:model.process forState:(UIControlStateNormal)];
    [self.butt setTitleColor:defColor forState:(UIControlStateNormal)];
    self.butt.layer.borderColor = defColor.CGColor;
    
    if (model.is_do_action == 1) {
        self.butt.enabled = YES;
        UIColor *color = colorDic[model.name];
        if (color != nil) {
            [self.butt setTitleColor:color forState:(UIControlStateNormal)];
            self.butt.layer.borderColor = color.CGColor;
        }
    }
    else {
        self.butt.enabled = NO;
    }
}

- (IBAction)ButtonMethod:(UIButton *)sender {
    
    NSLog(@"buttonnnn");
    
}



@end
