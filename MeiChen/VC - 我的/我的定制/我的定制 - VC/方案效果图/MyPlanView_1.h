//
//  MyPlanScroll.h
//  meirong
//
//  Created by yangfeng on 2019/1/24.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanView_1 : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *imv_1;

@property (weak, nonatomic) IBOutlet UIImageView *imv_2;

@property (weak, nonatomic) IBOutlet UILabel *introduceLab;


// 方案效果图
- (void)titleLabel:(NSString *)str;

// 加载图片
- (void)imageView_1:(NSString *)url;
- (void)imageView_2:(NSString *)url;

// 方案介绍
- (void)introduceLabel:(NSString *)str;

@end
