//
//  ExampleView.h
//  meirong
//
//  Created by yangfeng on 2019/1/28.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleView : UIView


@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, copy) NSArray *array;



- (void)ShowImages:(NSArray *)array;

@end
