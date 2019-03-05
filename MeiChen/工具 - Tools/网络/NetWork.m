//
//  NetWork.m
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "NetWork.h"
#define timeout 5.0

@interface NetWork () {
    AFHTTPSessionManager *manager;
}


@end

@implementation NetWork

- (instancetype)init {
    self = [super init];
    if (self) {
        manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeout;
    }
    return self;
}

// 取消网络请求
- (void)cancelRequest {
    if ([manager.tasks count] > 0) {
        NSLog(@"取消网络请求");
        NSLog(@"tasks = %@",manager.tasks);
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
    else {
        NSLog(@"没有正在请求的网络");
    }
}

// 请求网络
- (NSURLSessionDataTask *)requestWithUrl:(NSString *)url Parames:(NSMutableDictionary *)parames Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    NSLog(@"NetWork urlStr = %@",urlStr);
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:parames progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"进度更新 = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
        successTask(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failureTask(error);
    }];
    return task;
}

- (NSURLSessionDataTask *)requestWithUrl:(NSString *)url Parames:(NSMutableDictionary *)parames Success:(void (^)(id responseObject))successTask Progress:(void (^)(double prog))progress  Failure:(void (^)(NSError *error))failureTask {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    NSLog(@"NetWork urlStr = %@",urlStr);
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:parames progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
        NSLog(@"进度更新 = %f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successTask(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureTask(error);
    }];
    return task;
}

@end
