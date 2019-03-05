//
//  CaseDetailCell.m
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CaseDetailCell.h"

@interface CaseDetailCell () {
    DailyModel *modells;
    NSIndexPath *CurrentPath;
}

@end


@implementation CaseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imv_4.hidden = YES;
    self.imv_5.hidden = YES;
    self.imv_6.hidden = YES;
    
    self.line_2.hidden = YES;
    
    self.imv_1.layer.masksToBounds = YES;
    self.imv_1.layer.cornerRadius = 5.0;
    
    self.imv_2.layer.masksToBounds = YES;
    self.imv_2.layer.cornerRadius = 5.0;
    
    self.imv_3.layer.masksToBounds = YES;
    self.imv_3.layer.cornerRadius = 5.0;
    
    self.imv_4.layer.masksToBounds = YES;
    self.imv_4.layer.cornerRadius = 5.0;
    
    self.imv_5.layer.masksToBounds = YES;
    self.imv_5.layer.cornerRadius = 5.0;
    
    self.imv_6.layer.masksToBounds = YES;
    self.imv_6.layer.cornerRadius = 5.0;
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 2.0;
    
    UITapGestureRecognizer *tapGesture_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_1)];
    UITapGestureRecognizer *tapGesture_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_2)];
    UITapGestureRecognizer *tapGesture_3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_3)];
    UITapGestureRecognizer *tapGesture_4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_4)];
    UITapGestureRecognizer *tapGesture_5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_5)];
    UITapGestureRecognizer *tapGesture_6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewMethod_6)];
    
    self.imv_1.userInteractionEnabled = YES;
    [self.imv_1 addGestureRecognizer:tapGesture_1];
    
    self.imv_2.userInteractionEnabled = YES;
    [self.imv_2 addGestureRecognizer:tapGesture_2];
    
    self.imv_3.userInteractionEnabled = YES;
    [self.imv_3 addGestureRecognizer:tapGesture_3];
    
    self.imv_4.userInteractionEnabled = YES;
    [self.imv_4 addGestureRecognizer:tapGesture_4];
    
    self.imv_5.userInteractionEnabled = YES;
    [self.imv_5 addGestureRecognizer:tapGesture_5];
    
    self.imv_6.userInteractionEnabled = YES;
    [self.imv_6 addGestureRecognizer:tapGesture_6];
    
    [self.bu_2 setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    [self.bu_2 setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateSelected];
    [self.bu_2 setTitleColor:kColorRGB(0x999999) forState:UIControlStateNormal];
    [self.bu_2 setTitleColor:kColorRGB(0x999999) forState:UIControlStateSelected];
}

- (IBAction)ButtonMethod_1:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CaseDetailCellDidSelectMessageIndexPath:)]) {
        [self.delegate CaseDetailCellDidSelectMessageIndexPath:CurrentPath];
    }
}

- (IBAction)ButtonMethod_2:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CaseDetailCellDidSelectZan:indexPath:)]) {
        [self.delegate CaseDetailCellDidSelectZan:sender indexPath:CurrentPath];
    }
}

- (void)ImageViewMethod_1 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:0];
}
- (void)ImageViewMethod_2 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:1];
}
- (void)ImageViewMethod_3 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:2];
}
- (void)ImageViewMethod_4 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:3];
}
- (void)ImageViewMethod_5 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:4];
}
- (void)ImageViewMethod_6 {
    [[imageBrowser shareInstance] showImagesWith:modells.photos index:5];
}

- (void)loadDataWithModel:(DailyModel *)model indexPath:(NSIndexPath *)indexPath {
    modells = model;
    
    self.bu_1.tag = indexPath.row;
    self.bu_2.tag = indexPath.row;
    CurrentPath = indexPath;
    
    [self loadTime_1:model.photo_at];
    [self loadTitle_1:model.title];
    [self loadTitle_2:model.brief];
    [self SetImageViewsLocation:model.photos.count];
    [self loadImageViews:model.photos];
    [self loadLab_1:model.view_num];
    [self loadBu_1:model.comment_num];
    [self loadBu_2:model.like_num like:model.has_like];
}

- (void)loadTime_1:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd%@",NSLocalizedString(@"CaseDetailVC_9", nil),NSLocalizedString(@"CaseDetailVC_10", nil)]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[text integerValue]];
    if (date) {
        self.time_1.text = [formatter stringFromDate:date];
        self.time_1.backgroundColor = [UIColor clearColor];
    }
}

- (void)loadTime_2:(NSInteger)index {
    NSString *str = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"CaseDetailVC_12", nil),index,NSLocalizedString(@"CaseDetailVC_13", nil)];
    self.time_2.text = str;
    self.time_2.backgroundColor = [UIColor clearColor];
}

- (void)loadTitle_1:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    self.title_1.text = text;
    self.title_1.backgroundColor = [UIColor clearColor];
}

- (void)loadTitle_2:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    self.title_2.text = text;
    self.title_2.backgroundColor = [UIColor clearColor];
}

