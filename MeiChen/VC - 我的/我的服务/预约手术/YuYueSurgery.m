//
//  YuYueSurgery.m
//  meirong
//
//  Created by yangfeng on 2019/3/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "YuYueSurgery.h"
#import "ServersVC.h"
#import "YuYueSurgeryView.h"

@interface YuYueSurgery () <CustomNavViewDelegate> {
    NetWork *net;
}

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) YuYueSurgeryView *surgeryview;
@end

@implementation YuYueSurgery

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self BUildUI];
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"YuYueSurgery_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    CGFloat y = CGRectGetMaxY(self.navview.frame);
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    self.surgeryview = [[YuYueSurgeryView alloc]initWithFrame:CGRectMake(0, y, width, height-y)];
    [self.view addSubview:self.surgeryview];
}
#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    if (self.fromSuccessVC) {
        ServersVC *vc = [[ServersVC alloc]init];
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;         //改变视图控制器出现的方式
        transition.subtype = kCATransitionFromLeft; //出现的位置
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
