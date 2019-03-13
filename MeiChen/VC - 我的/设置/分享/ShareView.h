//
//  ShareView.h
//  meirong
//
//  Created by yangfeng on 2019/2/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockTag)(NSInteger index);
@interface ShareView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *close;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;
@property (weak, nonatomic) IBOutlet UIButton *bu_2;
@property (weak, nonatomic) IBOutlet UIButton *bu_3;
@property (weak, nonatomic) IBOutlet UIButton *bu_4;
@property (weak, nonatomic) IBOutlet UIButton *bu_5;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;

@property (copy, nonatomic) blockTag index;

- (void)show;

@end
