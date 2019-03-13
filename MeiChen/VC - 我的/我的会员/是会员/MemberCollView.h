//
//  MemberCollView.h
//  meirong
//
//  Created by yangfeng on 2019/3/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCollView : UIView

@property (nonatomic, strong) UICollectionView *collection;

/**
 当前选中位置
 */
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
/**
 是否分页，默认为true
 */
@property (nonatomic, assign) BOOL pagingEnabled;
///**
// 设置数据源
// */
//@property (nonatomic, strong) NSArray <XLCardItem *>*items;
/**
 手动滚动到某个卡片位置
 */
- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;

@end
