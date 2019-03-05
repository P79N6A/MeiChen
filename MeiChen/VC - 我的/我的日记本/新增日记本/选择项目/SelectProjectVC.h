//
//  SelectProjectVC.h
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockType)(NSArray *array);
@interface SelectProjectVC : UIViewController
@property (copy, nonatomic) blockType blockArray;
@property (nonatomic, strong) NSMutableArray *SelectArray;
@end
