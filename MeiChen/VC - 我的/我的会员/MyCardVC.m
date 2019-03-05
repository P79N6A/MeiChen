//
//  MyCardVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyCardVC.h"

@interface MyCardVC () <CustomNavViewDelegate>

@property (nonatomic, strong) CustomNavView *navview;

@end

@implementation MyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self BUildUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor blackColor];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsWhiteBack];
    [self.navview RightItemIsExchange];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyVC_4", nil);
    self.navview.titleLab.textColor = [UIColor whiteColor];
    self.navview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navview];
    
//    CGFloat y = statusRect.size.height + 44;
    
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
