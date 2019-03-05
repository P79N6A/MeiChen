//
//  ByronCarouselView.h
//  MethodDemo
//
//  Created by 杨峰 on 2018/11/19.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ByronCarouselView;
@protocol ByronCarouselViewDelegate <NSObject>
@optional
/**
 *  点击图片的回调事件
 */
- (void)carouselView:(ByronCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger)index;
@end

@interface ByronCarouselView : UIView

//传入图片数组
@property (nonatomic, copy) NSArray *images;
//pageControl颜色设置
@property (nonatomic, strong) UIColor *currentPageColor;
@property (nonatomic, strong) UIColor *pageColor;

//是否竖向滚动
@property (nonatomic, assign, getter=isScrollDorectionPortrait) BOOL scrollDorectionPortrait;

@property (weak, nonatomic) id<ByronCarouselViewDelegate> delegate;

@end
