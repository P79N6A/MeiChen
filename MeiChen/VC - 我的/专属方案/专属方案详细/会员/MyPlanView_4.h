//
//  MyPlanView_4.h
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanView_4 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UILabel *detail_1;

@property (weak, nonatomic) IBOutlet UIButton *select_1;

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UILabel *price_1;
@property (weak, nonatomic) IBOutlet UILabel *price_2;

@property (weak, nonatomic) IBOutlet UIButton *pay;

- (void)loadDataWith:(PlanDetailModel *)model;

@end
