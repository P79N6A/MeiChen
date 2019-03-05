//
//  CustomNavView.m
//  
//
//  Created by yangfeng on 2019/1/14.
//

#import "CustomNavView.h"

@interface CustomNavView ()

@end

@implementation CustomNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomNavView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.frame = CGRectMake(0, 0, statusRect.size.width, statusRect.size.height + 44);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.hidden = YES;
}


- (IBAction)LeftItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomNavView_LeftItem:)]) {
        [self.delegate CustomNavView_LeftItem:sender];
    }
}

- (IBAction)RightItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomNavView_RightItem:)]) {
        [self.delegate CustomNavView_RightItem:sender];
    }
}

// 左侧返回按钮
- (void)LeftItemIsBack {
    [self.leftItem setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftItem setTitle:nil forState:UIControlStateNormal];
}

// 左侧白色返回按钮
- (void)LeftItemIsWhiteBack {
    [self.leftItem setImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
    [self.leftItem setTitle:nil forState:UIControlStateNormal];
}

// 右侧上传按钮
- (void)RightItemIsUpload:(NSInteger)index {
    if (index == 0) {
        [self.rightItem setTitle:NSLocalizedString(@"PlanCustomizeVC_1", nil) forState:UIControlStateNormal];
    } else {
        [self.rightItem setTitle:[NSString stringWithFormat:@"%@%ld/%d",NSLocalizedString(@"PlanCustomizeVC_1", nil),index,9] forState:UIControlStateNormal];
    }
    [self.rightItem setTitleColor:kColorRGB(0x21C9D9) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}

// 右侧跳过按钮
- (void)RightItemIsSkip {
    [self.rightItem setTitle:NSLocalizedString(@"UploadImageVC_2", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x999999) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}

// 右侧兑换
- (void)RightItemIsExchange {
    [self.rightItem setTitle:NSLocalizedString(@"MyCardVC_1", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}

// 右侧发布
- (void)RightItemIsRelease {
    [self.rightItem setTitle:NSLocalizedString(@"MyDiaryVC_6", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x666666) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}


// 右侧确定
- (void)RightItemIsQueue {
    [self.rightItem setTitle:NSLocalizedString(@"MyDiaryVC_19", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x333333) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}


// 右侧积分
- (void)RightItemIsJiFen {
    [self.rightItem setTitle:NSLocalizedString(@"MyShareVC_9", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x666666) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}

// 右侧 引荐管理 兑换
- (void)RightItemIsDuiHuan {
    [self.rightItem setTitle:NSLocalizedString(@"ExchangeVC_2", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x666666) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}

// 右侧记录
- (void)RightItemIsRecord {
    [self.rightItem setTitle:NSLocalizedString(@"ExchangeJiFenVC_2", nil) forState:UIControlStateNormal];
    [self.rightItem setTitleColor:kColorRGB(0x666666) forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
}



@end
