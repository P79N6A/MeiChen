//
//  ReviewData.m
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ReviewData.h"

#define COMMENT_LIST @"sample/daily-comment-list"   // 评论列表
#define DOREVIEW @"sample/daily-do-comment"         // 评论

@interface ReviewData () {
    NSInteger OnePageCount;     // 每页的数据个数
    NetWork *net;
}
@property (nonatomic, strong) NSMutableArray<NSArray<reviewModel *> *> *array_1;
@property (nonatomic, copy) NSArray<reviewModel *> *array;
@end

@implementation ReviewData

- (instancetype)init {
    if (self = [super init]) {
        net = [[NetWork alloc]init];
        OnePageCount = 10;      // 一页十条数据
        _array = [NSArray array];
        _array_1 = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 评论数据 请求
// 请求评论数据
- (void)requestReviewData:(BOOL)update {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"foreign_id"] = self.dailyModel.daily_id;
    m_dic[@"type"] = @"sample_daily";
    NSArray *arr = [_array_1 lastObject];
    NSInteger page = arr.count < OnePageCount ? _array_1.count:_array_1.count + 1;
    if (page == 0) {
        page = 1;
    }
    if (update) {
        page = 1;
    }
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",page];
    NSLog(@"请求评论数据 = %@",m_dic);
    [net requestWithUrl:COMMENT_LIST Parames:m_dic Success:^(id responseObject) {
        NSLog(@"请求评论 = %@",responseObject);
        [self ParsingReviewData:responseObject page:page];
    } Failure:^(NSError *error) {
        [self requestReviewDataFail:error];
    }];
}
// 评论数据 请求 成功
- (void)requestReviewDataSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(RequestReviewData_Success)]) {
            [self.delegate RequestReviewData_Success];
        }
    });
}
// 评论数据 请求 失败
- (void)requestReviewDataFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(RequestReviewData_Fail:)]) {
            [self.delegate RequestReviewData_Fail:error];
        }
    });
}


#pragma mark - 提交评论/回复 请求
// 提交评论/回复
- (void)requestUploadReviewWithContent:(NSString *)content foreign_id:(NSString *)foreign_id replayId:(NSString *)replayId row:(NSInteger)row {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"content"] = [NSString stringWithFormat:@"%@",content];
    m_dic[@"foreign_id"] = foreign_id;
    if (replayId == nil || replayId.length > 0) {
        m_dic[@"pid"] =  replayId;
    }
    NSLog(@"m_dic 22= %@",m_dic);
    [net requestWithUrl:DOREVIEW Parames:m_dic Success:^(id responseObject) {
        NSLog(@"提交评论/回复 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            [self submitReviewDataSuccess:row];
        }
        else {
            NSString *mess = NSLocalizedString(@"svp_2", nil);
            if ([[responseObject allKeys] containsObject:@"message"]) {
                mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            }
            NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
            [self submitReviewDataFail:error];
        }
    } Failure:^(NSError *error) {
        [self submitReviewDataFail:error];
    }];
}
// 评论 成功
- (void)submitReviewDataSuccess:(NSInteger)row {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SubmitReview_Success:)]) {
            [self.delegate SubmitReview_Success:row];
        }
    });
}
// 评论 失败
- (void)submitReviewDataFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SubmitReview_Fail:)]) {
            [self.delegate SubmitReview_Fail:error];
        }
    });
}



#pragma mark - 解析评论数据
- (void)ParsingReviewData:(id)responseObject page:(NSInteger)page {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                revertArrayModel *model = [MTLJSONAdapter modelOfClass:[revertArrayModel class] fromJSONDictionary:responseObject error:nil];
                if (model == nil || model.data == nil) {
                    NSLog(@"revertArrayModel == nil");
                    return;
                }
                if (self.array_1.count < page) {
                    [self.array_1 addObject:model.data];
                }
                else {
                    [self.array_1 replaceObjectAtIndex:page - 1 withObject:model.data];
                }
                
                NSMutableArray *m_arr2 = [NSMutableArray array];
                for (int i = 0; i < self.array_1.count; i ++) {
                    [m_arr2 addObjectsFromArray:self.array_1[i]];
                }
                self.array = [NSArray arrayWithArray:m_arr2];
                [self requestReviewDataSuccess];
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
        [self requestReviewDataFail:error];
    });
}

