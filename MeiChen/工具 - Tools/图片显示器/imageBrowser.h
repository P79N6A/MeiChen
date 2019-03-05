//
//  imageBrowser.h
//  meirong
//
//  Created by yangfeng on 2019/1/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageBrowser : UIView

+ (instancetype)shareInstance;

- (void)showImagesWith:(NSArray *)array index:(NSInteger)index;


- (void)hideImageBrowser;

//// url
//- (void)showImageBrowserWith:(NSArray *)array index:(NSInteger)index;
//// 图片
//- (void)showImageBrowserWithImages:(NSArray *)array index:(NSInteger)index;
@end
