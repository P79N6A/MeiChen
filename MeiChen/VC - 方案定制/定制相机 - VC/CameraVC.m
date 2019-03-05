//
//  CameraVC.m
//  meirong
//
//  Created by yangfeng on 2018/12/20.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "CameraVC.h"
#import <AVFoundation/AVFoundation.h> //导入相机框架

@interface CameraVC () <AVCapturePhotoCaptureDelegate> {
    CGRect fram;
}

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic) AVCapturePhotoOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

//预览画面
@property (nonatomic, strong) AVCapturePhotoSettings *photoSettings;

//图像设置
@property (nonatomic, assign) AVCaptureFlashMode mode;

@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
    self.focusView.hidden = YES;
    
    [self isNeedToSetHidden:YES];
    
    [self customCamera];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    fram = self.view.frame;
    self.previewLayer.frame = fram;
    [self.view bringSubviewToFront:self.photoButton];
    [self.view bringSubviewToFront:self.turnButton];
    [self.view bringSubviewToFront:self.imv];
    [self.view bringSubviewToFront:self.cancel];
    [self.view bringSubviewToFront:self.finish];
    
    self.photoButton.layer.masksToBounds = YES;
    self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width / 2.0;
    self.photoButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    self.cancel.layer.masksToBounds = YES;
    self.cancel.layer.cornerRadius = self.cancel.frame.size.width / 2.0;
    
    self.finish.layer.masksToBounds = YES;
    self.finish.layer.cornerRadius = self.finish.frame.size.width / 2.0;
    
    [self isRemake];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}

// 判断是否为重拍按钮
- (void)isRemake {
    if (self.imv.isHidden) {
        // 说明是返回按钮
        [self.cancel setImage:[UIImage imageNamed:@"拍照下拉"] forState:(UIControlStateNormal)];
        [self.cancel setBackgroundColor:[UIColor clearColor]];
    }
    else {
        // 说明是返回重拍按钮
        [self.cancel setImage:[UIImage imageNamed:@"拍照返回2"] forState:(UIControlStateNormal)];
        [self.cancel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    }
}

#pragma mark - 自定义相机
- (void)customCamera {
    //后置摄像头
    self.device = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    
    self.ImageOutPut = [[AVCapturePhotoOutput alloc]init];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示,即创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
        if ([self.device hasFlash]) {
            //闪光灯自动
            if (self.photoSettings.flashMode == AVCaptureFlashModeAuto) {
                self.photoSettings.flashMode = AVCaptureFlashModeAuto;
                self.device.torchMode = AVCaptureFlashModeAuto;
            }
        }
        
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        //解锁
        [self.device unlockForConfiguration];
    }
}

#pragma mark - 触摸方法
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = fram.size;//self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}

#pragma mark - 取得指定位置的摄像头
/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray *devicesIOS  = devicesIOS10.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - 检测相机权限
- (void)checkCameraPermission:(UIViewController *)viewController pushvc:(UIViewController *)pushvc  can:(BOOL)can {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            // 0 不确定权限，请求用户授权
            [self NotDetermined:viewController pushvc:pushvc can:can];
            break;
        }
        case AVAuthorizationStatusRestricted: {
            // 1 访问受限制
            
            break;
        }
        case AVAuthorizationStatusDenied: {
            // 2 用户没有授权,提示用户授权
            if (can) {
                [self Denied:viewController];
            }
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 3 已经授权
            if (can) {
                 [self pushFrom:viewController pushvc:pushvc];
            }
            break;
        }
        default:
            break;
    }
}



// 用户没有授权相机，提示用户授权
- (void)Denied:(UIViewController *)viewController {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"camcer_1", nil) message:NSLocalizedString(@"camcer_2", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"camcer_3", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"camcer_4", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:action];
    [controller addAction:cancel];
    
    [viewController presentViewController:controller animated:YES completion:nil];
}

// 请求用户授权
- (void)NotDetermined:(UIViewController *)viewController pushvc:(UIViewController *)pushvc can:(BOOL)can {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            // 用户确认授权
            NSLog(@"用户确认授权");
            if (can) {
                [self pushFrom:viewController pushvc:pushvc];
            }
        }
        else {
            // 用户取消授权
            NSLog(@"用户取消授权");
        }
    }];
}

- (void)pushFrom:(UIViewController *)vc pushvc:(UIViewController *)pushvc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc.navigationController pushViewController:pushvc animated:YES];
    });
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSLog(@"相片 = %s", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imv.image = image;
        [self isNeedToSetHidden:NO];
        [self isRemake];
    });
}

- (void)isNeedToSetHidden:(BOOL)hidden {
    self.imv.hidden = hidden;
    self.finish.hidden = hidden;
}

- (IBAction)PhotoButtonMethod:(UIButton *)sender {
    AVCaptureConnection *videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection == nil) {
        NSLog(@"拍照失败");
        return;
    }
    self.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    [self.ImageOutPut capturePhotoWithSettings:self.photoSettings delegate:self];
}

- (IBAction)TurnOnButtonMethod:(UIButton *)sender {
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    if (newInput != nil) {
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
}

#pragma mark - 返回
- (IBAction)CancelButtonMethod:(UIButton *)sender {
    if (self.imv.isHidden) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self isNeedToSetHidden:YES];
        [self isRemake];
    }
}

- (IBAction)FinishMethod:(UIButton *)sender {
    NSLog(@"FinishMethod = %@",_blockimage);
    if (_blockimage) {
        NSLog(@"block");
        _blockimage(self.imv.image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
