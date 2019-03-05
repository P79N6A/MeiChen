//
//  AlreadySelectView.h
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockSelectArray)(void);
@interface AlreadySelectView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UIButton *bu_3;

@property (nonatomic, strong) NSMutableArray *m_arr;

@property (copy, nonatomic) blockSelectArray blockselect;

- (void)UpdateSelectArrayWith:(id)model;
- (void)reloadButtonTitle;
@end
