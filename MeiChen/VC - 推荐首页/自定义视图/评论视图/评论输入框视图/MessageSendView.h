//
//  MessageSendView.h
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSendView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UIButton *send;

- (void)loadIcon:(NSString *)urlStr;

// 回复
- (void)ReplayWith:(reviewModel *)model;

// 判断是否是回复
- (BOOL)isRelay;

- (void)cleanData;

@end
