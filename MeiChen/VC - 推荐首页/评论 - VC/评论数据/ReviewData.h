//
//  ReviewData.h
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReviewDataDelegate <NSObject>

@optional
// 评论数据
- (void)RequestReviewData_Success;
- (void)RequestReviewData_Fail:(NSError *)error;

// 提交评论
- (void)SubmitReview_Success:(NSInteger)row;
- (void)SubmitReview_Fail:(NSError *)error;


@end

@interface ReviewData : NSObject

@property (nonatomic,weak) id <ReviewDataDelegate> delegate;

@property (nonatomic, strong) DailyModel *dailyModel;

#pragma mark - 计算cell高度
- (CGFloat)cellHeightWith:(NSInteger)row;
- (NSString *)timeStr:(NSInteger)gapTime;
- (NSMutableAttributedString *)AttributedStringWithModel:(revertModel *)model;

#pragma mark - 数据获取
- (NSInteger)numbersOfRows;

- (reviewModel *)modelWithRow:(NSInteger)row;

#pragma mark - 评论数据 请求
- (void)requestReviewData:(BOOL)update;

#pragma mark - 提交评论/回复 请求
// 提交评论/回复
- (void)requestUploadReviewWithContent:(NSString *)content foreign_id:(NSString *)foreign_id replayId:(NSString *)replayId row:(NSInteger)row;



@end
