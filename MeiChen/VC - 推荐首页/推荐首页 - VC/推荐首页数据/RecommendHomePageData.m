//
//  RecommendHomePageData.m
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "RecommendHomePageData.h"

#define MAIN_INDEX @"main/index"    // 热门案例
#define CAG_SAMPLE @"main/cat-sample"   // 分类案例

@interface RecommendHomePageData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}
@property (nonatomic, strong) NSMutableArray<MenuModel *> *menuArray;
@property (nonatomic, strong) NSMutableArray<NSArray<NSArray<ListModel *> *> *> *listArray;
@property (nonatomic, strong) NSMutableArray<NSArray<ListModel *> *> *lists;

@end

@implementation RecommendHomePageData

+ (instancetype)shareInstance {
    static RecommendHomePageData *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[RecommendHomePageData alloc]init];
    });
    return tools;
}

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        _menuArray = [NSMutableArray array];
        _listArray = [NSMutableArray array];
    }
    return self;
}


// 判断是否需要下载分类数据,如果需要则下载
- (void)DownLoadOneTypeData:(NSInteger)index {
    NSInteger count = _listArray.count;
    if (count <= index) {
        NSLog(@"没有数据，需要下载 = %ld",(long)index);
        [self RequestTypeCaseWithPullWithType:index callback:^(NSError *error) {
            
        }];
        return;
    }
    else {
        NSLog(@"下拉加载更多数据 = %ld",(long)index);
        [self RequestTypeCaseWithPushWithType:index callback:^(NSError *error) {
            
        }];
    }
}

// 判断是否需要弹出提示重新加载的提示
- (BOOL)IsNeedToShowReloadButton {
    if (_menuArray == nil ||
        _menuArray.count <= 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 点赞/取消点赞
// 点赞成功
- (void)ZanSuccessWithRow:(NSInteger)row type:(NSInteger)type {
    ListModel *model = [self ListModelWithRow:row type:type];
    model.has_like = 1;
    model.like_num = [NSString stringWithFormat:@"%ld",([model.like_num integerValue] + 1)];
    [self updateZanDataWith:model];
}

// 取消点赞成功
- (void)CancelZanSuccessWithRow:(NSInteger)row type:(NSInteger)type {
    ListModel *model = [self ListModelWithRow:row type:type];
    model.has_like = 0;
    NSInteger k = [model.like_num integerValue] - 1;
    if (k < 0) {
        k = 0;
    }
    model.like_num = [NSString stringWithFormat:@"%ld",k];
    [self updateZanDataWith:model];
}

#pragma mark - 更新主页点赞数据
- (void)updateZanDataWith:(ListModel *)model {
    NSLog(@"更新主页点赞数据");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLock *lock = [NSLock new];
        [lock lock];
        
        NSMutableArray *m_indexPath = [NSMutableArray array];
        
        // self.lists
        NSInteger sameCount = 0;
        for (int i = 0; i < self.lists.count; i ++) {
            NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.lists[i]];
            for (int j = 0; j < m_arr.count; j ++) {
                ListModel *mo = m_arr[j];
                // 如果两个案例的id相同，则为同一案例
                if ([model.sample_id isEqualToString:mo.sample_id]) {
                    // 1、更新 lists 中的数据
                    // 替换
                    [m_arr replaceObjectAtIndex:j withObject:model];
                    [self.lists replaceObjectAtIndex:i withObject:m_arr];
//                    NSLog(@"更新点赞数据 1 row = %d, type = %d",j, i);
                    // 2、更新 listArray 中的数据
                    NSMutableArray *m_arr_1 = [NSMutableArray arrayWithArray:self.listArray[i]];
                    NSInteger same = 0;
                    for (int k = 0; k < m_arr_1.count; k ++) {
                        NSMutableArray *m_arr_2 = [NSMutableArray arrayWithArray:m_arr_1[k]];
                        for (ListModel *m in m_arr_2) {
                            if ([m.sample_id isEqualToString:model.sample_id]) {
                                NSInteger index = [m_arr_2 indexOfObject:m];
                                [m_arr_2 replaceObjectAtIndex:index withObject:model];
                                [m_arr_1 replaceObjectAtIndex:k withObject:m_arr_2];
                                [self.listArray replaceObjectAtIndex:i withObject:m_arr_1];
                                same = 1;
                                break;
                            }
                        }
                        if (same == 1) {
                            break;
                        }
                    }
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [m_indexPath addObject:indexPath];
                    
                    // 相同的案例自加1
                    sameCount ++;
                    break;
                }
            }
            if (sameCount >= 2) {
                break;
            }
        }
        for (NSIndexPath *indexPath in m_indexPath) {
            [self updateFinishWithRow:indexPath.row type:indexPath.section];
        }
        [lock unlock];
    });
}

