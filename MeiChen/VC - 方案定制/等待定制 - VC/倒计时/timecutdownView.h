//
//  timecutdownView.h
//  meirong
//
//  Created by yangfeng on 2019/1/23.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timecutdownView : UIView

#pragma mark - 圆环进度(带渐变的)
- (void)circleProgressView;

#pragma mark - 设置进度,自动转圈圈
- (void)AutoCircleWithStartTime:(NSInteger)startTime gapTime:(NSInteger)gapTime;

@end
