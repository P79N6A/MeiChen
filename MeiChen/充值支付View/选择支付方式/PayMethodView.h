//
//  PayMethodView.h
//  meirong
//
//  Created by yangfeng on 2019/3/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockPrice)(NSString *price);
typedef void(^blockRecharge)(NSError *error);
@interface PayMethodView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *lab_3;

@property (weak, nonatomic) IBOutlet UILabel *lab_4;

@property (copy, nonatomic) blockPrice blockprice;

@property (copy, nonatomic) blockRecharge recharge;

- (void)loadPrice:(NSString *)str;

- (void)show;

- (void)hide;

@end
