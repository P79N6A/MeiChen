//
//  MyHeaderView.h
//  meirong
//
//  Created by yangfeng on 2019/1/29.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImv;

@property (weak, nonatomic) IBOutlet UIButton *share;




- (void)LoadUserData;

@end
