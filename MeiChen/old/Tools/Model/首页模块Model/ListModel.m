//
//  ListModel.m
//  meirong
//
//  Created by yangfeng on 2018/12/11.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

+ (ListModel *)ListModelWithDictionary:(NSDictionary *)diction {
    ListModel *model = [[ListModel alloc]init];
    
    if ([[self class] Dictionary:diction key:@"sample_id"]) {
        model.sample_id = [NSString stringWithFormat:@"%@",diction[@"sample_id"]];
    }
    
    if ([[self class] Dictionary:diction key:@"member_id"]) {
        model.member_id = [NSString stringWithFormat:@"%@",diction[@"member_id"]];
    }
    
    if ([[self class] Dictionary:diction key:@"cover_img"]) {
        model.cover_img = [NSString stringWithFormat:@"%@",diction[@"cover_img"]];
    }
    
    if ([[self class] Dictionary:diction key:@"member"]) {
        id obj = diction[@"member"];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            model.member = [MemberModel MemberModelWithDictionary:obj];
        }
    }
    
    return model;
}

+ (BOOL)Dictionary:(NSDictionary *)dictionary key:(NSString *)key {
    if (dictionary != nil && [[dictionary allKeys] containsObject:key]) {
        return YES;
    }
    return NO;
}

@end
