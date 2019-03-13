//
//  PricesView.h
//  meirong
//
//  Created by yangfeng on 2019/3/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PricesView : UIView

@property (weak, nonatomic) IBOutlet UILabel *price_1;
@property (weak, nonatomic) IBOutlet UILabel *price_2;

@property (weak, nonatomic) IBOutlet UIButton *pay;

- (void)loadDataWith:(PlanDetailModel *)model;

@end
