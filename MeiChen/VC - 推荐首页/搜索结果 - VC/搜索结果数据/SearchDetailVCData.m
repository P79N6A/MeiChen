//
//  SearchDetailData.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SearchDetailVCData.h"

#define TAG_SAMPLE @"main/tag-sample"   // 标签搜索案例
#define CAG_SAMPLE @"main/cat-sample"   // 分类案例

#import "RecommendHomePageData.h"       // 主页数据

@interface SearchDetailVCData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}

@property (nonatomic, strong) NSMutableArray<NSArray<ListModel *> *> *SearchResultArray;
@property (nonatomic, strong) NSMutableArray<ListModel *> *AllArray;

@end

@implementation SearchDetailVCData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        
        // 搜索详情页数据
        _SearchResultArray = [NSMutableArray array];
        _AllArray = [NSMutableArray array];
    }
    return self;
}


// 搜索结果数据
- (NSArray *)AllSearchData {
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < _SearchResultArray.count; i ++) {
        NSArray *arr = _SearchResultArray[i];
        [m_arr addObjectsFromArray:arr];
    }
    _AllArray = [NSMutableArray arrayWithArray:m_arr];
    return m_arr;
}
- (ListModel *)ListModelWith:(NSInteger)row {
    return _AllArray[row];
}


#pragma mark - 点赞/取消点赞
// 点赞成功
- (void)ZanSuccessWithRow:(NSInteger)row {
    // 自增1
    ListModel *model = _AllArray[row];
    model.has_like = 1;
    model.like_num = [NSString stringWithFormat:@"%ld",([model.like_num integerValue] + 1)];
    [_AllArray replaceObjectAtIndex:row withObject:model];
    [self UpdateDataWithModel:model row:row];
}

// 取消点赞成功
- (void)CancelZanSuccessWithRow:(NSInteger)row {
    ListModel *model = _AllArray[row];
    model.has_like = 0;
    NSInteger k = [model.like_num integerValue] - 1;
    if (k < 0) {
        k = 0;
    }
    model.like_num = [NSString stringWithFormat:@"%ld",k];
    [_AllArray replaceObjectAtIndex:row withObject:model];
    [self UpdateDataWithModel:model row:row];
}
// 更新点赞数据
- (void)UpdateDataWithModel:(ListModel *)model row:(NSInteger)row {
    // 更新主页点赞数据
    [[RecommendHomePageData shareInstance] updateZanDataWith:model];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLock *lock = [NSLock new];
        [lock lock];
        for (int i = 0; i < _SearchResultArray.count; i ++) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_SearchResultArray[i]];
            for (int j = 0; j < arr.count; j ++) {
                ListModel *mo = arr[j];
                if ([mo.sample_id isEqualToString:model.sample_id]) {
                    [arr replaceObjectAtIndex:j withObject:model];
                    [_SearchResultArray replaceObjectAtIndex:i withObject:arr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_UpdateFinish:)]) {
                            [self.delegate SearchDetailVCData_UpdateFinish:row];
                        }
                    });
                    [lock unlock];
                    return;
                }
            }
        }
        [lock unlock];
    });
}

#pragma mark - 标签搜索 请求
// 标签搜索
- (void)requestTagSearchDataWith:(NSString *)text {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = @"1";
    m_dic[@"key_word"] = text;
    [net requestWithUrl:TAG_SAMPLE Parames:m_dic Success:^(id responseObject) {
        [self ParsingTagSearchData:responseObject page:1];
    } Failure:^(NSError *error) {
        [self requestTagSearchDataFail:error];
    }];
}
// 标签搜索 更多
- (void)requestTagSearchDataMoreWith:(NSString *)text {
    NSInteger page = self.SearchResultArray.count;
    if (page == 0) {
        page = 1;
    }
    else {
        NSArray *arr = [self.SearchResultArray lastObject];
        if (arr.count == OnePageCount) {
            page ++;
        }
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    m_dic[@"key_word"] = text;
    NSLog(@"");
    [net requestWithUrl:TAG_SAMPLE Parames:m_dic Success:^(id responseObject) {
        [self ParsingTagSearchData:responseObject page:page];
    } Failure:^(NSError *error) {
        [self requestTagSearchDataFail:error];
    }];
}

// 标签搜索 请求 成功
- (void)requestTagSearchDataSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TagSearchRequest_Success)]) {
            [self.delegate SearchDetailVCData_TagSearchRequest_Success];
        }
    });
}
// 标签搜索 请求 无数据
- (void)requestTagSearchDataSuccessNotData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TagSearchRequest_Success_NotData)]) {
            [self.delegate SearchDetailVCData_TagSearchRequest_Success_NotData];
        }
    });
}
// 标签搜索 请求 失败
- (void)requestTagSearchDataFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TagSearchRequest_Fail:)]) {
            [self.delegate SearchDetailVCData_TagSearchRequest_Fail:error];
        }
    });
}


