//
//  NSString+RandomString.m
//  meirong
//
//  Created by yangfeng on 2019/1/23.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "NSString+RandomString.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>

@implementation NSString (RandomString)

+ (NSString *)randomString:(NSInteger)length {
    length = length/2;
    unsigned char digest[length];
    CCRNGStatus status = CCRandomGenerateBytes(digest, length);
    NSString *s = nil;
    if (status == kCCSuccess) {
        s = [self stringFrom:digest length:length];
    } else {
        s = @"";
    }
    return s;
}
+ (NSString *)stringFrom:(unsigned char *)digest length:(NSInteger)leng {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < leng; i++) {
        [string appendFormat:@"%02x",digest[i]];
    }
    return string;
}

@end
