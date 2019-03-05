//
//  NetWork.h
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface NetWork : NSObject


// 取消网络请求
- (void)cancelRequest;

// 请求网络
- (NSURLSessionDataTask *)requestWithUrl:(NSString *)url Parames:(NSMutableDictionary *)parames Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask;

- (NSURLSessionDataTask *)requestWithUrl:(NSString *)url Parames:(NSMutableDictionary *)parames Success:(void (^)(id responseObject))successTask Progress:(void (^)(double prog))progress  Failure:(void (^)(NSError *error))failureTask;

@end
