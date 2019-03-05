//
//  TypeSegmentCVC.h
//  meirong
//
//  Created by yangfeng on 2018/12/17.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeSegmentCVC : UICollectionViewController

// 当前选择的item
@property (nonatomic) NSInteger selectIndex;

// 返回当前的选择item
@property (nonatomic, strong) void (^block)(NSInteger row);

#pragma mark - 提供外界集合视图的数据
- (void)reloadTypeSegmentCVCData:(NSArray *)array;

@end
