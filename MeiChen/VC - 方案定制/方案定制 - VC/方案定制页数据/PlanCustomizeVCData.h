//
//  PlanCustomizeVCData.h
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlanCustomizeVCDataDelegate <NSObject>

@optional
- (void)request_StyleTopCat_success;
- (void)request_StyleTopCat_fail:(NSError *)error;

- (void)request_ModelList_success;
- (void)request_ModelList_fail:(NSError *)error;

@end


@interface PlanCustomizeVCData : NSObject

@property (nonatomic, weak) id <PlanCustomizeVCDataDelegate> delegate;

@property (nonatomic, copy, readonly) NSArray<PlanStyleModel *> *styleArray;   // 风格数据
@property (nonatomic, copy, readonly) NSArray<PlanStyleModel *> *topcatArray;  // 部位数据
@property (nonatomic, readonly) NSInteger currentStyleIndex;              // 当前的风格选择
@property (nonatomic, readonly) NSInteger currentTopCatIndex;             // 当前的部位选择
// 选择的模特模型
@property (nonatomic, strong, readonly) NSMutableArray<ImageModel *> *selectModels;

#pragma mark - 二、数据读取
// 读取风格的模特数据
- (NSArray *)readImageModelData;
// 读取模特图片模型
- (ImageModel *)readImageModel:(NSInteger)row;
// 选择一个模特图片模型
- (void)SelectImageModel:(NSInteger)row;
// 删除一个模特图片模型
- (void)DeleteImageModel:(NSInteger)row;
// 获取选择的模特模型indexPath
- (NSArray<NSIndexPath *> *)selectImageModelIndexPath:(NSArray *)array;

#pragma mark - 一、数据下载
// 下载 风格/部位 数据
- (void)requestStyleTopCatData;
// 下载 模特图片 数据
- (void)requestModelListData:(BOOL)first;


#pragma mark - 3-1
// 3-1、判断风格的模特数据是否需要下载，如果需要就下载
- (BOOL)isNeedToDowmloadStyleData:(NSInteger)style;
// 3-2、切换风格
- (void)switchoverStyle:(NSInteger)style;
// 3-3、清空选择的模特图片
- (void)CleanData;
// 3-4、切换部位
- (void)switchoverTopCat:(NSInteger)topcat;

@end
