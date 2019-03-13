//
//  PaySuccessCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PaySuccessCell.h"

@implementation PaySuccessCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    PaySuccessCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PaySuccessCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bu.layer.masksToBounds = YES;
    self.bu.layer.cornerRadius = 5.0;
    
    self.lab_1.layer.masksToBounds = YES;
    self.lab_1.layer.cornerRadius = self.lab_1.frame.size.height/2.0;
    
    self.lab_2.layer.masksToBounds = YES;
    self.lab_2.layer.cornerRadius = self.lab_2.frame.size.height/2.0;
    
    self.lab_3.layer.masksToBounds = YES;
    self.lab_3.layer.cornerRadius = self.lab_3.frame.size.height/2.0;
    
    self.lab_1.hidden = YES;
    self.lab_2.hidden = YES;
    self.lab_3.hidden = YES;
}

- (void)loadModel:(SurgeryListSurgery *)model indexPath:(NSIndexPath *)indexPath {
    self.bu.tag = indexPath.row;
    
    self.lab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"ServersVC_14", nil),model.seq];
    if (model.items.count >= 1) {
        itemModel *item = model.items[0];
        self.lab_1.text = [NSString stringWithFormat:@"  %@  ",item.item_name];
        self.lab_1.hidden = NO;
    }
    if (model.items.count >= 2) {
        itemModel *item = model.items[1];
        self.lab_2.text = [NSString stringWithFormat:@"  %@  ",item.item_name];
        self.lab_2.hidden = NO;
    }
    if (model.items.count >= 3) {
        itemModel *item = model.items[2];
        self.lab_3.text = [NSString stringWithFormat:@"  %@  ",item.item_name];
        self.lab_3.hidden = NO;
    }
    
    if ([model.is_allow_book integerValue] == 1) {
        [self.bu setTitle:NSLocalizedString(@"PaySuccessVC_5", nil) forState:(UIControlStateNormal)];
        [self.bu setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:(UIControlStateNormal)];
    }
    else {
        [self.bu setTitle:NSLocalizedString(@"PaySuccessVC_6", nil) forState:(UIControlStateNormal)];
        [self.bu setBackgroundImage:nil forState:(UIControlStateNormal)];
        self.bu.backgroundColor = kColorRGB(0xcccccc);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
