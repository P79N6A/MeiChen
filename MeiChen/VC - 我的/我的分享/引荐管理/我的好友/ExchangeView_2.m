//
//  ExchangeView_2.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeView_2.h"
#import "ExchViewCell_2.h"
#import "ProView.h"

@interface ExchangeView_2 () <UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
    NSInteger pageCount;
}
@property (nonatomic, strong) NSMutableArray *m_array;
@property (nonatomic, strong) FriendModel *data;
@property (nonatomic, strong) ProView *pro;

@end


@implementation ExchangeView_2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeView_2" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        net = [[NetWork alloc]init];
        pageCount = 10;
        self.m_array = [NSMutableArray array];
        
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
        
        self.pro = [[ProView alloc]initWithFrame:CGRectMake(0, 0, self.proView.frame.size.width, self.proView.frame.size.height)];
        [self.proView addSubview:self.pro];
        
        [self.pro settingProgressValue:0];
        [self settingLab:@"0"];
        
        [self requestData:YES];
    }
    return self;
}

// 已引荐 83 人
- (void)settingLab:(NSString *)str {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:NSLocalizedString(@"ExchangeVC_15", nil)];
    [m_str appendString:@" "];
    [m_str appendString:str];
    [m_str appendString:@" "];
    [m_str appendString:NSLocalizedString(@"ExchangeVC_13", nil)];
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:m_str];
    NSRange range = [m_str rangeOfString:str];
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x333333) range:NSMakeRange(0, m_str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] range:NSMakeRange(0, m_str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x418DD9) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:range];
    self.lab.attributedText = attribut;
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.friends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    ExchViewCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchViewCell_2" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:self.data.friends[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 70;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadData {
    self.pro.lab_1.text = self.data.grade_info.current_grage.grade_title;
    self.pro.lab_2.text = self.data.grade_info.next_grage.grade_title;
    
    self.pro.value_1.text = self.data.grade_info.current_grage.min_heads;
    self.pro.value_2.text = self.data.grade_info.next_grage.min_heads;
    
    NSInteger min = [self.data.grade_info.current_grage.min_heads integerValue];
    NSInteger max = [self.data.grade_info.current_grage.max_heads integerValue];
    
    CGFloat proVal = (self.data.commission_num_indirect-min)/1.0/(max-min);
    
    [self.pro settingProgressValue:proVal];
    [self settingLab:[NSString stringWithFormat:@"%ld",self.data.commission_num_indirect]];
}

#pragma mark - 网络请求
- (void)requestData:(BOOL)first {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    
    [net requestWithUrl:@"agent/friends-listing" Parames:m_dic Success:^(id responseObject) {
        [self ParsingData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}

// 获取定制列表数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
        [self.tabview reloadData];
    });
}
// 获取定制列表数据 - 失败
- (void)requestFail:(NSError *)error {

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
                    FriendModel *model = [MTLJSONAdapter modelOfClass:[FriendModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                    if (model != nil) {
                        [SVProgressHUD dismiss];
                        self.data = model;
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

@end
