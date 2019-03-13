//
//  NotMemberView.h
//  meirong
//
//  Created by yangfeng on 2019/3/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockSelectTag)(NSInteger tag);
@interface NotMemberView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *close;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIButton *select_1;

@property (weak, nonatomic) IBOutlet UIButton *select_2;

@property (weak, nonatomic) IBOutlet UIButton *queue;

@property (copy, nonatomic) blockSelectTag index;

- (void)show;

- (void)hide:(BOOL)remove;

@end
