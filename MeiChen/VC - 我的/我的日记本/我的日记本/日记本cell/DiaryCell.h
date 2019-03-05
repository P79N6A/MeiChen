//
//  DiaryCell.h
//  meirong
//
//  Created by yangfeng on 2019/2/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *bu_1;
@property (weak, nonatomic) IBOutlet UIButton *bu_2;
@property (weak, nonatomic) IBOutlet UIButton *bu_3;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *update;

@property (weak, nonatomic) IBOutlet UIView *backview;

@property (weak, nonatomic) IBOutlet UILabel *status;


- (void)LoadDiaryData:(MyDiaryModel *)model;

@end
