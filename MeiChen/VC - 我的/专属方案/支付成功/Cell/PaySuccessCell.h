//
//  PaySuccessCell.h
//  meirong
//
//  Created by yangfeng on 2019/3/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UILabel *lab_3;

@property (weak, nonatomic) IBOutlet UIButton *bu;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadModel:(SurgeryListSurgery *)model indexPath:(NSIndexPath *)indexPath;

@end
