//
//  UIButton+ClickInterval.h
//  ByronMethodKit
//
//  Created by yangfeng on 2018/12/17.
//  Copyright © 2018年 yangfeng. All rights reserved.
//  设置按钮的点击间隔，防止连续点击

#import <UIKit/UIKit.h>

#define defaultInterval 1.0//默认时间间隔

@interface UIButton (ClickInterval)
@property(nonatomic,assign) NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击

@end
