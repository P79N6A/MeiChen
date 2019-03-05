//
//  PlanCustomizeVCData.m
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanCustomizeVCData.h"

@interface PlanCustomizeVCData () {
    NetWork *net;
    NSInteger OnePageCount;
}

// 所有风格的照片
@property (nonatomic, strong) NSMutableArray<NSArray<ImageModel *> *> *ListArrays;


@end


@implementation PlanCustomizeVCData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        
        _styleArray = [NSArray array];
        _topcatArray = [NSArray array];
        _currentStyleIndex = 0;
        _currentTopCatIndex = 0;
        
        _ListArrays = [NSMutableArray array];
        
        _selectModels = [NSMutableArray array];
    }
    return self;
}


#pragma mark - 二、数据读取
// 读取风格的模特数据
- (NSArray *)readImageModelData {
    return _ListArrays[self.currentStyleIndex];
}
// 读取模特图片模型
- (ImageModel *)readImageModel:(NSInteger)row {
    NSArray *arr = _ListArrays[self.currentStyleIndex];
    return arr[row];
}
// 选择一个模特图片模型
- (void)SelectImageModel:(NSInteger)row {
    ImageModel *model = [self readImageModel:row];
    [_selectModels addObject:model];
}
// 删除一个模特图片模型
- (void)DeleteImageModel:(NSInteger)row {
    ImageModel *model = [self readImageModel:row];
    [_selectModels removeObject:model];
}
// 获取选择的模特模型indexPath
- (NSArray<NSIndexPath *> *)selectImageModelIndexPath:(NSArray *)array {
    NSArray *arr = _ListArrays[self.currentStyleIndex];
    NSMutableArray *m_arr = [NSMutableArray array];
    for (ImageModel *model in array) {
        if ([arr containsObject:model]) {
            NSInteger row = [arr indexOfObject:model];
            NSLog(@"row = %ld",row);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [m_arr addObject:indexPath];
        }
    }
    NSLog(@"m_arr = %@",m_arr);
    return m_arr;
}


#pragma mark - 一、数据下载
// 下载 风格/部位 数据
- (void)requestStyleTopCatData {
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    [net requestWithUrl:@"former/tag-listing" Parames:nil Success:^(id responseObject) {
        [self ParsingStyleTopCatData:responseObject];
    } Failure:^(NSError *error) {
        [self RequestStyleTopCatFail:error];
    }];
}
// 下载 模特图片 数据
- (void)requestModelListData:(BOOL)first {
    
    NSInteger k1 = self.currentStyleIndex;
    NSInteger k2 = self.currentTopCatIndex;
    
    PlanStyleModel *styleModel = _styleArray[k1];
    PlanStyleModel *topcatModel = _topcatArray[k2];
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"style_tag_id"] = topcatModel.tag_id;
    m_dic[@"part_tag_id"] = styleModel.tag_id;
    NSInteger page;
    if (self.ListArrays.count == 0 || self.ListArrays.count < self.currentStyleIndex) {
        page = 1;
    }
    else {
        NSArray *arr = self.ListArrays[k1];
        NSInteger shang = arr.count / OnePageCount;
        NSInteger yushu = arr.count % OnePageCount;
        if (yushu == 0 || shang == 0) {
            page = shang + 1;
        }
        else {
            page = shang;
        }
    }
    if (page == 0 || first) {
        page = 1;
    }
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",(long)page];
    
    NSLog(@"下载模特数据 m_dic = %@",m_dic);
    [net requestWithUrl:@"former/tag-find" Parames:m_dic Success:^(id responseObject) {
        [self ParsingModelListData:responseObject style:k1 page:page];
    } Failure:^(NSError *error) {
        [self RequestModelListFail:error];
    }];
}

