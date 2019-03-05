//
//  PhotosNavView.m
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosNavView.h"

@implementation PhotosNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PhotosNavView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.frame = CGRectMake(0, 0, statusRect.size.width, statusRect.size.height + 44);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.leftItem setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftItem setTitle:nil forState:UIControlStateNormal];
}

// 所有照片的导航栏
- (void)SetNav_1 {
    [self.titleItem setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    [self.titleItem setImage:[UIImage imageNamed:@"收起2"] forState:UIControlStateSelected];
    [self.titleItem setTitle:NSLocalizedString(@"Photos_1", nil) forState:UIControlStateNormal];
    [self.titleItem setTitle:NSLocalizedString(@"Photos_1", nil) forState:UIControlStateSelected];
    
    self.titleItem.tintColor = [UIColor clearColor];
    [self.titleItem sizeToFit]; // 这句代码非常重要
    
    //图片右文字左
    CGFloat imageW0 = self.titleItem.imageView.frame.size.width;
    CGFloat titleW0 = self.titleItem.titleLabel.frame.size.width;
    [self.titleItem setImageEdgeInsets:UIEdgeInsetsMake(0, titleW0, 0.f,-titleW0)];
    [self.titleItem setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW0, 0, imageW0)];// 上 左 下 右
}

- (void)SetNav_2:(NSString *)title {
     [self.titleItem setTitle:title forState:UIControlStateNormal];
}

- (IBAction)LeftItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotosNavView_LeftItem:)]) {
        [self.delegate PhotosNavView_LeftItem:sender];
    }
}

- (IBAction)TitleItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotosNavView_TitleItem:)]) {
        [self.delegate PhotosNavView_TitleItem:sender];
    }
}


@end
