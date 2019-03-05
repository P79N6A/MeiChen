//
//  ExchangeJiFenVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeJiFenVC.h"
#import "ExchangeRecordVC.h"

@interface ExchangeJiFenVC () <CustomNavViewDelegate>
@property (nonatomic, strong) CustomNavView *navview;
@end

@implementation ExchangeJiFenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
}



#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsRecord];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ExchangeJiFenVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    NSLog(@"记录");
    ExchangeRecordVC *vc = [[ExchangeRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
