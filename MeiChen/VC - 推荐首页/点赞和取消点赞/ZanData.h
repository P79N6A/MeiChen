//
//  ZanData.h
//  meirong
//
//  Created by yangfeng on 2019/1/11.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZanDataDelegate <NSObject>

@optional
// 点赞
- (void)ZanData_Zan_SuccessWithRow:(NSInteger)row type:(NSInteger)type;
- (void)ZanData_Zan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type;

// 取消点赞
- (void)ZanData_CancelZan_SuccessWithRow:(NSInteger)row type:(NSInteger)type;
- (void)ZanData_CancelZan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type;

@end

@interface ZanData : NSObject

@property (nonatomic,weak) id <ZanDataDelegate> delegate;



#pragma mark - 取消请求
// 取消请求
- (void)CancelNetWork;

#pragma mark - 点赞请求
- (void)requestZanWithId:(NSString *)foreign_id type:(NSString *)asset_type row:(NSInteger)row type:(NSInteger)type;

#pragma mark - 取消点赞请求
- (void)requestCancelZanWithId:(NSString *)foreign_id type:(NSString *)asset_type row:(NSInteger)row type:(NSInteger)type;



@end
