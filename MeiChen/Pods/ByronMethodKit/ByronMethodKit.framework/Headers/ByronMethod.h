//
//  ByronMethod.h
//  ByronMethodKit
//
//  Created by 杨峰 on 2018/12/17.
//  Copyright © 2018年 杨峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByronMethod : NSObject

/**
 倒计时
 @param timeLine 倒计时时间
 */
- (void)countDownWithTime:(NSInteger)timeLine
        countDownUnderway:(void(^)(NSInteger restCountDownNum))countDownUnderway
      countDownCompletion:(void (^)(void))countDownCompletion;

- (void)cancelTimer;

// 普通的获取UUID的方法
+ (NSString *)getUUID;

@end
