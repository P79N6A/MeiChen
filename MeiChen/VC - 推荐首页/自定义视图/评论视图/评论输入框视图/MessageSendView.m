//
//  MessageSendView.m
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MessageSendView.h"

@interface MessageSendView () <UITextFieldDelegate> {
    CGRect oldFrame;
    reviewModel *currentModel;
    NSString *replayText;   // 回复的内容
    NSString *reviewText;   // 评论的内容
}
@end


@implementation MessageSendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MessageSendView" owner:nil options:nil] firstObject];
        self.frame = frame;
        oldFrame = frame;
        self.textfield.layer.masksToBounds = YES;
        self.textfield.layer.cornerRadius = 20;
        self.textfield.layer.borderWidth = 1.0;
        self.textfield.layer.borderColor = kColorRGB(0xcccccc).CGColor;
        self.textfield.keyboardType = UIKeyboardTypeDefault;

        // 添加了一个 键盘即将显示时的监听，如果接收到通知，将调用 keyboardWillApprear：
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillApprear:) name:UIKeyboardWillShowNotification object:nil];
        // 添加监听， 键盘即将隐藏的时候，调用
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 35.0 / 2.0;
    
    [self.textfield addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self showReviewPlaceholder];
}

- (void)cleanData {
    replayText = [NSString string];   // 回复的内容
    reviewText = [NSString string];   // 评论的内容
    self.textfield.text = [NSString string];
    [self.textfield resignFirstResponder];
}

- (void)showReviewPlaceholder{
    currentModel = nil;
    self.textfield.placeholder = [NSString stringWithFormat:@"%@：",NSLocalizedString(@"ReviewVC_10", nil)];
}

- (void)loadIcon:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.icon sd_setImageWithURL:url];
}

// 回复
- (void)ReplayWith:(reviewModel *)model {
    currentModel = model;
    self.textfield.placeholder = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"ReviewVC_11", nil),model.member.nickname];
    [self.textfield becomeFirstResponder];
}

// 判断是否是回复
- (BOOL)isRelay {
    // 代表评论
    if (currentModel == nil) {
        return NO;
    }
    else { // 代表回复
        return YES;
    }
}

// 输入框内容改变
- (void)textFieldEditingChanged:(UITextField *)textField {
    NSLog(@"EditingChanged = %@",textField.text);
    // 代表评论
    if (currentModel == nil) {
         reviewText = self.textfield.text;
    }
    else { // 代表回复
       replayText = self.textfield.text;
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
    
    // 代表评论
    if (currentModel == nil) {
        self.textfield.text = reviewText;
    }
    else { // 代表回复
        self.textfield.text = replayText;
    }
    
    // 对 tableView  执行动画，向上平移
    [UIView animateWithDuration:interval animations:^{
        self.frame = ({
            CGRect frame = oldFrame;
            frame.origin.y -= keyBoardH;
            frame;
        });
    }];
}


#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    self.textfield.text = [NSString string];
    [self showReviewPlaceholder];
    
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:interval animations:^{
        self.frame = oldFrame;
    }];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textfield resignFirstResponder];
    [self endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
