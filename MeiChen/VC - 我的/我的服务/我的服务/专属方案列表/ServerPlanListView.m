//
//  ServerPlanListView.m
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServerPlanListView.h"
#import "ServerPlanListCell.h"

@interface ServerPlanListView () <UITableViewDelegate, UITableViewDataSource>{
    CGRect oldFrame;
    CGRect newFrame;
    NSIndexPath *SelIndexPath;
    NetWork *net;
    BOOL loadFail;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ServerPlanListView

- (instancetype)init {
    self = [super init];
    if (self) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat screen_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat screen_h = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = screen_w * (250.0/375.0);
        CGFloat height = screen_h;
        self.backgroundColor = [UIColor whiteColor];
        self.m_array = [NSMutableArray array];
        loadFail = NO;
        net = [[NetWork alloc]init];
        [self requestServerPlanListData];
        
        oldFrame = CGRectMake(screen_w, 0, width, screen_h);
        newFrame = CGRectMake(screen_w-width, 0, width, screen_h);
        self.frame = oldFrame;
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screen_w, screen_h)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, statusRect.size.height+33, width, 25)];
        self.titleLab.text = NSLocalizedString(@"ServersVC_11", nil);
        self.titleLab.textColor = kColorRGB(0x333333);
        self.titleLab.font = [UIFont boldSystemFontOfSize:24];
        [self addSubview:self.titleLab];
        
        CGFloat y = CGRectGetMaxY(self.titleLab.frame) + 20;
        self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,height - y} style:(UITableViewStylePlain)];
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.tag = 1;
        self.tabview.bounces = NO;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tabview];
    }
    return self;
}

- (void)settingCurrentIndexPathWith:(NSString *)order_id surgery_id:(NSString *)surgery_id {
    for (int i = 0; i < self.m_array.count; i ++) {
        SideBarModel *model = self.m_array[i];
        if ([model.order_id isEqualToString:order_id]) {
            for (int j = 0; j < model.surgery.count; j ++) {
                SideBarSurgeryModel *surgery = model.surgery[j];
                if ([surgery.surgery_id isEqualToString:surgery_id]) {
                    SelIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [self.tabview reloadData];
                    return;
                }
            }
        }
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.m_array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SideBarModel *model = self.m_array[section];
    return model.surgery.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerPlanListCell *cell = [ServerPlanListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SideBarModel *model = self.m_array[indexPath.section];
    [cell loadData:model.surgery[indexPath.row]];
    if (SelIndexPath!=nil&&[SelIndexPath isEqual:indexPath]) {
        cell.backgroundColor = kColorRGB(0x7CE8EB);
        cell.icon.image = [UIImage imageNamed:@"手术白"];
        cell.name.textColor = [UIColor whiteColor];
        cell.detail.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.icon.image = [UIImage imageNamed:@"手术灰"];
        cell.name.textColor = kColorRGB(0x333333);
        cell.detail.textColor = kColorRGB(0xCCBB66);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
    
    SideBarModel *model = self.m_array[section];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, vi.frame.size.width, vi.frame.size.height)];
    lab.text = model.title;
    lab.textColor = kColorRGB(0x999999);
    lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    
    [vi addSubview:lab];
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SelIndexPath = indexPath;
    SideBarModel *model = self.m_array[indexPath.section];
    [self.tabview reloadData];
    if (self.index) {
        self.index(model.surgery[indexPath.row]);
    }
    [self hide];
}


- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    if (loadFail) {
        [self requestServerPlanListData];
    }
    [window addSubview:self.backButton];
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = newFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
    [self.tabview reloadData];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = oldFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backButton removeFromSuperview];
    }];
}

#pragma mark - 网络请求专属方案数据
- (void)requestServerPlanListData {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    [net requestWithUrl:@"follow/side-bar" Parames:m_dic Success:^(id responseObject) {
        [self ParsingServerPlanListData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}
// 获取专属方案数据 - 成功
- (void)requestSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        loadFail = NO;
        [self.tabview reloadData];
    });
}
// 获取专属方案数据 - 失败
- (void)requestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        loadFail = YES;
        [self hide];
    });
}

#pragma mark - 解析数据
// 1、解析专属方案数据
- (void)ParsingServerPlanListData:(id)responseObject {
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
                SideBarListModel *model = [MTLJSONAdapter modelOfClass:[SideBarListModel class] fromJSONDictionary:responseObject error:nil];
                self.m_array = [NSMutableArray arrayWithArray:model.data];
                [self requestSuccess];
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
        [self requestFail:error];
    });
}


- (void)HideMethod:(UIButton *)sender {
    [self hide];
}

@end
