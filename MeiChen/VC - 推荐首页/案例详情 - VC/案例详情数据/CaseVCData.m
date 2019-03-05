//
//  CaseVCData.m
//  meirong
//
//  Created by yangfeng on 2019/1/10.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CaseVCData.h"

#define SAMPLE_DETAIL @"sample/detail" // 案例详情

@interface CaseVCData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
    BOOL order;
}
@property (nonatomic, strong) CaseDetailModel *detailModel;

// 正序数组
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, copy) NSArray *rowHeightArray;

@end

@implementation CaseVCData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        order = NO;
    }
    return self;
}


#pragma mark - 读取数据
- (NSInteger)numOfSections {
    return self.orderArray.count == 0? 1 : self.orderArray.count;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section {
    if (self.orderArray.count == 0) {
        return 0;
    }
    if (order) {
        NSArray *arr = self.orderArray[section];
        return arr.count;
    }
    else {
        NSArray *arr = self.orderArray[self.orderArray.count - section - 1];
        return arr.count;
    }
}
- (NSInteger)numbersWithModel:(DailyModel *)model  {
    NSInteger k = [self.detailModel.daily indexOfObject:model];
    return k + 1;
}
- (DailyModel *)DailyModelWithIndexPath:(NSIndexPath *)indexPath {
    if (self.orderArray.count == 0) {
        return nil;
    }
    DailyModel *model;
    if (order) {
        NSArray *arr = self.orderArray[indexPath.section];
        model = arr[indexPath.row];
    }
    else {
        NSArray *arr = self.orderArray[self.orderArray.count - indexPath.section - 1];
        model = arr[arr.count - indexPath.row - 1];
    }
    return model;
}
- (CGFloat)heightWithIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 163;
    if (order) {
        NSArray *arr = self.rowHeightArray[indexPath.section];
        h = [arr[indexPath.row] floatValue];
    }
    else {
        NSArray *arr = self.rowHeightArray[self.rowHeightArray.count - indexPath.section - 1];
        h = [arr[arr.count - indexPath.row - 1] floatValue];
    }
    return h;
}
- (CaseDetailModel *)CaseDetailModel {
    return self.detailModel;
}
- (void)ChangeTheOrder {
    order = !order;
}


#pragma mark - 更新点赞数据
// 点赞成功
- (void)UpdateZanDataWith:(NSIndexPath *)indexPath {
    DailyModel *oldModel = [self DailyModelWithIndexPath:indexPath];
    DailyModel *newModel = [oldModel copy];
    newModel.has_like = 1;
    NSInteger k = [newModel.like_num integerValue];
    newModel.like_num = [NSString stringWithFormat:@"%ld",k+1];
    [self UpdateDataWithOld:oldModel newModel:newModel indexPath:indexPath];
}

// 取消点赞
- (void)UpdateCancelZanDataWith:(NSIndexPath *)indexPath {
    DailyModel *oldModel = [self DailyModelWithIndexPath:indexPath];
    DailyModel *newModel = [oldModel copy];
    newModel.has_like = 0;
    NSInteger k = [newModel.like_num integerValue];
    if (k <= 0) {
        k = 0;
    }
    else {
        k --;
    }
    newModel.like_num = [NSString stringWithFormat:@"%ld",k];
    [self UpdateDataWithOld:oldModel newModel:newModel indexPath:indexPath];
}

- (void)UpdateDataWithOld:(DailyModel *)oldModel newModel:(DailyModel *)newModel indexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLock *lock = [NSLock new];
        [lock lock];
        // 修改 detailModel 中的数据
        NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.detailModel.daily];
        NSInteger index = [m_arr indexOfObject:oldModel];
        [m_arr replaceObjectAtIndex:index withObject:newModel];
        self.detailModel.daily = [NSArray arrayWithArray:m_arr];
        
        // 修改 orderArray 中的数据
        NSInteger same = 0;
        for (int i = 0; i < self.orderArray.count; i ++) {
            NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.orderArray[i]];
            for (int j = 0; j < m_arr.count; j ++) {
                DailyModel *model = m_arr[j];
                if ([model.daily_id isEqualToString:oldModel.daily_id]) {
                    [m_arr replaceObjectAtIndex:j withObject:newModel];
                    [self.orderArray replaceObjectAtIndex:i withObject:m_arr];
                    same = 1;
                    break;
                }
            }
            if (same == 1) {
                break;
            }
        }
        [self updateFinish:indexPath];
        [lock unlock];
    });
}

