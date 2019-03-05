//
//  WatingPlanVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/23.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatingPlanVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UIView *countdownView;

@property (weak, nonatomic) IBOutlet UILabel *lab_3;

@property (weak, nonatomic) IBOutlet UIButton *setting;

@property (nonatomic) NSInteger from;

// 会员数
@property (nonatomic, strong) NSString *fake_member_num;
// 定制数
@property (nonatomic, strong) NSString *fake_former_num;

@end
