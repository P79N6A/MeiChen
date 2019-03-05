//
//  CaseMiddleView.h
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sortingBlock)(void);
@interface CaseMiddleView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name_p;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UIButton *bu_1;
@property (weak, nonatomic) IBOutlet UIButton *bu_2;


@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *beautifulTime;
@property (weak, nonatomic) IBOutlet UILabel *beforeMe;
@property (weak, nonatomic) IBOutlet UILabel *beautifulProcess;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *imv_1;
@property (weak, nonatomic) IBOutlet UIImageView *imv_2;
@property (weak, nonatomic) IBOutlet UIImageView *imv_3;

@property (weak, nonatomic) IBOutlet UIButton *sortingButton;

@property (nonatomic, copy) sortingBlock sorting;

- (void)loadModel:(CaseDetailModel *)model;

@end
