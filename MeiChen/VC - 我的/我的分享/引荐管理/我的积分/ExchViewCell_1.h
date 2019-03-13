//
//  ExchViewCell_1.h
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchViewCell_1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *proLab;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UIButton *bu_3;

- (void)loadData:(CommissionStreamModel *)model;

@end
