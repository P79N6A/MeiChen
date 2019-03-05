//
//  CaseMiddleView.m
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CaseMiddleView.h"

@interface CaseMiddleView () {
    CaseDetailModel *currentModel;
    ShowIcon *showicon;
}
@end

@implementation CaseMiddleView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CaseMiddleView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    showicon = [[ShowIcon alloc]init];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.width / 2.0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconMethod)];
    self.icon.userInteractionEnabled = YES;
    [self.icon addGestureRecognizer:tapGesture];
    
    self.cardButton.layer.masksToBounds = YES;
    self.cardButton.layer.cornerRadius = self.cardButton.frame.size.height / 2.0;
    self.cardButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    self.bu_1.layer.masksToBounds = YES;
    self.bu_1.layer.cornerRadius = self.bu_1.frame.size.height / 2.0;
    self.bu_1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    self.bu_2.layer.masksToBounds = YES;
    self.bu_2.layer.cornerRadius = self.bu_2.frame.size.height / 2.0;
    self.bu_2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    
    self.projectName.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"CaseDetailVC_2", nil)];
    self.beautifulTime.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"CaseDetailVC_3", nil)];
    self.beforeMe.text = NSLocalizedString(@"CaseDetailVC_4", nil);
    self.beautifulProcess.text = NSLocalizedString(@"CaseDetailVC_5", nil);
    
    [self.sortingButton setTitle:NSLocalizedString(@"CaseDetailVC_6", nil) forState:UIControlStateNormal];
    [self.sortingButton setImage:[UIImage imageNamed:@"箭头-下"] forState:UIControlStateNormal];
    
    [self.sortingButton setTitle:NSLocalizedString(@"CaseDetailVC_7", nil) forState:UIControlStateSelected];
    [self.sortingButton setImage:[UIImage imageNamed:@"箭头-上"] forState:UIControlStateSelected];
    
    self.sortingButton.selected = NO;
    
    self.imv_1.layer.masksToBounds = YES;
    self.imv_2.layer.masksToBounds = YES;
    self.imv_3.layer.masksToBounds = YES;
    
    self.imv_1.layer.cornerRadius = 6;
    self.imv_2.layer.cornerRadius = 6;
    self.imv_3.layer.cornerRadius = 6;
    
    UITapGestureRecognizer *tapGesture_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_1)];
    UITapGestureRecognizer *tapGesture_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_2)];
    UITapGestureRecognizer *tapGesture_3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_3)];
    
    self.imv_1.userInteractionEnabled = YES;
    [self.imv_1 addGestureRecognizer:tapGesture_1];
    
    self.imv_2.userInteractionEnabled = YES;
    [self.imv_2 addGestureRecognizer:tapGesture_2];
    
    self.imv_3.userInteractionEnabled = YES;
    [self.imv_3 addGestureRecognizer:tapGesture_3];
}

- (void)IconMethod {
    [showicon ShowIconImageFromImv:self.icon];
}

// 加载头像
- (void)loadIconWithUrl:(NSString *)url {
    if (url.length <= 0) {
        return;
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url]];
}

// 显示名称
- (void)loadName_p:(NSString *)name {
    if (name.length <= 0) {
        return;
    }
    self.name_p.text = name;
    self.name_p.backgroundColor = [UIColor clearColor];
}

// 设置会员等级
- (void)loadCarLevel:(cardModel *)model {
    [self.cardButton setTitle:model.title forState:UIControlStateNormal];
}

// 设置标签
- (void)loadTagArray:(NSArray *)array {
    self.bu_1.hidden = YES;
    self.bu_2.hidden = YES;
    if (array.count >= 1) {
        if ([[array firstObject] isKindOfClass:[tagModel class]]) {
            tagModel *model = [array firstObject];
            [self.bu_1 setTitle:model.tag_name forState:UIControlStateNormal];
            self.bu_1.hidden = NO;
        }
    }
    if (array.count >= 2) {
        if ([array[1] isKindOfClass:[tagModel class]]) {
            tagModel *model = [array objectAtIndex:1];
            [self.bu_2 setTitle:model.tag_name forState:UIControlStateNormal];
            self.bu_2.hidden = NO;
        }
    }
}

- (void)ImageViewMethod_1 {
    [[imageBrowser shareInstance] showImagesWith:currentModel.pre_imgs index:0];
}
- (void)ImageViewMethod_2 {
    [[imageBrowser shareInstance] showImagesWith:currentModel.pre_imgs index:1];
}
- (void)ImageViewMethod_3 {
    [[imageBrowser shareInstance] showImagesWith:currentModel.pre_imgs index:2];
}

- (void)loadModel:(CaseDetailModel *)model {
    currentModel = model;
    // 更新头像
    [self loadIconWithUrl:model.member.avatar];
    // 更新名称
    [self loadName_p:model.member.nickname];
    // 更新会员等级
    [self loadCarLevel:model.card];
    // 更新标签
    [self loadTagArray:model.tag];
    
    // 更新名称
    [self loadName:model.item];
    // 更新变美时间
    [self loadTime:model.fix_at];
    // 更新以前的图片
    [self loadImages:model.pre_imgs];
}

// 加载项目名称
- (void)loadName:(NSArray *)array {
    NSMutableString *m_str = [NSMutableString string];
    for (int i = 0; i < array.count; i ++) {
        if ([array[i] isKindOfClass:[itemModel class]]) {
            itemModel *model = array[i];
            if (m_str.length > 0) {
                [m_str appendString:@"、"];
            }
            [m_str appendString:model.item_name];
        }
    }
    self.name.text = m_str;
    self.name.backgroundColor = [UIColor clearColor];
}

// 加载变美时间
- (void)loadTime:(NSString *)time {
    if (time.length <= 0) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd%@",NSLocalizedString(@"CaseDetailVC_8", nil),NSLocalizedString(@"CaseDetailVC_9", nil),NSLocalizedString(@"CaseDetailVC_10", nil)]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    if (date) {
        self.time.text = [formatter stringFromDate:date];
        self.time.backgroundColor = [UIColor clearColor];
    }
}

// 加载图片
- (void)loadImages:(NSArray *)array {
    
    self.imv_1.hidden = YES;
    self.imv_2.hidden = YES;
    self.imv_3.hidden = YES;
    
    if (array.count >= 1) {
        [self.imv_1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        self.imv_1.hidden = NO;
    }
    
    if (array.count >= 2) {
        [self.imv_2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
        self.imv_2.hidden = NO;
    }
    
    if (array.count >= 3) {
        [self.imv_3 sd_setImageWithURL:[NSURL URLWithString:array[2]]];
        self.imv_3.hidden = NO;
    }
}

// 时间倒序排列
- (IBAction)sortingButtonMethod:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sortingButton.selected = !sender.selected;
    });
    if (self.sorting != nil) {
        self.sorting();
    }
}


@end
