//
//  ExchangeVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeVC.h"
#import "ExchangeJiFenVC.h"
#import "UIImage+ImgSize.h"
#import "ExchangeView_1.h"
#import "ExchangeView_2.h"

@interface ExchangeVC () <CustomNavViewDelegate>
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) ExchangeView_1 *view_1;
@property (nonatomic, strong) ExchangeView_2 *view_2;
@end

@implementation ExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsDuiHuan];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ExchangeVC_1", nil);
    [self.view addSubview:self.navview];
    
    NSArray *segArr = @[NSLocalizedString(@"ExchangeVC_3", nil),
                        NSLocalizedString(@"ExchangeVC_4", nil),];
    self.segment = [[UISegmentedControl alloc]initWithItems:segArr];
    self.segment.frame = CGRectMake(0, CGRectGetMaxY(self.navview.frame), self.view.frame.size.width, 40);
    [self.segment addTarget:self action:@selector(SegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.segment.layer.borderWidth = 0.1;
    self.segment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segment.selectedSegmentIndex = 0;
    self.segment.backgroundColor = [UIColor whiteColor];
    self.segment.tintColor = [UIColor whiteColor];
    
    // 已选择
    NSDictionary *dic_1 = [NSDictionary dictionaryWithObjectsAndKeys:kColorRGB(0x333333), NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:16],NSFontAttributeName,nil];
    [self.segment setTitleTextAttributes:dic_1 forState:UIControlStateSelected];
    // 未选择
    NSDictionary *dic_2 = [NSDictionary dictionaryWithObjectsAndKeys:kColorRGB(0x999999), NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:16],NSFontAttributeName,nil];
    [self.segment setTitleTextAttributes:dic_2 forState:UIControlStateNormal];
    
    [self.view addSubview:self.segment];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), self.view.frame.size.width, 1.0)];
    line.backgroundColor = kColorRGB(0xf0f0f0);
    [self.view addSubview:line];
    
    // 我的积分
    CGFloat y = CGRectGetMaxY(line.frame);
    CGRect vi_fr = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y);
    self.view_1 = [[ExchangeView_1 alloc]initWithFrame:vi_fr];
    [self.view addSubview:self.view_1];
    
    // 我的好友
    self.view_2 = [[ExchangeView_2 alloc]initWithFrame:vi_fr];
    self.view_2.hidden = YES;
    [self.view addSubview:self.view_2];
}

#pragma mark - 分类选择器
- (void)SegmentedControl:(UISegmentedControl *)seg {
    switch (seg.selectedSegmentIndex) {
        case 0: {
            self.view_1.hidden = NO;
            self.view_2.hidden = YES;
            break;
        }
        case 1: {
            self.view_1.hidden = YES;
            self.view_2.hidden = NO;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    ExchangeJiFenVC *vc = [[ExchangeJiFenVC alloc]init];
    vc.jifen = self.view_1.jifen;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
