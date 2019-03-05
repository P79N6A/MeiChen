//
//  ImageCVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/17.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanCustomizeVCData.h"

@interface ImageCVC : UICollectionViewController

// 偏移距离
@property (nonatomic, copy) void(^ scrollIndex)(CGFloat offset);

// 选择按钮点击block
@property (nonatomic, copy) void(^ selectButton)(UIButton *sender);

@property (nonatomic, strong) PlanCustomizeVCData *data;

#pragma mark - 外界提供数据
- (void)reloadWaterFlowCollectionVCData:(NSArray *)array selectArray:(NSArray *)selectArray type:(NSInteger)type;

- (void)updateSelectArray:(NSArray *)selectArray;

@end
