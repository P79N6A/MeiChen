//
//  PhotosVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosData.h"      // 相册数据

typedef void (^BlackData)(PhotosData *data);
typedef void (^blockImage)(NSArray *imagesArr);
@interface PhotosVC : UIViewController

@property (nonatomic, strong) PhotosData *data;

@property (nonatomic, copy) BlackData blackdata;

@property (nonatomic) NSInteger indexNumber;

@property (nonatomic, copy) blockImage blockimage;
@property (nonatomic) NSInteger maxCount;

#pragma mark - 检测相册权限
- (void)checkPhotoPermission:(UIViewController *)viewController pushvc:(UIViewController *)pushvc Push:(BOOL)push;

@end
