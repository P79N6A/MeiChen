//
//  ThirdVC.m
//  meirong
//
//  Created by yangfeng on 2018/12/12.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "MyVC.h"
#import "PlanCustomizeVC.h"     // 定制控制器
#import "MyHeaderView.h"
#import "MyCell_1.h"
#import "MyCell_2.h"

#import "ExcSolVC.h"
#import "MyCardVC.h"
#import "PlanListVC.h"
#import "MyOrderVC.h"
#import "MyDiaryVC.h"
#import "SettingVC.h"
#import "MyShareVC.h"

@interface MyVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGRect originalFrame;
    CGFloat ratio;
    CGFloat cell_h;
}

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIImageView *backImv;
@property (nonatomic, strong) MyHeaderView *headerview;
@property (nonatomic, strong) UITableView *tabview_1;
@property (nonatomic, strong) UITableView *tabview_2;
@property (nonatomic, copy) NSArray *listNameArray;
@property (nonatomic, copy) NSArray *listImageArray;

@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushPlanCustomizeVC) name:@"Push__2" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerview LoadUserData];
}
    
#pragma mark - 创建UI
- (void)buildUI {
    UIColor *backColor = kColorRGB(0xf0f0f0);
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = backColor;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat tabbar_h = self.tabBarController.tabBar.bounds.size.height;
    CGFloat width = statusRect.size.width;
    CGFloat status_h = statusRect.size.height;
    ratio = (168.0f / 375.0f);
    CGFloat imv_h = ratio * width;
    originalFrame = (CGRect){0,0,width,imv_h};
    cell_h = 50;
    
    self.listNameArray = @[NSLocalizedString(@"MyVC_4", nil),
                       NSLocalizedString(@"MyVC_5", nil),
                       NSLocalizedString(@"MyVC_6", nil),
                       NSLocalizedString(@"MyVC_7", nil),
                       NSLocalizedString(@"MyVC_8", nil),
                       NSLocalizedString(@"MyVC_9", nil)];
    self.listImageArray = @[@"我的会员",@"我的定制",@"我的预约",@"我的日记本",@"金融服务",@"设置"];
    
    // 背景图片
    self.backImv = [[UIImageView alloc]initWithFrame:originalFrame];
    self.backImv.image = [UIImage imageNamed:@"我的背景"];
    self.backImv.contentMode = UIViewContentModeScaleAspectFit;
    self.backImv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backImv];
    
    // 滚动图
    self.scroll = [[UIScrollView alloc]initWithFrame:(CGRect){0,status_h,width,self.view.frame.size.height - tabbar_h - status_h}];
    self.scroll.delegate = self;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroll];
    
    // 头视图
    self.headerview = [[MyHeaderView alloc]init];
    [self.headerview LoadUserData];
    [self.headerview.bu_1 addTarget:self action:@selector(ExclusiveSolutionMethod) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headerview.bu_2 addTarget:self action:@selector(MyServerMethod) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headerview.share addTarget:self action:@selector(MyShareMethod) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scroll addSubview:self.headerview];
    
    // 表视图 1
    self.tabview_1 = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerview.frame), width, 150) style:(UITableViewStylePlain)];
    self.tabview_1.delegate = self;
    self.tabview_1.dataSource = self;
    self.tabview_1.tag = 1;
    self.tabview_1.bounces = NO;
    self.tabview_1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scroll addSubview:self.tabview_1];
    
    //
    UIView *vi_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabview_1.frame), width, 12)];
    vi_1.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:vi_1];
    
    // 表视图 2
    self.tabview_2 = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(vi_1.frame), width, cell_h * self.listImageArray.count) style:(UITableViewStylePlain)];
    self.tabview_2.delegate = self;
    self.tabview_2.dataSource = self;
    self.tabview_2.tag = 2;
    self.tabview_2.bounces = NO;
    self.tabview_2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scroll addSubview:self.tabview_2];
    
    //
    UIView *vi_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabview_2.frame), width, 60)];
    vi_2.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:vi_2];
    
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(vi_2.frame));
}

#pragma mark - 专属方案
- (void)ExclusiveSolutionMethod {
    ExcSolVC *vc = [[ExcSolVC alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 我的服务
- (void)MyServerMethod {
    
}
#pragma mark - 我的分享
- (void)MyShareMethod {
    MyShareVC *vc = [[MyShareVC alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        self.backImv.frame = ({
            CGRect frame = originalFrame;
            frame.origin.y = originalFrame.origin.y - yOffset;
            frame;
        });
    }
    else {
        self.backImv.frame = ({
            CGRect frame = originalFrame;
            frame.size.height = originalFrame.size.height - yOffset;
            frame.size.width = frame.size.height / ratio;
            frame.origin.x = originalFrame.origin.x - (frame.size.width - originalFrame.size.width) / 2.0;
            frame;
        });
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger k = 0;
    switch (tableView.tag) {
        case 1: {
            
            break;
        }
        case 2: {
            k = self.listImageArray.count;
            break;
        }
        default:
            break;
    }
    return k;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 1: {
            tableView.rowHeight = 150;
            MyCell_1 *cell = [MyCell_1 cellWithTableView:tableView];
            return cell;
            break;
        }
        case 2: {
            tableView.rowHeight = cell_h;
            MyCell_2 *cell = [MyCell_2 cellWithTableView:tableView];
            [cell loadDataWithImage:self.listImageArray[indexPath.row] name:self.listNameArray[indexPath.row]];
            if (self.listNameArray.count == indexPath.row + 1) {
                cell.line.hidden = YES;
            }
            else {
                cell.line.hidden = NO;
            }
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 1: {
            
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    MyCardVC *vc = [[MyCardVC alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1: {
                    PlanListVC *vc = [[PlanListVC alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 2: {
                    MyOrderVC *vc = [[MyOrderVC alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 3: {
                    MyDiaryVC *vc = [[MyDiaryVC alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 4: {
                    
                    break;
                }
                case 5: {
                    SettingVC *vc = [[SettingVC alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}




#pragma mark - Push
- (void)PushPlanCustomizeVC {
    PlanCustomizeVC *planVC = [[PlanCustomizeVC alloc]init];
    [planVC setHidesBottomBarWhenPushed:YES];
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;         //新的视图把旧的视图掩盖
    transition.subtype = kCATransitionFromTop; //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:planVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
