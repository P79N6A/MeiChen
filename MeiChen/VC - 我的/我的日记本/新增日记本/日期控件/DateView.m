//
//  DateView.m
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "DateView.h"

@interface DateView () {
    CGRect oldFrame;
    CGRect newFrame;
    NSString *string;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation DateView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DateView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 230;
        oldFrame = CGRectMake(0, height, width, vi_h);
        newFrame = CGRectMake(0, height-vi_h, width, vi_h);
        self.frame = oldFrame;
        [self.cancel setTitle:NSLocalizedString(@"MyDiaryVC_15", nil) forState:(UIControlStateNormal)];
        [self.queue setTitle:NSLocalizedString(@"MyDiaryVC_16", nil) forState:(UIControlStateNormal)];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.datepicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

#pragma mark - 设置初始时间
- (void)SettingDefaultTime:(NSString *)str {
    if (str != nil) {
        string = str;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置时间格式
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:str];
        if (date != nil) {
            [self.datepicker setDate:date];
        }
    }
}

#pragma mark - 手术时间改变
- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    string = [formatter  stringFromDate:datePicker.date];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    [window addSubview:self.backButton];
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = newFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = oldFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backButton removeFromSuperview];
    }];
}

- (IBAction)CancelMethod:(UIButton *)sender {
    [self hide];
}

- (IBAction)QueueMethod:(UIButton *)sender {
    if (self.blockStr != nil) {
        self.blockStr(string);
    }
    [self hide];
}

- (void)HideMethod:(UIButton *)sender {
    [self hide];
}



@end