#pragma mark - 方法 一、
#pragma mark - 1-1
// 1-1、请求 风格/部位 数据 成功
- (void)RequestStyleTopCatSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_StyleTopCat_success)]) {
            [self.delegate request_StyleTopCat_success];
        }
    });
}
// 1-2、请求 风格/部位 数据 失败
- (void)RequestStyleTopCatFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_StyleTopCat_fail:)]) {
            [self.delegate request_StyleTopCat_fail:error];
        }
    });
}
// 1-3、解析 风格/部位 数据
- (void)ParsingStyleTopCatData:(id)responseObject {
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
                if ([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"<null>"]) {
                    [self RequestStyleTopCatFail:nil];
                    return;
                }
                PlanModel *model = [MTLJSONAdapter modelOfClass:[PlanModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    NSLog(@"model == nil");
                    return ;
                }
                NSMutableArray *m_style = [NSMutableArray array];
                NSMutableArray *m_part = [NSMutableArray array];
                for (int i = 0; i < model.data.count; i ++) {
                    PlanStyleModel *mo = model.data[i];
                    if ([mo.tag_type isEqualToString:@"style"]) {
                        [m_style addObject:mo];
                    }
                    else if ([mo.tag_type isEqualToString:@"part"]) {
                        [m_part addObject:mo];
                    }
                }
                _styleArray = [NSArray arrayWithArray:m_style];
                _topcatArray = [NSArray arrayWithArray:m_part];
                
                _ListArrays = [NSMutableArray array];
                for (int i = 0; i < _styleArray.count; i ++) {
                    [_ListArrays addObject:@[]];
                }
                [self RequestStyleTopCatSuccess];
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
        [self RequestStyleTopCatFail:error];
    });
}

#pragma mark - 2-1
// 2-1、请求 模特数据 成功
- (void)RequestModelListSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_ModelList_success)]) {
            [self.delegate request_ModelList_success];
        }
    });
}
// 2-2、请求 模特数据 失败
- (void)RequestModelListFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request_ModelList_fail:)]) {
            [self.delegate request_ModelList_fail:error];
        }
    });
}
// 2-3、 解析 模特列表数据 数据
- (void)ParsingModelListData:(id)responseObject style:(NSInteger)style page:(NSInteger)page {
    NSLog(@"模特列表数据 = %@",responseObject);
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                PlanImagesModel *model = [MTLJSONAdapter modelOfClass:[PlanImagesModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil) {
                    NSLog(@"model == nil");
                    return ;
                }
                if (model.data == nil) {
                    NSLog(@"model.data == nil");
                    model.data = [NSArray array];
                }
                NSMutableArray *newArr = [NSMutableArray arrayWithArray:model.data];
                for (int i = 0; i < newArr.count; i ++) {
                    ImageModel *model = newArr[i];
                    model.row = (page - 1) * OnePageCount + i;
                    [newArr replaceObjectAtIndex:i withObject:model];
                }
                
                NSArray *styleArr = _ListArrays[style];
                NSMutableArray *m_arr = [NSMutableArray arrayWithArray:styleArr];
                
                if (m_arr.count == 0) {
                    [m_arr addObjectsFromArray:newArr];
                }
                else {
                    // 从m_arr中移除 page 页的数据
                    if (m_arr.count > page * OnePageCount) {
                        // 说明page页的数据在数组中间
                        [m_arr removeObjectsInRange:NSMakeRange((page - 1) * OnePageCount, OnePageCount)];
                        // 往m_arr中插入 page 页的数据
                        [m_arr insertObjects:newArr atIndexes:[NSIndexSet indexSetWithIndex:(page - 1) * OnePageCount]];
                    }
                    else if (m_arr.count > (page - 1) * OnePageCount &&
                             m_arr.count < (page) * OnePageCount) {
                        // 说明更新数据
                        // 说明page页的数据在数组末尾
                        [m_arr removeObjectsInRange:NSMakeRange((page - 1) * OnePageCount, m_arr.count)];
                        // 往m_arr中添加 page 页的数据
                        [m_arr addObjectsFromArray:newArr];
                    }
                    else {
                        // 往m_arr中添加 page 页的数据
                        [m_arr addObjectsFromArray:newArr];
                    }
                }
                [_ListArrays replaceObjectAtIndex:style withObject:m_arr];
                [self RequestModelListSuccess];
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
        [self RequestModelListFail:error];
    });
}

#pragma mark - 3-1
// 3-1、判断风格的模特数据是否需要下载，如果需要就下载
- (BOOL)isNeedToDowmloadStyleData:(NSInteger)style {
    NSArray *arr = _ListArrays[style];
    if (arr.count > 0) {
        return NO;
    }
    return YES;
}
// 3-2、切换风格
- (void)switchoverStyle:(NSInteger)style {
    _currentStyleIndex = style;
}
// 3-3、清空选择的模特图片
- (void)CleanData {
    _selectModels = [NSMutableArray array];
    for (int i = 0; i < _ListArrays.count; i ++) {
        [_ListArrays replaceObjectAtIndex:i withObject:@[]];
    }
}
// 3-4、切换部位
- (void)switchoverTopCat:(NSInteger)topcat {
    _currentTopCatIndex = topcat;
}


@end