- (void)updateFinishWithRow:(NSInteger)row type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendHomePageData_UpdateFinishWithRow:type:)]) {
            [self.delegate RecommendHomePageData_UpdateFinishWithRow:row type:type];
        }
    });
}



#pragma mark - 读取 分类菜单数据
- (NSInteger)numbersOfMenuArrayRows {
    return _menuArray.count;
}
- (MenuModel *)MenuModelWithRow:(NSInteger)row {
    return _menuArray[row];
}
- (NSArray *)MenuArray {
    return _menuArray;
}

#pragma mark - 读取 分类数据
- (NSArray<ListModel *> *)TypeCaseArrayWith:(NSInteger)type {
    NSLog(@"type = %ld, count = %ld",type,[self.lists[type] count]);
    return self.lists[type];
}
- (ListModel *)ListModelWithRow:(NSInteger)row type:(NSInteger)type {
    NSArray<ListModel *> *arr = [self TypeCaseArrayWith:type];
    if (row < arr.count) {
        return arr[row];
    }
    return nil;
}


#pragma mark - 热门数据
// 下拉加载热门数据
- (void)RequestHotCaseWithPull:(void (^)(NSError *error))callback {
    [self requestHotTypeWithPage:1 callback:^(NSError *error) {
        callback(error);
    }];
}
// 上拉加载更多热门数据
- (void)RequestHotCaseWithPush:(void (^)(NSError *error))callback {
    // 计算需要加载的页数
    NSArray *arr = [_lists firstObject];
    NSInteger shang = arr.count / OnePageCount;
    NSInteger yushu = arr.count % OnePageCount;
    NSInteger count = yushu==0?(shang+1):shang;
    if (count == 0) {
        count = 1;
    }
    NSLog(@"上拉加载更多热门数据 count = %ld",count);
    [self requestHotTypeWithPage:count callback:^(NSError *error) {
        callback(error);
    }];
}


#pragma mark - 分类数据
// 下拉加载分类数据
- (void)RequestTypeCaseWithPullWithType:(NSInteger)type callback:(void (^)(NSError *error))callback {
    [self requestTypeCaseWithPage:1 Type:type callback:^(NSError *error) {
        callback(error);
    }];
}
// 上拉加载更多分类数据
- (void)RequestTypeCaseWithPushWithType:(NSInteger)type callback:(void (^)(NSError *error))callback {
    // 计算需要加载的页数
    if (type >= _listArray.count) {
        return;
    }
    NSArray *arr = _lists[type];
    NSInteger shang = arr.count / OnePageCount;
    NSInteger yushu = arr.count % OnePageCount;
    NSInteger count = yushu==0?(shang+1):shang;
    if (count == 0) {
        count = 1;
    }
    [self requestTypeCaseWithPage:count Type:type callback:^(NSError *error) {
        callback(error);
    }];
}

#pragma mark - 分类数据 - 请求
// 请求 推荐首页 分类案例
- (void)requestTypeCaseWithPage:(NSInteger)page Type:(NSInteger)type callback:(void (^)(NSError *error))callback {
    MenuModel *menumodel = [self MenuModelWithRow:type];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    m_dic[@"key"] = menumodel.key;
    m_dic[@"val"] = [NSString stringWithFormat:@"%@",menumodel.val];
    [net requestWithUrl:CAG_SAMPLE Parames:m_dic Success:^(id responseObject) {
        [self ParsingTypeCaseData:responseObject page:page type:type callback:^(NSError *error) {
            callback(error);
        }];
    } Failure:^(NSError *error) {
        [self RequestTypeDataFail:error type:type];
        callback(error);
    }];
}

// 请求 推荐首页 分类数据 成功
- (void)RequestTypeDataSuccess:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendHomePageData_TypeData_Success:)]) {
        [self.delegate RecommendHomePageData_TypeData_Success:index];
    }
}

// 请求 推荐首页 分类数据 失败
- (void)RequestTypeDataFail:(NSError *)error type:(NSInteger)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendHomePageData_TypeData_Fail:type:)]) {
        [self.delegate RecommendHomePageData_TypeData_Fail:error type:type];
    }
}

