//
//  MyPlanScroll.m
//  meirong
//
//  Created by yangfeng on 2019/1/24.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanView_1.h"

@interface MyPlanView_1 () {
    CGFloat defaultHeight;
}
@end

@implementation MyPlanView_1

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyPlanView_1" owner:nil options:nil] firstObject];
        defaultHeight = 99 + (frame.size.width - 12 * 2 - 9) / 2.0 / 0.75;//327;
        self.frame = ({
            CGRect rect = frame;
            rect.size.height = defaultHeight;
            rect;
        });
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imv_1.layer.masksToBounds = YES;
    self.imv_1.layer.cornerRadius = 6;
    
    self.imv_2.layer.masksToBounds = YES;
    self.imv_2.layer.cornerRadius = 6;
    
    [self titleLabel:NSLocalizedString(@"MyPlanVC_2", nil)];
    [self introduceLabel:[NSString string]];
}

// 方案效果图
- (void)titleLabel:(NSString *)str {
    self.titleLab.text = str;
    self.titleLab.backgroundColor = [UIColor clearColor];
}

// 加载图片
- (void)imageView_1:(NSString *)url {
    [self.imv_1 sd_setImageWithURL:[NSURL URLWithString:url]];
}
- (void)imageView_2:(NSString *)url {
    [self.imv_2 sd_setImageWithURL:[NSURL URLWithString:url]];
}

// 方案介绍
- (void)introduceLabel:(NSString *)str {
    NSString *m_str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"MyPlanVC_5", nil),str];
    self.introduceLab.text = m_str;
    self.introduceLab.backgroundColor = [UIColor clearColor];
    // 计算高度
    CGSize size = [Tools sizeWithFont:[UIFont fontWithName:@"PingFang-SC-Medium" size: 15] maxSize:CGSizeMake(self.introduceLab.frame.size.width, MAXFLOAT) string:m_str];
    CGFloat height = 21;
    if (size.height > height) {
        height = size.height;
    }
    self.frame = ({
        CGRect rect = self.frame;
        rect.size.height = defaultHeight + height;
        rect;
    });
}



@end
