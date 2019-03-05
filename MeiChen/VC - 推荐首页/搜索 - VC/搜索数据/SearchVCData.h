//
//  SearchData.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchVCDataDelegate <NSObject>

@optional
// 热门搜索
- (void)SearchVCData_HotSearchRequest_Success;
- (void)SearchVCData_HotSearchRequest_Fail:(NSError *)error;

@end

@interface SearchVCData : NSObject

@property (nonatomic,weak) id <SearchVCDataDelegate> delegate;


#pragma mark - 读取 搜索页数据
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsWithSection:(NSInteger)section;
- (NSString *)StringWithIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 历史数据
// 删除
- (void)deleteHistoryData;
// 刷新
- (void)updateHistoryData;
// 添加
- (void)addHistoryData:(NSString *)text;

#pragma mark - 热门搜索 请求
- (void)requestHotSearchData;

@end