#pragma mark - 热门数据 - 请求
// 请求 推荐首页 热门案例
- (void)requestHotTypeWithPage:(NSInteger)page callback:(void (^)(NSError *error))callback {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    [net requestWithUrl:MAIN_INDEX Parames:m_dic Success:^(id responseObject) {
        [self ParsingHotTypeData:responseObject page:page callback:^(NSError *error) {
            callback(error);
        }];
    } Failure:^(NSError *error) {
        [self RequestHotDataFail:error];
        callback(error);
    }];
}

// 请求 推荐首页 热门数据 成功
- (void)RequestHotDataSuccess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendHomePageData_HotData_Success)]) {
        [self.delegate RecommendHomePageData_HotData_Success];
    }
}

// 请求 推荐首页 热门数据 失败
- (void)RequestHotDataFail:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendHomePageData_HotData_Fail:)]) {
        [self.delegate RecommendHomePageData_HotData_Fail:error];
    }
}

#pragma mark - 解析 推荐首页 热门数据
- (void)ParsingHotTypeData:(id)responseObject page:(NSInteger)page callback:(void (^)(NSError *error))callback {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                if ([Tools JumpToLoginVC:responseObject]) {
                    [SVProgressHUD dismiss];
                }
                break;
            }
            case 1: {
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                HotModel *model = [MTLJSONAdapter modelOfClass:[HotModel class] fromJSONDictionary:[data mutableCopy] error:nil];
                if (model == nil) {
                    callback(nil);
                    return;
                }
                // 分类菜单数据
                _menuArray = [NSMutableArray arrayWithArray:model.menu];
                // 热门数据
                [self replaceDataWithPage:page type:0 objs:model.list];
                callback(nil);
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
        [self RequestHotDataFail:error];
        callback(error);
    });
}

#pragma mark - 解析 推荐首页 分类数据
- (void)ParsingTypeCaseData:(id)responseObject page:(NSInteger)page type:(NSInteger)type callback:(void (^)(NSError *error))callback {
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
                    callback(nil);
                    return ;
                }
                // 分类数据
                [self replaceDataWithPage:page type:type objs:model.data];
                callback(nil);
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
        [self RequestTypeDataFail:error type:type];
        callback(error);
    });
}

#pragma mark - 替换/添加 推荐首页 x分类y页 的数据
- (void)replaceDataWithPage:(NSInteger)page type:(NSInteger)type objs:(NSArray *)objs {
    if (objs == nil || objs.count <= 0) {
        return;
    }
    NSMutableArray<ListModel *> *m_list = [NSMutableArray arrayWithArray:objs];
    
    NSLog(@"加载前的个数_1 = %ld",m_list.count);
    
    NSMutableArray *_m_listArrays = [NSMutableArray arrayWithArray:_listArray];
    NSMutableArray *_menuArr = [_menuArray copy];
    
    if (_m_listArrays.count < _menuArr.count) {
        NSMutableArray<NSArray<NSArray<ListModel *> *> *> *m_array = [NSMutableArray array];
        for (int i = 0; i < _menuArr.count; i ++) {
            @autoreleasepool {
                [m_array addObject:@[]];
            }
        }
        _m_listArrays = [NSMutableArray arrayWithArray:m_array];
    }
    
    if (_m_listArrays.count > type) {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_m_listArrays[type]];
        if (newArr.count < page) {
            for (NSInteger i = newArr.count; i < page; i ++) {
                [newArr addObject:@[]];
            }
        }
        [newArr replaceObjectAtIndex:page - 1 withObject:m_list];
        [_m_listArrays replaceObjectAtIndex:type withObject:newArr];
    }
    
    NSArray<NSArray<ListModel *> *> *array1 = _m_listArrays[type];
    NSMutableArray<ListModel *> *m_arr1 = [NSMutableArray array];
    
    _listArray = _m_listArrays;
    
    for (int i = 0; i < array1.count; i ++) {
        [m_arr1 addObjectsFromArray:array1[i]];
    }
    
    NSMutableArray *m_li = [NSMutableArray arrayWithArray:_lists];
    if (m_li.count < _m_listArrays.count) {
        for (NSInteger i = m_li.count; i < _m_listArrays.count; i ++) {
            [m_li addObject:@[]];
        }
    }
    [m_li replaceObjectAtIndex:type withObject:m_arr1];
    
    _lists = [NSMutableArray arrayWithArray:m_li];
    
    
    NSArray *ar_l = [_lists firstObject];
    
    NSLog(@"加载后的个数_2 = %ld",ar_l.count);
    
    if (type == 0) {
        [self RequestHotDataSuccess];
    }
    else {
        [self RequestTypeDataSuccess:type];
    }
}


@end
