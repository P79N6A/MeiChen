//
//  RecommendHomePageVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "RecommendHomePageVC.h"
#import "CustomHomeNavView.h"   // 推荐首页自定义导航视图
#import "TypeSegmentCVC.h"      // 分类选择集合视图控制器
#import "TabContentView.h"      // 分页控件
#import "RecommendHomePageData.h"   // 推荐首页数据
#import "WaterFlowCollectionVC.h"   // 瀑布流CollectionViewController

#import "SearchVC.h"            // 跳转到搜索页面
#import "AllMenuVC.h"           // 全部菜单页
#import "CaseVC.h"              // 案例详情页面
#import "ZanData.h"             // 点赞请求
#import "PlanCustomizeVC.h"     // 定制控制器

#import "WatingPlanVC.h"
#import "ExcSolDetailVC.h"

@interface RecommendHomePageVC () <CustomHomeNavViewDelegate, RecommendHomePageDataDelegate, UICollectionViewDelegate, ZanDataDelegate>

@property (nonatomic, strong) CustomHomeNavView *navView;
@property (nonatomic, strong) TypeSegmentCVC *typeSegCVC;
@property (nonatomic, strong) UIButton *TypeButton;
@property (nonatomic,strong) TabContentView *tabContent;
@property (nonatomic, strong) UIButton *reloadButton;

@property (nonatomic, strong) RecommendHomePageData *data;
@property (nonatomic, strong) ZanData *zandata;

@end

@implementation RecommendHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self RecommendHomePageVCLayout];
    
    // 下载热门数据
    self.data = [RecommendHomePageData shareInstance];
    self.data.delegate = self;
    __weak typeof(self) weakSelf = self;
    [self.data RequestHotCaseWithPull:^(NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 加载瀑布流
                [weakSelf loadWaterFlowCollectionVC];
                [weakSelf.typeSegCVC reloadTypeSegmentCVCData:[self.data MenuArray]];
            });
        }
    }];
    
    self.zandata = [[ZanData alloc]init];
    self.zandata.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushPlanCustomizeVC) name:@"Push__0" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // 判断是否需要弹出浮窗
    [[FloatWindows shareInstance] CanShowFloatingWindows];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat type_h = 44;
    self.typeSegCVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navView.frame), CGRectGetWidth(self.view.frame) - type_h / 1.5, type_h);
    self.TypeButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - type_h, self.typeSegCVC.view.frame.origin.y, type_h, type_h);
    CGFloat tab_y = CGRectGetMaxY(self.typeSegCVC.view.frame);
    self.tabContent.frame = CGRectMake(0, tab_y, CGRectGetWidth(self.view.frame), self.view.frame.size.height - tab_y);
    self.reloadButton.frame = CGRectMake(0, tab_y, CGRectGetWidth(self.view.frame), self.view.frame.size.height - tab_y);
}


#pragma mark - RecommendHomePageDataDelegate
- (void)RecommendHomePageData_HotData_Success {
    NSLog(@"热门数据下载 成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTabContentWithType:0];
    });
}
- (void)RecommendHomePageData_HotData_Fail:(NSError *)error {
    NSLog(@"热门数据下载 失败");
    if ([self.data IsNeedToShowReloadButton]) {
        self.reloadButton.hidden = NO;
    }
    else {
        self.reloadButton.hidden = YES;
    }
}
- (void)RecommendHomePageData_TypeData_Success:(NSInteger)type {
    NSLog(@"分类数据下载 成功");
    [self reloadTabContentWithType:type];
}
- (void)RecommendHomePageData_TypeData_Fail:(NSError *)error type:(NSInteger)type {
    NSLog(@"分类数据下载 失败");
}

- (void)RecommendHomePageData_UpdateFinishWithRow:(NSInteger)row type:(NSInteger)type {
    [self reloadZanWithRow:row type:type];
}

// 刷新瀑布流
- (void)reloadTabContentWithType:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id obj in self.tabContent.controllers) {
            if ([obj isKindOfClass:[WaterFlowCollectionVC class]]) {
                WaterFlowCollectionVC *vc = (WaterFlowCollectionVC *)obj;
                if (vc.collectionView.tag == type) {
                    [vc reloadWaterFlowCollectionVCData:[self.data TypeCaseArrayWith:type]];
                    break;
                }
            }
        }
    });
}

