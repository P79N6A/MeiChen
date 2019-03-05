//
//  OneImagesVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^DidTouch)(void);
@interface OneImagesVC : UIViewController

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, copy) DidTouch touch;

@end
