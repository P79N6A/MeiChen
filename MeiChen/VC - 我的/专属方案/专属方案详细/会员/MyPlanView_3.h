//
//  MyPlanView_3.h
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanView_3 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;
@property (weak, nonatomic) IBOutlet UILabel *lab_6;

@property (weak, nonatomic) IBOutlet UILabel *detail_1;
@property (weak, nonatomic) IBOutlet UILabel *detail_2;
@property (weak, nonatomic) IBOutlet UILabel *detail_3;
@property (weak, nonatomic) IBOutlet UILabel *detail_4;

@property (weak, nonatomic) IBOutlet UIButton *select_2;
@property (weak, nonatomic) IBOutlet UIButton *select_3;

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UILabel *price_1;
@property (weak, nonatomic) IBOutlet UILabel *price_2;

@property (weak, nonatomic) IBOutlet UIButton *pay;

- (void)loadDataWith:(PlanDetailModel *)model;

@end
