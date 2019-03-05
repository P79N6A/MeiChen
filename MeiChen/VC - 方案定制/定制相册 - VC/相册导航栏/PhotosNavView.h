//
//  PhotosNavView.h
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosNavViewDelegate <NSObject>

@optional
- (void)PhotosNavView_LeftItem:(UIButton *)sender;
- (void)PhotosNavView_TitleItem:(UIButton *)sender;

@end

@interface PhotosNavView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftItem;

@property (weak, nonatomic) IBOutlet UIButton *titleItem;

@property (weak, nonatomic) id <PhotosNavViewDelegate> delegate;

// 所有照片的导航栏
- (void)SetNav_1;

- (void)SetNav_2:(NSString *)title;

@end
