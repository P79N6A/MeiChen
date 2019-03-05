//
//  AllMenuData.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AllMenuData.h"

#define CAT_LIST @"main/cat-list" // 分类菜单

@interface AllMenuData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}

@property (nonatomic, strong) AllMenuModel *allModel;

@end

@implementation AllMenuData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
    }
    return self;
}

#pragma mark - 读取数据
// 表视图数据
- (NSInteger)numOfTabRows {
    if (self.allModel == nil ||
        self.allModel.data == nil) {
        return 0;
    }
    return self.allModel.data.count;
}
- (NSString *)TitleWithTabRow:(NSInteger)row {
    ChildMenuModel *model = self.allModel.data[row];
    return model.title;
}

// 集合视图数据
- (NSInteger)numOfCollSections:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return 0;
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            return 1;
        }
        else {
            return model.sub.count;
        }
    }
}

- (NSInteger)numOfItemsInSection:(NSInteger)section tag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return 0;
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            return model.sub.count;
        }
        else {
            ChildMenuModel_2 *model_2_section = model.sub[section];
            if (model_2_section.sub == nil) {
                return 0;
            }
            return model_2_section.sub.count;
        }
    }
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return [NSString string];
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            ChildMenuModel_2 *model_2_row = model.sub[indexPath.row];
            return model_2_row.title;
        }
        else {
            ChildMenuModel_2 *model_2_section = model.sub[indexPath.section];
            
            ChildMenuModel_3 *model_3 = model_2_section.sub[indexPath.row];
            return model_3.title;
        }
    }
}

- (BOOL)collHaveHeaderWithTag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return NO;
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

- (NSString *)titleHeaderWith:(NSIndexPath *)indexPath tag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return [NSString string];
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            return [NSString string];
        }
        else {
            ChildMenuModel_2 *model_2_section = model.sub[indexPath.section];
            return model_2_section.title;
        }
    }
}

- (ChildMenuModel_2 *)HeaderModelWith:(NSInteger)section tag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return nil;
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            return nil;
        }
        else {
            ChildMenuModel_2 *model_2_section = model.sub[section];
            return model_2_section;
        }
    }
}

- (id)ItemModelWith:(NSIndexPath *)indexPath tag:(NSInteger)tag {
    ChildMenuModel *model = self.allModel.data[tag];
    if (model.sub == nil || model.sub.count == 0) {
        return nil;
    }
    else {
        ChildMenuModel_2 *model_2 = [model.sub firstObject];
        if (model_2.sub == nil) {
            ChildMenuModel_2 *model_2_row = model.sub[indexPath.row];
            return model_2_row;
        }
        else {
            ChildMenuModel_2 *model_2_section = model.sub[indexPath.section];
            
            ChildMenuModel_3 *model_3 = model_2_section.sub[indexPath.row];
            return model_3;
        }
    }
}

#pragma mark - 全部菜单 请求
- (void)requestAllMenu {
    [net requestWithUrl:CAT_LIST Parames:nil Success:^(id responseObject) {
        [self ParsingAllMenuData:responseObject];
    } Failure:^(NSError *error) {
        [self requestAllMenuFail:error];
    }];
}
//全部菜单 请求 成功
- (void)requestAllMenuSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(AllMenuData_requestSuccess)]) {
            [self.delegate AllMenuData_requestSuccess];
        }
    });
}
//全部菜单 请求 失败
- (void)requestAllMenuFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(AllMenuData_requestFail:)]) {
            [self.delegate AllMenuData_requestFail:error];
        }
    });
}

#pragma mark - 解析全部菜单数据
- (void)ParsingAllMenuData:(id)responseObject {
    NSLog(@"解析全部菜单数据 = %@",responseObject);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                AllMenuModel *model = [MTLJSONAdapter modelOfClass:[AllMenuModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    NSLog(@"AllMenuModel == nil");
                    return ;
                }
                self.allModel = model;
                [self requestAllMenuSuccess];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [self requestAllMenuFail:error];
    });
}

#pragma mark - 更新Model数据
- (void)updateAllMenuModel:(NSRange)range {
    NSRange dataRange = NSMakeRange(0, self.allModel.data.count);
    BOOL is_1 = NSLocationInRange(range.location, dataRange);
    BOOL is_2 = NSLocationInRange(range.location + range.length, dataRange);
    if (is_1 && is_2) {
        NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.allModel.data];
        [m_arr removeObjectsInRange:range];
        self.allModel.data = [NSArray arrayWithArray:m_arr];
    }
}

@end
