//
//  FloatWindows.h
//  meirong
//
//  Created by yangfeng on 2019/1/29.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatWindows : UIWindow

+ (instancetype)shareInstance;

#pragma mark - 判断是否弹出浮窗
- (void)CanShowFloatingWindows;

// 显示（默认）
- (void)showWindow;

// 隐藏
- (void)dissmissWindow;

@end
