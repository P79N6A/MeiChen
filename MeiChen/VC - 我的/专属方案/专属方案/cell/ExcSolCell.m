//
//  ExcSolCell.m
//  meirong
//
//  Created by yangfeng on 2019/2/27.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExcSolCell.h"


@interface ExcSolCell () {
    NSString *imvUrlStr;
}
@end

@implementation ExcSolCell


+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    ExcSolCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExcSolCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bu_1.layer.masksToBounds = YES;
    self.bu_1.layer.cornerRadius = 25/2.0;
    self.bu_2.layer.masksToBounds = YES;
    self.bu_2.layer.cornerRadius = 25/2.0;
    self.bu_3.layer.masksToBounds = YES;
    self.bu_3.layer.cornerRadius = 25/2.0;
    self.bu_1.hidden = YES;
    self.bu_2.hidden = YES;
    self.bu_3.hidden = YES;
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 2.0;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0;
    
    self.title_1.text = NSLocalizedString(@"MyVC_10", nil);
    self.title_2.text = NSLocalizedString(@"MyVC_11", nil);
    self.title_3.text = NSLocalizedString(@"MyVC_12", nil);
    
    [self.button setTitle:NSLocalizedString(@"MyVC_13", nil) forState:(UIControlStateNormal)];
    
    self.line.hidden = YES;
    
    self.title_1.backgroundColor = [UIColor clearColor];
    self.title_2.backgroundColor = [UIColor clearColor];
    self.title_3.backgroundColor = [UIColor clearColor];
    self.lab_1.backgroundColor = [UIColor clearColor];
    self.lab_2.backgroundColor = [UIColor clearColor];
    
    self.back.layer.masksToBounds = YES;
    self.back.layer.cornerRadius = 2.0;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanMethod:)];
    self.imv.layer.masksToBounds = YES;
    [self.imv addGestureRecognizer:pan];
}

- (void)PanMethod:(UIPanGestureRecognizer *)pan {
    [[imageBrowser shareInstance] showImagesWith:@[imvUrlStr] index:0];
}

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath model:(OrderListModel *)model {
    if (indexPath.row > 0) {
        self.line.hidden = NO;
    }
    imvUrlStr = model.cover_img;
    [self.imv sd_setImageWithURL:[NSURL URLWithString:imvUrlStr]];
    self.imv.clipsToBounds = YES;
    
    self.lab_1.text = model.analysis;
    self.lab_2.text = model.effect;
    
    if ([model.is_pay integerValue] == 1) {
        self.button.hidden = YES;
    }
    else {
        self.button.hidden = NO;
    }
    
    for (int i = 0; i < model.item.count; i ++) {
        OrderItemModel *item = model.item[i];
        NSString *title = [NSString stringWithFormat:@" %@ ",item.item_name];
        switch (i) {
            case 0: {
                [self.bu_1 setTitle:title forState:(UIControlStateNormal)];
                self.bu_1.hidden = NO;
                break;
            }
            case 1: {
                [self.bu_2 setTitle:title forState:(UIControlStateNormal)];
                self.bu_2.hidden = NO;
                break;
            }
            case 2: {
                [self.bu_3 setTitle:title forState:(UIControlStateNormal)];
                self.bu_3.hidden = NO;
                break;
            }
            default:
                break;
        }
    }
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
