//
//  PhotosCellVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/16.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosData.h"      // 相册数据

typedef void (^BlackData)(PhotosData *data);
@interface PhotosCellVC : UIViewController

@property (nonatomic, strong) PhotosData *data;
@property (nonatomic) NSInteger section;
@property (nonatomic, copy) BlackData blackdata;

@end
