//
//  ExchangeView_1.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeView_1.h"
#import "ExchViewCell_1.h"

@interface ExchangeView_1 () <UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
    NSInteger pageCount;
}
@property (nonatomic, strong) NSMutableArray *m_array;
@end

@implementation ExchangeView_1

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeView_1" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.jifen = 0;
        net = [[NetWork alloc]init];
        pageCount = 10;
        self.m_array = [NSMutableArray array];
        
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
        // 下拉刷新
        [self addPullRefresh];
        // 上拉加载更多
        [self addPushRefresh];
        
        [self requestData:YES];
        
        [self loadLab_1:0];
        self.lab_2.text = NSLocalizedString(@"ExchangeVC_7", nil);
    }
    return self;
}

// 下拉刷新
- (void)addPullRefresh {
    self.tabview.mj_footer.ignoredScrollViewContentInsetBottom = KIsiPhoneX?34:0;
    // 下拉刷新
    MJYFGifHeader *header = [MJYFGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tabview.mj_header = header;
}

// 上拉加载更多
- (void)addPushRefresh {
    // 上拉刷新
    MJYFGifFooter *footer = [MJYFGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    self.tabview.mj_footer = footer;
}

// 下拉刷新
- (void)pullData {
    [self requestData:YES];
}

// 上拉加载更多
- (void)pushData {
    [self requestData:NO];
}

- (void)loadLab_1:(NSInteger)lab {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lab_1.text = [NSString stringWithFormat:@"%@ %ld %@",
                           NSLocalizedString(@"ExchangeVC_5", nil),
                           lab,
                           NSLocalizedString(@"ExchangeVC_6", nil)];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    ExchViewCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchViewCell_1" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:self.m_array[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 70;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 网络请求
- (void)requestData:(BOOL)first {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    NSInteger p = 1;
    if (!first) {
        NSInteger shang = self.m_array.count / pageCount;
        NSInteger yushu = self.m_array.count % pageCount;
        if (yushu == 0 || shang == 0) {
            p = shang + 1;
        }
        else {
            p = shang;
        }
        p = p==0?1:p;
    }
    m_dic[@"p"] = [NSString stringWithFormat:@"%ld",p];
    
    [net requestWithUrl:@"agent/points-listing" Parames:m_dic Success:^(id responseObject) {
        [self ParsingData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}

// 获取定制列表数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabview.mj_header endRefreshing];
        [self.tabview.mj_footer endRefreshing];
        [self.tabview reloadData];
    });
}
// 获取定制列表数据 - 失败
- (void)requestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabview.mj_header endRefreshing];
        [self.tabview.mj_footer endRefreshing];
        [self.tabview reloadData];
    });
}

#pragma mark - 解析数据
// 1、解析定制列表数据
- (void)ParsingData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
                case 0: {
                    [SVProgressHUD dismiss];
                    [Tools JumpToLoginVC:responseObject];
                    break;
                }
                case 1: {
                    JiFenModel *model = [MTLJSONAdapter modelOfClass:[JiFenModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                    if (model != nil) {
                        [SVProgressHUD dismiss];
                        self.jifen = model.commission_points;
                        [self loadLab_1:model.commission_points];
                        [self addArrayWith:model.commission_stream];
                        [self requestSuccess];
                        return ;
                    }
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
        [self requestFail:error];
    });
}

- (void)addArrayWith:(NSArray *)array {
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.m_array];
    
    NSMutableArray *agentArr = [NSMutableArray array];
    for (int i = 0; i < newArr.count; i++) {
        CommissionStreamModel *model = newArr[i];
        [agentArr addObject:model.commission.stream_id];
    }
    
    for (int i = 0; i < array.count; i ++) {
        CommissionStreamModel *model = array[i];
        if ([agentArr containsObject:model.commission.stream_id]) {
            NSInteger index = [agentArr indexOfObject:model.commission.stream_id];
            [newArr replaceObjectAtIndex:index withObject:model];
        }
        else {
            [newArr addObject:model];
        }
    }
    self.m_array = [NSMutableArray arrayWithArray:newArr];
}








@end
