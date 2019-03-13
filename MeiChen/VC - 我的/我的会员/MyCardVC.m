//
//  MyCardVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyCardVC.h"
#import "MemberCollView.h"
#import "MyCardTabView.h"

@interface MyCardVC () <CustomNavViewDelegate>

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) MemberCollView *collView;
@property (nonatomic, strong) MyCardTabView *tabbarView;
@end

@implementation MyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self BUildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UserData shareInstance] requestUserData:^(NSError *error) {
        if (error == nil) {
            
        }
        else {
            [self CustomNavView_LeftItem:nil];
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_collView.collection reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor blackColor];
    CGFloat screen_w = self.view.frame.size.width;
    CGFloat screen_h = self.view.frame.size.height;
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsWhiteBack];
    [self.navview RightItemIsExchange];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyVC_4", nil);
    self.navview.titleLab.textColor = [UIColor whiteColor];
    self.navview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navview];
    
    CGFloat y = CGRectGetMaxY(self.navview.frame)+10;
    _collView = [[MemberCollView alloc]initWithFrame:CGRectMake(0, y, screen_w, (202.0/375*screen_w)+10)];
    _collView.pagingEnabled = YES;
    _collView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collView];
    
    CGFloat y_2 = CGRectGetMaxY(_collView.frame)-20;
    self.tabbarView = [[MyCardTabView alloc]initWithFrame:CGRectMake(0, y_2, screen_w, 65.0/667.0*screen_h)];
    [self.view addSubview:self.tabbarView];
    
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
