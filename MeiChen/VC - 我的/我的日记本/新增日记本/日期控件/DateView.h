//
//  DateView.h
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockDate)(NSString *dateStr);
@interface DateView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *queue;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (copy, nonatomic) blockDate blockStr;
#pragma mark - 设置初始时间
- (void)SettingDefaultTime:(NSString *)str;
- (void)show;
@end
