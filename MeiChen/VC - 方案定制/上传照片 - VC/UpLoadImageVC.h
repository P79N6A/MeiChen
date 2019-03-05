//
//  UpLoadImageVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadImageVC : UIViewController

// 自己相册的照片
@property (nonatomic, copy) NSArray<UIImage *> *uploadImagesArray;
// 服务器照片
@property (nonatomic, copy) NSArray<ImageModel *> *serverImagesArray;

@property (nonatomic, strong) PlanStyleModel *topcatModel;
@property (nonatomic, strong) PlanStyleModel *styleModel;

@end
