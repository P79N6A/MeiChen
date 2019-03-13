//
//  PaySuccessVC.h
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessVC : UIViewController

@property (nonatomic) BOOL isOfflinePay;
@property (nonatomic, strong) NSString *order_id;
@end
