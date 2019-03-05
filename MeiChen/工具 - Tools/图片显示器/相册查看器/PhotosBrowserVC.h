//
//  PhotosBrowserVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosData.h"

@interface PhotosBrowserVC : UIViewController

@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;
@property (nonatomic, strong) PhotosData *data;

@end
