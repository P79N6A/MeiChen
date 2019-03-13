//
//  CardView_2.h
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView_2 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *price_1;

@property (weak, nonatomic) IBOutlet UITableView *tabview;

- (void)loadDataWith:(MyDZDetailModel *)model;

@end
