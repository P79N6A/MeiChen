//
//  MyCell_1.h
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell_1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *time_1;

@property (weak, nonatomic) IBOutlet UILabel *time_2;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

+ (instancetype)cellWithTableView:(UITableView *)tableview;


@end
