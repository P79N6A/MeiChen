//
//  ExcSolCell.h
//  meirong
//
//  Created by yangfeng on 2019/2/27.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcSolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIView *back;

@property (weak, nonatomic) IBOutlet UIImageView *imv;


@property (weak, nonatomic) IBOutlet UILabel *title_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;


@property (weak, nonatomic) IBOutlet UILabel *title_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;


@property (weak, nonatomic) IBOutlet UILabel *title_3;


@property (weak, nonatomic) IBOutlet UIButton *bu_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UIButton *bu_3;

@property (weak, nonatomic) IBOutlet UIButton *button;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadDataWithIndexPath:(NSIndexPath *)indexPath model:(OrderListModel *)model;

@end