- (void)loadImageViews:(NSArray *)array {
    self.ImagesView.backgroundColor = [UIColor clearColor];
    if (array.count >= 1) {
        [self.imv_1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
    }
    if (array.count >= 2) {
        [self.imv_2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
    }
    if (array.count >= 3) {
        [self.imv_3 sd_setImageWithURL:[NSURL URLWithString:array[2]]];
    }
    if (array.count >= 4) {
        [self.imv_4 sd_setImageWithURL:[NSURL URLWithString:array[3]]];
    }
    if (array.count >= 5) {
        [self.imv_5 sd_setImageWithURL:[NSURL URLWithString:array[4]]];
    }
    if (array.count >= 6) {
        [self.imv_6 sd_setImageWithURL:[NSURL URLWithString:array[5]]];
    }
}

- (void)loadLab_1:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",text,NSLocalizedString(@"CaseDetailVC_11", nil)];
    self.lab_1.text = str;
    self.lab_1.backgroundColor = [UIColor clearColor];
}

- (void)loadBu_1:(NSString *)text {
    if (text.length <= 0) {
        return;
    }
    [self.bu_1 setTitle:[NSString stringWithFormat:@" %@",text] forState:UIControlStateNormal];
    [self.bu_1 setImage:[UIImage imageNamed:@"回复"] forState:UIControlStateNormal];
    [self.bu_1 setBackgroundColor:[UIColor clearColor]];
}


- (void)loadBu_2:(NSString *)text like:(NSInteger)like {
    if (text.length <= 0) {
        return;
    }
    if ([text integerValue] > 10000) {
        NSInteger k = [text integerValue] / 10000;
        [self.bu_2 setTitle:[NSString stringWithFormat:@" %ld%@",k,NSLocalizedString(@"tuijian_2", nil)] forState:UIControlStateNormal];
    }
    else {
        [self.bu_2 setTitle:[NSString stringWithFormat:@" %@",text] forState:UIControlStateNormal];
    }
    if (like == 0) {
        self.bu_2.selected = NO;
    }
    else {
        self.bu_2.selected = YES;
    }
    [self.bu_2 setBackgroundColor:[UIColor clearColor]];
}

- (void)SetImageViewsLocation:(NSInteger)number {
    //
    CGFloat gap = 5;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 80;//self.ImagesView.frame.size.width;
    
    if (number <= 3) {
        CGFloat y_1 = (width - 2.0 * gap) / 3.0;
        CGFloat x_1 = 2.0 * y_1 + gap;
        
        self.imv_1.frame = CGRectMake(0, 0, x_1, x_1);
        self.imv_2.frame = CGRectMake(x_1 + gap, 0, y_1, y_1);
        self.imv_3.frame = CGRectMake(x_1 + gap, y_1 + gap, y_1, y_1);
    }
    else if (number == 4) {
        CGFloat x_1 = (width - gap) / 2.0;
        self.imv_1.frame = CGRectMake(0, 0, x_1, x_1);
        self.imv_2.frame = CGRectMake(x_1 + gap, 0, x_1, x_1);
        self.imv_3.frame = CGRectMake(0, x_1 + gap, x_1, x_1);
        self.imv_4.frame = CGRectMake(x_1 + gap, x_1 + gap, x_1, x_1);
        
        self.imv_4.hidden = NO;
    }
    else if (number == 5) {
        CGFloat y_1 = (width - 2.0 * gap) / 3.0;
        CGFloat x_1 = 2.0 * y_1 + gap;
        CGFloat y_2 = (width - gap) / 2.0;
        self.imv_1.frame = CGRectMake(0, 0, x_1, x_1);
        self.imv_2.frame = CGRectMake(x_1 + gap, 0, y_1, y_1);
        self.imv_3.frame = CGRectMake(x_1 + gap, y_1 + gap, y_1, y_1);
        self.imv_4.frame = CGRectMake(0, x_1 + gap, y_2, y_2);
        self.imv_5.frame = CGRectMake(y_2 + gap, x_1 + gap, y_2, y_2);
        
        self.imv_4.hidden = NO;
        self.imv_5.hidden = NO;
    }
    else {
        CGFloat y_1 = (width - 2.0 * gap) / 3.0;
        CGFloat x_1 = 2.0 * y_1 + gap;
        self.imv_1.frame = CGRectMake(0, 0, x_1, x_1);
        self.imv_2.frame = CGRectMake(x_1 + gap, 0, y_1, y_1);
        self.imv_3.frame = CGRectMake(x_1 + gap, y_1 + gap, y_1, y_1);
        self.imv_4.frame = CGRectMake(0, x_1 + gap, y_1, y_1);
        self.imv_5.frame = CGRectMake(y_1 + gap, x_1 + gap, y_1, y_1);
        self.imv_6.frame = CGRectMake(x_1 + gap, x_1 + gap, y_1, y_1);
        
        self.imv_4.hidden = NO;
        self.imv_5.hidden = NO;
        self.imv_6.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
