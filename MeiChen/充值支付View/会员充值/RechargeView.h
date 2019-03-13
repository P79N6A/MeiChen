//
//  RechargeView.h
//  meirong
//
//  Created by yangfeng on 2019/3/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockIndex)(NSString *price);
@interface RechargeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UIButton *close;


@property (weak, nonatomic) IBOutlet UILabel *lab_2;


@property (weak, nonatomic) IBOutlet UIButton *select_1;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *value_1;
@property (weak, nonatomic) IBOutlet UILabel *price;


@property (weak, nonatomic) IBOutlet UIButton *select_2;
@property (weak, nonatomic) IBOutlet UILabel *value_2;


@property (weak, nonatomic) IBOutlet UIButton *queue;

@property (copy, nonatomic) blockIndex index;

@property (nonatomic) BOOL isshow;

- (void)loadPrice;

- (void)show;

- (void)hide:(BOOL)remove;

@end