// 更新数据完成
- (void)updateFinish:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(CaseVCData_UpdateFinish:)]) {
            [self.delegate CaseVCData_UpdateFinish:indexPath];
        }
    });
}

#pragma mark - 案例详情 请求
- (void)requestCaseDetailData {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"sample_id"] = self.listmodel.sample_id;
    [net requestWithUrl:SAMPLE_DETAIL Parames:m_dic Success:^(id responseObject) {
        [self ParsingCaseDetailData:responseObject];
    } Failure:^(NSError *error) {
        [self CaseDetailRequestFail:error];
    }];
}
// 案例详情 请求 成功
- (void)CaseDetailRequestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(CaseVCData_requestSuccess)]) {
            [self.delegate CaseVCData_requestSuccess];
        }
    });
}
// 案例详情 请求 失败
- (void)CaseDetailRequestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(CaseVCData_requestFail:)]) {
            [self.delegate CaseVCData_requestFail:error];
        }
    });
}

#pragma mark - 解析 案例详情 数据
- (void)ParsingCaseDetailData:(id)responseObject {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"案例详情 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                CaseDetailModel *model = [MTLJSONAdapter modelOfClass:[CaseDetailModel class] fromJSONDictionary:[data mutableCopy] error:nil];
                if (model == nil) {
                    NSLog(@"HotModel == nil");
                    return;
                }
                self.detailModel = model;
                [self groupDataWithModel:model];
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
        [self CaseDetailRequestFail:error];
    });
}

// 返回分组数组
- (void)groupDataWithModel:(CaseDetailModel *)models {
    NSMutableArray *m_yearArr = [NSMutableArray array];
    
    NSMutableArray *m_arrArr = [NSMutableArray array];
    NSMutableArray *m_arr = [NSMutableArray array];
    
    NSMutableArray *m_heiArr = [NSMutableArray array];
    NSMutableArray *m_hei = [NSMutableArray array];
    NSInteger count = models.daily.count;
    for (int i = 0; i < count; i ++) {
        if ([models.daily[i] isKindOfClass:[DailyModel class]]) {
            DailyModel *model = models.daily[i];
            NSString *yearStr = [self timeComponentsYear:[model.photo_at integerValue]];
            //如果年份包含在年份数组中
            if ([m_yearArr containsObject:yearStr]) {
                [m_arr addObject:model];
                CGFloat h = [self heightWithModel:model];
                [m_hei addObject:[NSNumber numberWithFloat:h]];
            }
            // 如果年份不在数组中
            else {
                // 将年份添加到年份数组中
                [m_yearArr addObject:yearStr];
                // 判断 数组列表是否有数据, 如果有,
                if (m_arr.count > 0) {
                    [m_arrArr addObject:[m_arr copy]];
                    m_arr = [NSMutableArray array];
                    
                    [m_heiArr addObject:[m_hei copy]];
                    m_hei= [NSMutableArray array];
                }
                // 将数据添加到数组中
                [m_arr addObject:model];
                CGFloat h = [self heightWithModel:model];
                [m_hei addObject:[NSNumber numberWithFloat:h]];
            }
            
            if (i == count - 1) {
                if (m_arr.count > 0) {
                    [m_arrArr addObject:m_arr];
                    [m_heiArr addObject:m_hei];
                }
            }
        }
    }
    
    self.orderArray  = [NSMutableArray arrayWithArray:m_arrArr];
    self.rowHeightArray = [NSArray arrayWithArray:m_heiArr];

    [self CaseDetailRequestSuccess];
}

// 获取年份
- (NSString *)timeComponentsYear:(NSInteger)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%4ld",(long)comps.year];
}

// 获取高度
- (CGFloat)heightWithModel:(DailyModel *)model {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 80;
    // 1
    CGSize labSize = [Tools sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width, MAXFLOAT) string:model.brief];
    CGFloat h_1 = 18;
    if (labSize.height > h_1) {
        h_1 = labSize.height;
    }
    
    // 2
    CGFloat gap = 5.0;
    CGFloat h_2 = 2.0 * (width - gap * 2) / 3.0 + 5;
    if (model.photos.count == 4) {
        h_2 = width;
    }
    else if (model.photos.count == 5) {
        h_2 += ((width - gap) / 2.0) + gap;
    }
    else if (model.photos.count >= 6){
        h_2 += ((width - gap * 2) / 3.0);
    }
    CGFloat h = 145 + h_1 + h_2;
    return h;
}

@end
