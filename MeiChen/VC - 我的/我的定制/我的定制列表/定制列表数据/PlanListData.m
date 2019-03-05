//
//  PlanListData.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanListData.h"

@interface PlanListData () {
    NetWork *net;
    NSInteger OnePageCount;
}
@property (nonatomic, strong) NSMutableArray<NSArray<SinglePlanModel *> *> *listArray_1;
@property (nonatomic, copy) NSArray<SinglePlanModel *> *listArray_2;
@end

@implementation PlanListData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;
        _listArray_1 = [NSMutableArray array];
        _listArray_2 = @[];
    }
    return self;
}

#pragma mark - 获取 定制列表 数据
- (NSInteger)numbersOfRow {
    return _listArray_2.count;
}
- (SinglePlanModel *)ItemWithRow:(NSInteger)row {
    return _listArray_2[row];
}



#pragma mark - 获取定制列表数据
- (void)requestPlanListData:(NSString *)page {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    NSInteger k = 1;
    if (page != nil || self.listArray_1.count == 0) {
        k = 1;
    }
    else {
        NSArray *arr = [self.listArray_1 lastObject];
        k = arr.count < OnePageCount?(self.listArray_1.count):(self.listArray_1.count+1);
    }
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",k];
    NSLog(@"定制列表数据 request = %@",m_dic);
    [net requestWithUrl:@"former/my-listing" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"定制列表数据 = %@",responseObject);
        [self ParsingPlanListData:responseObject page:k];
    } Failure:^(NSError *error) {
        [self requestPlanListFail:error];
    }];
}
// 获取定制列表数据 - 成功
- (void)requestPlanListSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_PlanListData_Success)]) {
            [self.delegate request_PlanListData_Success];
        }
    });
}
// 获取定制列表数据 - 失败
- (void)requestPlanListFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_PlanListData_Fail:)]) {
            [self.delegate request_PlanListData_Fail:error];
        }
    });
}





#pragma mark - 解析数据
// 1、解析定制列表数据
- (void)ParsingPlanListData:(id)responseObject page:(NSInteger)page {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                PlanListModel *model = [MTLJSONAdapter modelOfClass:[PlanListModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    [self requestPlanListSuccess];
                    NSLog(@"model == nil");
                    return ;
                }
                if (model.data == nil) {
                    NSLog(@"model.data == nil");
                    model.data = [NSArray array];
                }
                NSMutableArray *newArr = [NSMutableArray arrayWithArray:model.data];
                
                NSMutableArray *m_arr = [NSMutableArray arrayWithArray:_listArray_1];
                if (page >= m_arr.count) {
                    [m_arr addObject:newArr];
                }
                else {
                    [m_arr replaceObjectAtIndex:(page - 1) withObject:newArr];
                }
                
                NSMutableArray *m_new = [NSMutableArray array];
                for (int i = 0; i < m_arr.count; i ++) {
                    NSArray *arr = m_arr[i];
                    [m_new addObjectsFromArray:arr];
                }
                _listArray_1 = [NSMutableArray arrayWithArray:m_arr];
                _listArray_2 = [NSArray arrayWithArray:m_new];
                [self requestPlanListSuccess];
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
        [self requestPlanListFail:error];
    });
}

@end
