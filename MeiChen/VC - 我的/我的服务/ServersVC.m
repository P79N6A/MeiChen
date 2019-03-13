//
//  ServersVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServersVC.h"

@interface ServersVC () <CustomNavViewDelegate>
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation ServersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self BUildUI];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat h_1 = (440.0/745.0)*height;
    CGFloat h_2 = height-h_1;
    
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, h_1)];
    self.headerView.image = [UIImage imageNamed:@"ServerHeaderImage"];
    [self.view addSubview:self.headerView];
    
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), width, h_2)];
    self.footerView.backgroundColor = kColorRGB(0xf0f0f0);
    [self.view addSubview:self.footerView];
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsWhiteBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ServersVC_1", nil);
    self.navview.titleLab.textColor = [UIColor whiteColor];
    self.navview.line.hidden = YES;
    self.navview.backgroundColor = kColorRGB(0x7CE8EB);
    [self.view addSubview:self.navview];
    
}
- (void)GradientLayerWithColors:(NSArray *)colors view:(UIView *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = colors;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    [view.layer addSublayer:gradient];
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
