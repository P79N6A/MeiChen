//
//  OSSClientObj.h
//  meirong
//
//  Created by yangfeng on 2018/12/15.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliyunOSSUpload : NSObject

+ (instancetype)shareOSSClientObj;

- (void)setupEnvironment;

- (void)updateToALi:(NSData *)data imageName:(NSString *)imageName;

- (NSString *)dowmLoadURL;

@end
