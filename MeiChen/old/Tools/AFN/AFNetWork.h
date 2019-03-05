//
//  AFNetWork.h
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFNetWork : NSObject

+ (NSURLSessionDataTask *)RequestWith:(NSString *)method url:(NSString *)url Parames:(NSMutableDictionary *)parames File:(NSString *)file Success:(void (^)(id responseObject))successTask Failure:(void (^)(NSError *error))failureTask;

@end
