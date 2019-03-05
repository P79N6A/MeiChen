//
//  SearchData.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SearchVCData.h"

#define HIT_TAG @"main/hit-tag" // 热门搜索

@interface SearchVCData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *hotSearchArray;

// 搜索详情页数据
@property (nonatomic, strong) NSMutableArray<NSArray<ListModel *> *> *SearchResultArray;

@end

@implementation SearchVCData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        _historyArray = [NSMutableArray arrayWithArray:[[UserDefaults shareInstance] ReadSeacrhHistory]];
        _hotSearchArray = [NSMutableArray array];
        
        // 搜索详情页数据
        _SearchResultArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 读取 搜索页数据
- (NSInteger)numberOfSections {
    return 2;
}
- (NSInteger)numberOfRowsWithSection:(NSInteger)section {
    if (section == 0) {
        return _historyArray.count;
    }
    return _hotSearchArray.count;
}
- (NSString *)StringWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _historyArray[indexPath.row];
    }
    return _hotSearchArray[indexPath.row];
}

#pragma mark - 历史数据
// 删除
- (void)deleteHistoryData {
    [[UserDefaults shareInstance] CleanSeacrhHistory];
    _historyArray = [NSMutableArray array];
}
// 刷新
- (void)updateHistoryData {
    _historyArray = [NSMutableArray arrayWithArray:[[UserDefaults shareInstance] ReadSeacrhHistory]];
}
// 添加
- (void)addHistoryData:(NSString *)text {
    [[UserDefaults shareInstance] AddSeacrhHistoryWith:text];
    [self updateHistoryData];
}

#pragma mark - 热门搜索 请求
- (void)requestHotSearchData {
    [net requestWithUrl:HIT_TAG Parames:nil Success:^(id responseObject) {
        [self ParsingHotSearchData:responseObject];
    } Failure:^(NSError *error) {
        [self requestHotSearchDataFail:error];
    }];
}
// 热门搜索 请求 成功
- (void)requestHotSearchDataSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchVCData_HotSearchRequest_Success)]) {
            [self.delegate SearchVCData_HotSearchRequest_Success];
        }
    });
}
// 热门搜索 请求 失败
- (void)requestHotSearchDataFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchVCData_HotSearchRequest_Fail:)]) {
            [self.delegate SearchVCData_HotSearchRequest_Fail:error];
        }
    });
}


#pragma mark - 解析 热门搜索 数据
- (void)ParsingHotSearchData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                id obj = responseObject[@"data"];
                NSArray *data = [NSArray array];
                if ([obj isKindOfClass:[NSArray class]]) {
                    data = [NSArray arrayWithArray:obj];
                }
                _hotSearchArray = [NSMutableArray arrayWithArray:data];
                [self requestHotSearchDataSuccess];
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
        [self requestHotSearchDataFail:error];
    });
}


@end
