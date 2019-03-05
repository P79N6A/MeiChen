//
//  MyOrderVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyOrderVC.h"

@interface MyOrderVC () <CustomNavViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabview;

@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self BUildUI];
}



#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat bu_h = 45;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyOrderVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,self.view.frame.size.height - y - bu_h} style:(UITableViewStylePlain)];
    //    self.tabview.delegate = self;
    //    self.tabview.dataSource = self;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabview];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
