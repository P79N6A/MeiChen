//
//  WaterFlowLayout.h
//  meirong
//
//  Created by yangfeng on 2018/12/14.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;

@end

@interface WaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterFlowLayoutDelegate> delegate;

@end
