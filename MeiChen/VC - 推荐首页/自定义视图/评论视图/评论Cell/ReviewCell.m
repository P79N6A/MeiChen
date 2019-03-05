//
//  ReviewCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ReviewCell.h"
#import "ReviewData.h"

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.message.hidden = YES;
    
    self.line1.hidden = YES;
    self.line2.hidden = NO;
    
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 4.0;
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 43.0 / 2.0;
}

- (void)loadDataWith:(reviewModel *)model louzhuid:(NSString *)louzhuid {
    if (![model isMemberOfClass:[reviewModel class]]) {
        return;
    }
    [self loadIcon:model.member.avatar];
    [self loadName:model.member.nickname];
    [self judgeMessage:model.sub];
    [self loadTime:model.create_at];
    [self loadContext:model.content];
    [self loadRevert:model.sub];
    
    if ([louzhuid isEqualToString:[UserData shareInstance].user.member_id]) {
        NSLog(@"是楼主");
        self.message.hidden = NO;
    }
    else {
        NSLog(@"不是楼主");
        self.message.hidden = YES;
    }
}

- (void)loadIcon:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.icon sd_setImageWithURL:url];
}

- (void)loadName:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    self.name.text = text;
    self.name.backgroundColor = [UIColor clearColor];
}

- (void)judgeMessage:(revertModel *)model {
    if (model == nil) {
        [self ShowSomeCon:NO];
    }
    else {
        [self ShowSomeCon:YES];
    }
}

- (void)ShowSomeCon:(BOOL)show {
    self.line1.hidden = show;
    
    self.triangle.hidden = !show;
    self.backview.hidden = !show;
    self.line2.hidden = !show;
}

- (void)loadTime:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[text integerValue]];
    NSString *str = [formatter stringFromDate:date];
    self.time.text = str;
    self.time.backgroundColor = [UIColor clearColor];
}

- (void)loadContext:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    self.review.text = text;
    self.review.backgroundColor = [UIColor clearColor];
}

- (void)loadRevert:(revertModel *)model {
    if (model == nil) {
        return;
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger gapTime = now - [model.create_at integerValue];
    if (gapTime < 0) {
        return;
    }
    
    ReviewData *data = [[ReviewData alloc]init];
    self.revert.attributedText = [data AttributedStringWithModel:model];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
