//
//  WaterFlowCollectionVC.h
//  meirong
//
//  Created by yangfeng on 2018/12/14.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFlowCollectionVC : UICollectionViewController

// 偏移距离
@property (nonatomic, copy) void(^ scrollIndex)(CGFloat offset);

//
@property (nonatomic, copy) void(^ ZanSelect)(UIButton *sender);

// 表头是否需要偏移
@property (nonatomic) NSInteger hasHeader;

#pragma mark - 外界提供数据
- (void)reloadWaterFlowCollectionVCData:(NSArray *)array;








// 上拉刷新
@property (nonatomic) void(^ pullRefresh)(void);
// 下拉刷新
@property (nonatomic) void(^ pushRefresh)(void);




@end

