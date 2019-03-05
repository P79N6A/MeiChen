//
//  RecommendHomePageData.h
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecommendHomePageDataDelegate <NSObject>

@optional
// 热门数据
- (void)RecommendHomePageData_HotData_Success;
- (void)RecommendHomePageData_HotData_Fail:(NSError *)error;

// 分类数据
- (void)RecommendHomePageData_TypeData_Success:(NSInteger)type;
- (void)RecommendHomePageData_TypeData_Fail:(NSError *)error type:(NSInteger)type;

// 数据更新完成
- (void)RecommendHomePageData_UpdateFinishWithRow:(NSInteger)row type:(NSInteger)type;

@end

@interface RecommendHomePageData : NSObject

@property (nonatomic,weak) id <RecommendHomePageDataDelegate> delegate;

+ (instancetype)shareInstance;

// 判断是否需要下载分类数据,如果需要则下载
- (void)DownLoadOneTypeData:(NSInteger)index;
// 判断是否需要弹出提示重新加载的提示
- (BOOL)IsNeedToShowReloadButton;

#pragma mark - 点赞/取消点赞
// 点赞成功
- (void)ZanSuccessWithRow:(NSInteger)row type:(NSInteger)type;
// 取消点赞成功
- (void)CancelZanSuccessWithRow:(NSInteger)row type:(NSInteger)type;
#pragma mark - 更新主页点赞数据
- (void)updateZanDataWith:(ListModel *)model;

#pragma mark - 读取 分类菜单数据读取
- (NSInteger)numbersOfMenuArrayRows;
- (MenuModel *)MenuModelWithRow:(NSInteger)row;
- (NSArray *)MenuArray;

#pragma mark - 读取 分类数据
- (NSArray<ListModel *> *)TypeCaseArrayWith:(NSInteger)type;
- (ListModel *)ListModelWithRow:(NSInteger)row type:(NSInteger)type;


#pragma mark - 热门数据
// 下拉加载热门数据
- (void)RequestHotCaseWithPull:(void (^)(NSError *error))callback;
// 上拉加载更多热门数据
- (void)RequestHotCaseWithPush:(void (^)(NSError *error))callback;

#pragma mark - 分类数据
// 下拉加载分类数据
- (void)RequestTypeCaseWithPullWithType:(NSInteger)type callback:(void (^)(NSError *error))callback;
// 上拉加载更多分类数据
- (void)RequestTypeCaseWithPushWithType:(NSInteger)type callback:(void (^)(NSError *error))callback;


@end
