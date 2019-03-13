//
//  MyShareVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareVC.h"
#import "MyShareView.h"
#import "MyShareCell.h"
#import "ExchangeVC.h"

@interface MyShareVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    CGFloat item_h;
    CGFloat item_w;
    CGFloat cell_h;
    CGFloat left;
    NetWork *net;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) ShareModel *data;
@property (nonatomic, strong) UIButton *duihuan;
@end

@implementation MyShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [SVProgressHUD show];
    [self requestData];
    [self CreateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    MyShareCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyShareCell" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return cell_h;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyShareVC_1", nil);
    self.navview.line.hidden = NO;
    [self.navview.rightItem setImage:[UIImage imageNamed:@"引荐"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.navview];
}
#pragma mark - 加载内容UI
- (void)loadContentView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navview.frame), width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navview.frame))];
    _scroll.backgroundColor = kColorRGB(0xf0f0f0);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    
    left = 12;
    item_w = (width-left*3)/2.0;
    item_h = item_w*(95.0/170.0);
    cell_h = 122;
    
    NSInteger count = self.data.share_minterms.count;
    if (count == 0) {
        count = 1;
    }
    NSInteger shang = count / 2;
    NSInteger yushu = count % 2;
    CGFloat share_h = yushu==0?(shang*(item_h+left)):((shang+1)*(item_h+left));
    
    MyShareView *shareview = [[MyShareView alloc]initWithFrame:CGRectMake(0, 0, width, 171+47+share_h)];
    [shareview loadData:self.data];
    [_scroll addSubview:shareview];
    
    if (self.data.share_minterms.count == 0) {
        self.duihuan = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(shareview.frame)-share_h,width,share_h)];
        [self loadDuiHuanTitle];
        self.duihuan.hidden = NO;
        [self.duihuan addTarget:self action:@selector(DuiHuanMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scroll addSubview:self.duihuan];
    }
    else {
        if (self.duihuan != nil) {
            self.duihuan.hidden = YES;
        }
    }
    
    NSInteger cellCount = 2;
    CGFloat tab_h = cellCount*cell_h;
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(shareview.frame)+10,width,tab_h} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:self.tabview];
    
    _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.tabview.frame));
}

#pragma mark - 去兑换
- (void)DuiHuanMethod:(UIButton *)sender {
    NSLog(@"去兑换");
    
}

// 可兑换积分
- (void)loadDuiHuanTitle {
    NSString *str_1 = NSLocalizedString(@"MyShareVC_23", nil);
    NSString *str_2 = NSLocalizedString(@"MyShareVC_24", nil);
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:str_1];
    [m_str appendString:str_2];
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:m_str];
    NSRange range = [m_str rangeOfString:str_2];
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x999999) range:NSMakeRange(0, m_str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, m_str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x21C9D9) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:range];
    
    [self.duihuan setAttributedTitle:attribut forState:(UIControlStateNormal)];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    ExchangeVC *vc = [[ExchangeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 网络请求
- (void)requestData {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    [net requestWithUrl:@"agent/main" Parames:m_dic Success:^(id responseObject) {
        [self ParsingData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}

// 获取数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadContentView];
    });
}
// 获取数据 - 失败
- (void)requestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self CustomNavView_LeftItem:nil];
    });
}

#pragma mark - 解析数据
// 1、解析数据
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
                    ShareModel *model = [MTLJSONAdapter modelOfClass:[ShareModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
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








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
