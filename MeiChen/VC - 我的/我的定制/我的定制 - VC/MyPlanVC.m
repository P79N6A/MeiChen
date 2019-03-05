//
//  MyPlanVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanVC.h"

@interface MyPlanVC () <CustomNavViewDelegate> {
    NetWork *net;
}

@property (nonatomic, strong) CustomNavView *navview;
@end

@implementation MyPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self requestMyPlanDetailWithImitate_id:self.imitate_id];
    [self CreateUI];
}



#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"PlanListVC_5", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
}

#pragma mark - 请求数据 - 下载详情
- (void)requestMyPlanDetailWithImitate_id:(NSString *)imitate_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"imitate_id"] = imitate_id;
    [net requestWithUrl:@"former/my-detail" Parames:m_dic Success:^(id responseObject) {
        [self ParsingPlanDetailData:responseObject];
    } Failure:^(NSError *error) {
        [self DownLoadMyPlanDetailFail:error];
    }];
    
}
// 下载定制详情 - 成功
- (void)DownLoadMyPlanDetailSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}
// 下载定制详情 - 失败
- (void)DownLoadMyPlanDetailFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - 解析数据
// 1、解析定制详细数据
- (void)ParsingPlanDetailData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                MyDZDetailModel *model = [MTLJSONAdapter modelOfClass:[MyDZDetailModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                if (model != nil) {
                    
                    [self DownLoadMyPlanDetailSuccess];
                    return;
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
        [self DownLoadMyPlanDetailFail:error];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
