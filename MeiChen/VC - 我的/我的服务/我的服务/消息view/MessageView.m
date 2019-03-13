//
//  MessageView.m
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MessageView.h"

@interface MessageView () {
    CGRect hideFrame;
    CGRect showFrame;
}
@end

@implementation MessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2.0;
        self.backgroundColor = [UIColor clearColor];
        
        self.lab_1.text = NSLocalizedString(@"ServersVC_15", nil);
        self.lab_2.text = NSLocalizedString(@"ServersVC_16", nil);
    }
    return self;
}

@end
