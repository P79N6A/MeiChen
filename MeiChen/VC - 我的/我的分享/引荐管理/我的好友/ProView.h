//
//  ProView.h
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProView : UIView

@property (weak, nonatomic) IBOutlet UIView *progress;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UILabel *lab_2;

@property (weak, nonatomic) IBOutlet UILabel *value_1;

@property (weak, nonatomic) IBOutlet UILabel *value_2;

@property (weak, nonatomic) IBOutlet UIView *view_1;
@property (weak, nonatomic) IBOutlet UIView *childView_1;

@property (weak, nonatomic) IBOutlet UIView *view_2;
@property (weak, nonatomic) IBOutlet UIView *childView_2;

- (void)settingProgressValue:(CGFloat)value;

@end