#pragma mark - 计算cell高度
- (CGFloat)cellHeightWith:(NSInteger)row {
    
    reviewModel *model = [self modelWithRow:row];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGSize labSize = [Tools sizeWithFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14] maxSize:CGSizeMake(width - 12 * 2, MAXFLOAT) string:model.content];
    CGFloat lab_h = 16;
    if (labSize.height > 16) {
        lab_h = labSize.height;
    }
    
    if (model.sub == nil) {
        return 84 + lab_h + 15;
    }
    
    NSMutableAttributedString *attStr = [self AttributedStringWithModel:model.sub];
    CGSize attSize = [attStr boundingRectWithSize:CGSizeMake(width - 12 * 2 - 15 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat view_h = 44;
    if (attSize.height + 32 > view_h) {
        view_h = attSize.height + 32;
    }
    return 106 + lab_h + view_h;
}

- (NSMutableAttributedString *)AttributedStringWithModel:(revertModel *)model {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger gapTime = now - [model.create_at integerValue];
    NSString *timeStr;
    if (gapTime < 0) {
        timeStr = @"";
    }
    else {
        timeStr = [self timeStr:gapTime];
    }
    NSString *nickName = [NSString stringWithFormat:@"%@: ",model.member.nickname];
    NSString *content = [NSString stringWithFormat:@"%@",model.content];
    
    NSArray *colorArr = @[kColorRGB(0x333333),
                          kColorRGB(0x666666),
                          kColorRGB(0x999999)];
    NSArray *fontArr = @[[UIFont fontWithName:@"PingFang-SC-Medium" size:14],
                         [UIFont fontWithName:@"PingFang-SC-Medium" size:14],
                         [UIFont fontWithName:@"PingFang-SC-Medium" size:10]];
    NSArray *strArr = @[nickName, content, timeStr];
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@",nickName,content,timeStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < colorArr.count; i ++) {
        NSRange range = [string rangeOfString:strArr[i]];
        [attrStr addAttribute:NSFontAttributeName value:fontArr[i] range:range];
        [attrStr addAttribute:NSForegroundColorAttributeName value:colorArr[i] range:range];
    }
    return attrStr;
}

- (NSString *)timeStr:(NSInteger)gapTime {
    NSString *timeStr;
    if (gapTime < 60) {
        timeStr = NSLocalizedString(@"ReviewVC_5", @"刚刚");
    }
    else if (gapTime < 60 * 60) {
        NSInteger shang = gapTime / 60;
        NSInteger yushu = gapTime % 60;
        if (shang == 59 && yushu > 0) {
            timeStr = [NSString stringWithFormat:@"%d%@",1,NSLocalizedString(@"ReviewVC_7", @"多少小时前")];
        }
        else {
            timeStr = [NSString stringWithFormat:@"%ld%@",shang + 1,NSLocalizedString(@"ReviewVC_6", @"多少分钟前")];
        }
    }
    else if (gapTime < 24 * 60 * 60) {
        NSInteger shang = gapTime / 3600;
        NSInteger yushu = gapTime % 3600;
        if (shang == 23 && yushu > 0) {
            timeStr = [NSString stringWithFormat:@"%d%@",1,NSLocalizedString(@"ReviewVC_8", @"多少天前")];
        }
        else {
            timeStr = [NSString stringWithFormat:@"%ld%@",shang + 1,NSLocalizedString(@"ReviewVC_7", @"多少小时前")];
        }
    }
    else if (gapTime < 24 * 60 * 60 * 28) {
        NSInteger shang = gapTime / (24.0 * 60.0 * 60.0);
        timeStr = [NSString stringWithFormat:@"%ld%@",shang + 1,NSLocalizedString(@"ReviewVC_8", @"多少天前")];
    }
    else {
        timeStr = NSLocalizedString(@"ReviewVC_9", @"很久以前");
    }
    return [NSString stringWithFormat:@" %@",timeStr];
}

#pragma mark - 数据获取
- (NSInteger)numbersOfRows {
    return self.array.count;
}
- (reviewModel *)modelWithRow:(NSInteger)row {
    if (row < self.array.count) {
        return self.array[row];
    }
    return nil;
}

#pragma mark - 网络请求数据
- (void)CancelNetWork {
    [net cancelRequest];
}


@end
