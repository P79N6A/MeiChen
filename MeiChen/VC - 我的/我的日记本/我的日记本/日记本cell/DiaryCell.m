//
//  DiaryCell.m
//  meirong
//
//  Created by yangfeng on 2019/2/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "DiaryCell.h"

@interface DiaryCell () {
    MyDiaryModel *saveModel;
}

@end

@implementation DiaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 6.0;
    
    self.update.layer.masksToBounds = YES;
    self.update.layer.cornerRadius = self.update.frame.size.height/2.0;
    
    self.backview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backview.layer.shadowOpacity = 0.3;
    self.backview.layer.shadowOffset = CGSizeMake(0,0);
    self.backview.layer.shadowRadius = 2;
    self.backview.clipsToBounds = NO;
    self.backview.layer.cornerRadius = 4.0;
    self.backview.backgroundColor = [UIColor whiteColor];
    
    [self.update setTitle:NSLocalizedString(@"MyDiaryVC_21", nil) forState:(UIControlStateNormal)];
    
    //点击手势
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    [self.icon addGestureRecognizer:r5];
    self.icon.userInteractionEnabled = YES;
}

-(void)setFrame:(CGRect)frame {
    frame.size.height -= 12;
    frame.origin.y += 12;
    [super setFrame:frame];
}

- (void)doTapChange:(UITapGestureRecognizer *)gap {
    if (saveModel != nil) {
        [[imageBrowser shareInstance] showImagesWith:@[saveModel.cover_img] index:0];
    }
}

- (void)LoadDiaryData:(MyDiaryModel *)model {
    saveModel = model;
    [self loadNameWithArray:model.item];
    [self loadTime:model.create_at];
    self.count.text = [NSString stringWithFormat:@"%@%@",model.pass_daily_num,NSLocalizedString(@"MyDiaryVC_20", nil)];
    [self.bu_1 setTitle:[NSString stringWithFormat:@" %@ ",model.views_num] forState:(UIControlStateNormal)];
    [self.bu_2 setTitle:[NSString stringWithFormat:@" %@ ",model.comment_num] forState:(UIControlStateNormal)];
    [self.bu_3 setTitle:[NSString stringWithFormat:@" %@ ",model.like_num] forState:(UIControlStateNormal)];
    
    if ([model.status isEqualToString:@"WAIT_PASS"]) {
        self.status.text = NSLocalizedString(@"MyDiaryVC_24", nil);
        self.status.textColor = kColorRGB(0x999999);
    }
    else if ([model.status isEqualToString:@"IS_PASS"]) {
        self.status.text = NSLocalizedString(@"MyDiaryVC_25", nil);
        self.status.textColor = kColorRGB(0x999999);
    }else if ([model.status isEqualToString:@"UN_PASS"]) {
        self.status.text = NSLocalizedString(@"MyDiaryVC_26", nil);
        self.status.textColor = [UIColor redColor];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.cover_img]];
    });
}

- (void)loadNameWithArray:(NSArray *)array {
    NSMutableString *m_str = [NSMutableString string];
    for (int i = 0; i < array.count; i ++) {
        id obj = array[i];
        if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *model = (itemModel *)obj;
            [m_str appendString:model.item_name];
            if (i < array.count - 1) {
                [m_str appendString:@"、"];
            }
        }
    }
    self.name.text = m_str;
}

- (void)loadTime:(NSString *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    if (date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *str = [formatter stringFromDate:date];
        self.time.text = str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
