//
//  ExchangeJiFenView.h
//  meirong
//
//  Created by yangfeng on 2019/3/13.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeJiFenView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nane;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UIButton *all;

@property (weak, nonatomic) IBOutlet UITextField *tf_price;

@property (weak, nonatomic) IBOutlet UILabel *lab_3;

@property (weak, nonatomic) IBOutlet UILabel *lab_4;

@property (weak, nonatomic) IBOutlet UILabel *lab_5;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@property (weak, nonatomic) IBOutlet UITextField *tf_number;

@property (weak, nonatomic) IBOutlet UIButton *submit;

// 可兑换积分
- (void)loadNaneLab:(NSInteger)count;

@end
