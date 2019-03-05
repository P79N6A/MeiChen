//
//  SearchDetailData.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDetailVCDataDelegate <NSObject>

@optional
// 标签搜索
- (void)SearchDetailVCData_TagSearchRequest_Success;
- (void)SearchDetailVCData_TagSearchRequest_Success_NotData;
- (void)SearchDetailVCData_TagSearchRequest_Fail:(NSError *)error;

// 分类数据
- (void)SearchDetailVCData_TypeSearchRequest_Success;
- (void)SearchDetailVCData_TypeSearchRequest_Success_NotData;
- (void)SearchDetailVCData_TypeSearchRequest_Fail:(NSError *)error;

// 数据更新完成
- (void)SearchDetailVCData_UpdateFinish:(NSInteger)row;

@end

@interface SearchDetailVCData : NSObject

@property (nonatomic,weak) id <SearchDetailVCDataDelegate> delegate;

// 搜索结果数据
- (NSArray *)AllSearchData;
- (ListModel *)ListModelWith:(NSInteger)row;

#pragma mark - 点赞/取消点赞
// 点赞成功
- (void)ZanSuccessWithRow:(NSInteger)row;
// 取消点赞成功
- (void)CancelZanSuccessWithRow:(NSInteger)row;

#pragma mark - 标签搜索 请求
// 标签搜索
- (void)requestTagSearchDataWith:(NSString *)text;

// 标签搜索 更多
- (void)requestTagSearchDataMoreWith:(NSString *)text;

#pragma mark - 分类搜索 请求
// 分类搜索
- (void)requestTypeSearchDataWith:(NSInteger)page key:(NSString *)key val:(NSString *)val;
// 分类搜索 更多
- (void)requestTypeSearchDataMoreWithKey:(NSString *)key val:(NSString *)val;

@end
