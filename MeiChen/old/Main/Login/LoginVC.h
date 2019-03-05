//
//  LoginVC.h
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

// 是否自动授权标识，yes表示会自动调用微信授权方法
@property (nonatomic) BOOL autoAuthorization;


@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIImageView *iconImv;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *pinTF;



@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;


@property (weak, nonatomic) IBOutlet UIButton *wechatButton;


@property (weak, nonatomic) IBOutlet UIView *phoneLine;


@property (weak, nonatomic) IBOutlet UIView *detailLine;


@property (weak, nonatomic) IBOutlet UIImageView *backImv;





@end