#pragma mark - 页面布局
- (void)RecommendHomePageVCLayout {
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationController.navigationBar.hidden = YES;
    
    // 导航视图
    self.navView = [[CustomHomeNavView alloc]init];
    self.navView.delegate = self;
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
    // 分类选择视图
    self.typeSegCVC = [[TypeSegmentCVC alloc]init];
    self.typeSegCVC.view.backgroundColor = [UIColor whiteColor];
    self.typeSegCVC.selectIndex = 0;
    [self addChildViewController:self.typeSegCVC];
    [self.view addSubview:self.typeSegCVC.view];
    __weak typeof(self) weakSelf = self;
    self.typeSegCVC.block = ^(NSInteger row) {
        NSLog(@"选择 item = %ld",row);
        [weakSelf.tabContent updateTab:row];
        // 判断是否需要下载
        [weakSelf.data DownLoadOneTypeData:row];
    };
    
    // 分类按钮
    self.TypeButton = [[UIButton alloc]init];
    [self.TypeButton setImage:[UIImage imageNamed:@"分类"] forState:(UIControlStateNormal)];
    [self.TypeButton addTarget:self action:@selector(TypeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.TypeButton];
    
    self.tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    self.tabContent.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.tabContent];
    
    // 重新加载按钮
    self.reloadButton = [[UIButton alloc]init];
    [self.reloadButton setImage:[UIImage imageNamed:@"加载失败"] forState:(UIControlStateNormal)];
    [self.reloadButton addTarget:self action:@selector(ReloadButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.reloadButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.reloadButton];
    self.reloadButton.hidden = YES;
}

// 加载瀑布流
- (void)loadWaterFlowCollectionVC {
    // 瀑布流
    NSMutableArray *contents = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < [self.data numbersOfMenuArrayRows]; i ++) {
        // 瀑布流
        WaterFlowCollectionVC *WaterFlowVC = [[WaterFlowCollectionVC alloc]init];
        WaterFlowVC.hasHeader = 0;
        WaterFlowVC.view.frame = CGRectMake(CGRectGetWidth(self.tabContent.frame) * i, 0, CGRectGetWidth(self.tabContent.frame), CGRectGetHeight(self.tabContent.frame));
        WaterFlowVC.view.tag = i;
        WaterFlowVC.collectionView.tag = i;
        WaterFlowVC.view.backgroundColor = [UIColor clearColor];
        WaterFlowVC.collectionView.delegate = self;
        WaterFlowVC.ZanSelect = ^(UIButton *sender) {
            ListModel *model = [self.data ListModelWithRow:sender.tag type:weakSelf.typeSegCVC.selectIndex];
            if (sender.selected) {
                // 取消点赞
                [weakSelf.zandata requestCancelZanWithId:model.sample_id type:@"sample" row:sender.tag type:weakSelf.typeSegCVC.selectIndex];
            }
            else {
                // 点赞
                [weakSelf.zandata requestZanWithId:model.sample_id type:@"sample" row:sender.tag type:weakSelf.typeSegCVC.selectIndex];
            }
        };
        [contents addObject:WaterFlowVC];
    }
    [self.tabContent configParam:contents Index:0 block:^(NSInteger index) {
        [self.data DownLoadOneTypeData:index]; // 判断是否需要下载
        self.typeSegCVC.selectIndex = index;
        [self.typeSegCVC.collectionView reloadData];
        [self.typeSegCVC.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    }];
    [self reloadTabContentWithType:0];
}

#pragma mark - ZanDataDelegate
// 点赞
- (void)ZanData_Zan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 成功");
    [self.data ZanSuccessWithRow:row type:type];
}
- (void)ZanData_Zan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 失败");
}
// 取消点赞
- (void)ZanData_CancelZan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 成功");
    [self.data CancelZanSuccessWithRow:row type:type];
}
- (void)ZanData_CancelZan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 失败");
}

#pragma mark - 刷新某个item的点赞
- (void)reloadZanWithRow:(NSInteger)row type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id obj in self.tabContent.controllers) {
            if ([obj isKindOfClass:[WaterFlowCollectionVC class]]) {
                WaterFlowCollectionVC *vc = (WaterFlowCollectionVC *)obj;
                if (vc.collectionView.tag == type) {
                    NSLog(@"刷新某个item的点赞 type = %ld, index = %ld", type, self.typeSegCVC.selectIndex);
                    [vc reloadWaterFlowCollectionVCData:[self.data TypeCaseArrayWith:type]];
                    break;
                }
            }
        }
    });
}

#pragma Mark - CustomHomeNavViewDelegate 协议方法
- (void)CustomHomeNavViewTouchUpInsideTextField {
    SearchVC *vc = [[SearchVC alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)CustomHomeNavViewTouchUpInsideRightItem:(UIButton *)sender {
    // 此功能待定
    [SVProgressHUD showImage:nil status:@"此功能待定"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    // 定制进度
//    WatingPlanVC *vc = [[WatingPlanVC alloc]init];
//    vc.fake_member_num = [[UserDefaults shareInstance] ReadRegisterNumber];
//    vc.fake_former_num = [[UserDefaults shareInstance] ReadPlanNumber];
    // 我的定制
//    MyPlanVC *vc = [[MyPlanVC alloc]init];
//
//    [vc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseVC *vc = [[CaseVC alloc]init];
    vc.listmodel = [self.data ListModelWithRow:indexPath.row type:self.typeSegCVC.selectIndex];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma Mark - 按钮方法
// 分类按钮方法
- (void)TypeButtonMethod:(UIButton *)sender {
    NSLog(@"TouchUpInside 分类按钮");
    AllMenuVC *vc = [[AllMenuVC alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
// 加载失败按钮方法
- (void)ReloadButtonMethod:(UIButton *)sender {
    NSLog(@"重新加载 热门数据");
    __weak typeof(self) weakSelf = self;
    [self.data RequestHotCaseWithPull:^(NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 加载瀑布流
                [weakSelf loadWaterFlowCollectionVC];
                [weakSelf.typeSegCVC reloadTypeSegmentCVCData:[self.data MenuArray]];
            });
        }
    }];
    self.reloadButton.hidden = YES;
}

#pragma mark - Push
- (void)PushPlanCustomizeVC {
    PlanCustomizeVC *planVC = [[PlanCustomizeVC alloc]init];
    [planVC setHidesBottomBarWhenPushed:YES];
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;         //新的视图把旧的视图掩盖
    transition.subtype = kCATransitionFromTop; //出现的位置
//    transition.duration = 5.0;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];// kCATransition
    [self.navigationController pushViewController:planVC animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
