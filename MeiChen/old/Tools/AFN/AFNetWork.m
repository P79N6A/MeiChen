//
//  AFNetWork.m
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "AFNetWork.h"
#import <AFNetworking/AFNetworking.h>

#define timeout 15.0

@implementation AFNetWork

#pragma mark 网络请求  文件上传
+ (NSURLSessionDataTask *)RequestWith:(NSString *)method url:(NSString *)url Parames:(NSMutableDictionary *)parames File:(NSString *)file Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    
    NSLog(@"urlStr = %@",urlStr);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeout;
    
    if (file != nil && file.length > 0) {
        return [manager POST:urlStr parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@.jpg",file]];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"image" error:nil]; //文件上传
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    
    if ([method isEqualToString:@"GET"]) {
        return [manager GET:urlStr parameters:parames progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else if ([method isEqualToString:@"PUT"]) {
        return [manager PUT:urlStr parameters:parames success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else if ([method isEqualToString:@"DELETE"]) {
        return [manager DELETE:urlStr parameters:parames success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureTask(error);
        }];
    }
    else {
        NSURLSessionDataTask *task = [manager POST:urlStr parameters:parames progress:^(NSProgress * _Nonnull uploadProgress) {
            //        NSLog(@"进度更新 = %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successTask(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            failureTask(error);
        }];
        return task;
    }
}



@end
