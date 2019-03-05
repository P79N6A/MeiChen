//
//  DemandView.m
//  meirong
//
//  Created by yangfeng on 2019/1/19.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "DemandView.h"

@interface DemandView () <UITextViewDelegate>

@end

@implementation DemandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DemandView" owner:nil options:nil] firstObject];
        self.titleLab.text = NSLocalizedString(@"UploadImageVC_4", nil);
        self.textView.delegate = self;
        [self defaultTextView];
    }
    return self;
}

- (NSString *)defaultString {
    return NSLocalizedString(@"UploadImageVC_5", nil);
}

- (void)defaultTextView {
    self.textView.text = [self defaultString];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:[self defaultString]]) {
        self.textView.text = [NSString string];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length <= 0) {
        [self defaultTextView];
    }
}

@end
