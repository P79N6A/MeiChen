//
//  CameraVC.h
//  meirong
//
//  Created by yangfeng on 2018/12/20.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageblock)(UIImage *image);
@interface CameraVC : UIViewController
//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
////闪光灯按钮
//@property (weak, nonatomic) UIButton *flashButton;
//聚焦
@property (weak, nonatomic) IBOutlet UIView *focusView;
//翻转摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *turnButton;

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UIButton *finish;

@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (nonatomic, copy) imageblock blockimage;

#pragma mark - 检测相机权限
- (void)checkCameraPermission:(UIViewController *)viewController pushvc:(UIViewController *)pushvc can:(BOOL)can;


@end
