//
//  RechargeView.m
//  meirong
//
//  Created by yangfeng on 2019/3/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "RechargeView.h"

@interface RechargeView () <UITextFieldDelegate> {
    CGRect oldFrame;
    CGRect newFrame;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation RechargeView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RechargeView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 264.0/667.0*height;
        oldFrame = CGRectMake(0, height, width, vi_h);
        newFrame = CGRectMake(0, height-vi_h, width, vi_h);
        self.frame = oldFrame;
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.lab_1.text = NSLocalizedString(@"ChongZhi_1", nil);
        self.lab_2.text = NSLocalizedString(@"ChongZhi_2", nil);
        self.value_1.text = NSLocalizedString(@"ChongZhi_3", nil);
        self.value_2.text = NSLocalizedString(@"ChongZhi_4", nil);
        [self.queue setTitle:NSLocalizedString(@"ChongZhi_5", nil) forState:(UIControlStateNormal)];
        self.queue.layer.masksToBounds = YES;
        self.queue.layer.cornerRadius = self.queue.frame.size.height/2.0;
        self.select_1.selected = YES;
        self.select_2.selected = NO;
        
        self.tf.delegate = self;
        [self.tf addTarget:self action:@selector(TextFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        
        self.tf.text = @"5";
        [self loadPrice];
        
        // 添加了一个 键盘即将显示时的监听，如果接收到通知，将调用 keyboardWillApprear：
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillApprear:) name:UIKeyboardWillShowNotification object:nil];
        // 添加监听， 键盘即将隐藏的时候，调用
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)loadPrice {
    CGFloat price = [self.tf.text integerValue] * 3000;
    self.price.text = [NSString stringWithFormat:@"￥ %.0f",price];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.select_1.selected = YES;
        self.select_2.selected = NO;
        self.isshow = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        [window addSubview:self.backButton];
        [window addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = newFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    });
}

- (void)hide:(BOOL)remove {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isshow = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = oldFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            if (remove) {
                [self removeFromSuperview];
                [self.backButton removeFromSuperview];
            }
        }];
    });
}

- (void)HideMethod:(UIButton *)sender {
    if (self.tf.isEditing) {
        [self.tf resignFirstResponder];
        return;
    }
    else {
        [self hide:YES];
    }
}

- (IBAction)SelectMethod_1:(UIButton *)sender {
    self.select_1.selected = YES;
    self.select_2.selected = NO;
    
}
- (IBAction)SelectMethod_2:(UIButton *)sender {
    self.select_1.selected = NO;
    self.select_2.selected = YES;
    [self.tf resignFirstResponder];
}


- (IBAction)CloseButtonMethod:(UIButton *)sender {
    [self.tf resignFirstResponder];
    [self hide:YES];
}


- (IBAction)QueueButtonMethod:(UIButton *)sender {
    [self.tf resignFirstResponder];
    if (self.select_1.isSelected) {
        if (self.index) {
            self.index(self.price.text);
        }
    }
    else if (self.select_2.isSelected) {
        if (self.index) {
            self.index(nil);
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = kColorRGB(0x21C9D9).CGColor;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] == 0) {
        textField.text = @"5";
    }
    [self loadPrice];
    textField.layer.borderColor = kColorRGB(0xCCCCCC).CGColor;
}

- (void)TextFieldValueChange:(UITextField *)textField {
    if ([[textField.text substringFromIndex:0] integerValue] == 0) {
        textField.text = @"";
    }
    else {
        [self loadPrice];
    }
}

#pragma mark - 键盘即将显示的时候调用
- (void)keyboardWillApprear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    // 间隔时间
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyboardRect = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    // 键盘高度
    CGFloat keyBoardH =  keyboardRect.size.height;
    CGRect frame = ({
        CGRect frame = newFrame;
        frame.origin.y -= keyBoardH;
        frame;
    });
    [UIView animateWithDuration:interval animations:^{
        self.frame = frame;
    }];
}

#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:interval animations:^{
        self.frame = newFrame;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.tf resignFirstResponder];
}

@end