#pragma mark - 分类搜索 请求
// 分类搜索
- (void)requestTypeSearchDataWith:(NSInteger)page key:(NSString *)key val:(NSString *)val {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    m_dic[@"key"] = key;
    m_dic[@"val"] = val;
    NSLog(@"分类搜索 请求 = %@",m_dic);
    [net requestWithUrl:CAG_SAMPLE Parames:m_dic Success:^(id responseObject) {
        [self ParsingTypeSearchData:responseObject page:page];
    } Failure:^(NSError *error) {
        [self requestTypeSearchDataFail:error];
    }];
}
// 分类搜索 更多
- (void)requestTypeSearchDataMoreWithKey:(NSString *)key val:(NSString *)val {
    NSInteger page = self.SearchResultArray.count;
    if (page == 0) {
        page = 1;
    }
    else {
        NSArray *arr = [self.SearchResultArray lastObject];
        if (arr.count == OnePageCount) {
            page ++;
        }
    }
    [self requestTypeSearchDataWith:page key:key val:val];
}

// 分类搜索 请求 成功
- (void)requestTypeSearchDataSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TypeSearchRequest_Success)]) {
            [self.delegate SearchDetailVCData_TypeSearchRequest_Success];
        }
    });
}
// 分类搜索 请求 成功 无数据
- (void)requestTypeSearchDataSuccessNotData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TypeSearchRequest_Success_NotData)]) {
            [self.delegate SearchDetailVCData_TypeSearchRequest_Success_NotData];
        }
    });
}
// 标签搜索 请求 失败
- (void)requestTypeSearchDataFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchDetailVCData_TypeSearchRequest_Fail:)]) {
            [self.delegate SearchDetailVCData_TypeSearchRequest_Fail:error];
        }
    });
}



#pragma mark - 解析 标签搜索 数据
- (void)ParsingTagSearchData:(id)responseObject page:(NSInteger)page {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                TypeModel *model = [MTLJSONAdapter modelOfClass:[TypeModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    NSLog(@"model == nil");
                    return ;
                }
                if (model.data != nil) {
                    if (_SearchResultArray.count <= 0) {
                        [_SearchResultArray addObject:model.data];
                    }
                    else {
                        [_SearchResultArray replaceObjectAtIndex:page - 1 withObject:model.data];
                    }
                    [self requestTagSearchDataSuccess];
                }
                else {
                    [self requestTagSearchDataSuccessNotData];
                }
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
        [self requestTagSearchDataFail:error];
    });
}


#pragma mark - 解析 分类搜索 数据
- (void)ParsingTypeSearchData:(id)responseObject page:(NSInteger)page {
    NSLog(@"解析 分类搜索 数据 = %@",responseObject);
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                TypeModel *model = [MTLJSONAdapter modelOfClass:[TypeModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    NSLog(@"model == nil");
                    return ;
                }
                if (model.data != nil) {
                    if (_SearchResultArray.count <= 0) {
                        [_SearchResultArray addObject:model.data];
                    }
                    else {
                        [_SearchResultArray replaceObjectAtIndex:page - 1 withObject:model.data];
                    }
                    [self requestTypeSearchDataSuccess];
                }
                else {
                    [self requestTypeSearchDataSuccessNotData];
                }
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
        [self requestTypeSearchDataFail:error];
    });
}

@end
