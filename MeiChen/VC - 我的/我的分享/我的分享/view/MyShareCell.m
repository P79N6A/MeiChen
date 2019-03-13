//
//  MyShareCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareCell.h"

@implementation MyShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 12.0;
    
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 2.0;
}

- (void)loadData:(NSIndexPath *)indexPath {
    self.imv.image = [UIImage imageNamed:@"按钮背景"];
    switch (indexPath.row) {
            case 0: {
                self.name.text = NSLocalizedString(@"MyShareVC_13", nil);
                [self loadLab_1:@"1000 分"];
                self.lab_2.text = NSLocalizedString(@"MyShareVC_15", nil);
                self.lab_3.text = NSLocalizedString(@"MyShareVC_16", nil);
                [self.button setTitle:NSLocalizedString(@"MyShareVC_19", nil) forState:(UIControlStateNormal)];
                break;
            }
            case 1: {
                self.name.text = NSLocalizedString(@"MyShareVC_14", nil);
                [self loadLab_1:@"1.8 倍"];
                self.lab_2.text = NSLocalizedString(@"MyShareVC_17", nil);
                self.lab_3.text = NSLocalizedString(@"MyShareVC_18", nil);
                [self.button setTitle:NSLocalizedString(@"MyShareVC_20", nil) forState:(UIControlStateNormal)];
                break;
            }
        default:
            break;
    }
}

// 可兑换积分
- (void)loadLab_1:(NSString *)str {
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(str.length-1, 1);
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0xffffff) range:NSMakeRange(0, str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0xffffff) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range];
    
    self.lab_1.attributedText = attribut;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
