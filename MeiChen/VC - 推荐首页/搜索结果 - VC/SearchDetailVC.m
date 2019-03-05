//
//  SearchDetailVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SearchDetailVC.h"

#import "CustomSearchDetailNavView.h"   // 导航栏视图
#import "SearchDetailVCData.h"          // 搜索结果页数据
#import "WaterFlowCollectionVC.h"       // 瀑布流集合视图控制器
#import "ZanData.h"                     // 点赞请求
#import "CaseVC.h"                      // 案例详情页面

static NSString *identifier = @"HistoryCell";
static NSString *HeaderIdentifier = @"HistoryHeaderCell";

@interface SearchDetailVC () <UICollectionViewDelegate,CustomSearchDetailNavViewDelegate,SearchDetailVCDataDelegate,UIScrollViewDelegate,ZanDataDelegate> {
    
}
@property (nonatomic) CGRect statusRect;
@property (nonatomic, strong) CustomSearchDetailNavView *navView;
@property (nonatomic, strong) WaterFlowCollectionVC *waterFlowVC;
@property (nonatomic, strong) SearchDetailVCData *data;
@property (nonatomic, strong) ZanData *zandata;
@end

@implementation SearchDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[SearchDetailVCData alloc]init];
    self.data.delegate = self;
    
    self.zandata = [[ZanData alloc]init];
    self.zandata.delegate = self;
    
    switch (self.index) {
        case 1: {
            [self.data requestTagSearchDataWith:self.SearchText];
            break;
        }
        case 2: {
            [self.data requestTypeSearchDataWith:1 key:self.key val:self.val];
            break;
        }
        case 3: {
            [self.data requestTagSearchDataWith:self.searchTitle];
            break;
        }
        default:
            break;
    }
    [self SearchDetailVCLayout];
}


#pragma mark - SearchDetailVCDataDelegate
// 标签搜索
- (void)SearchDetailVCData_TagSearchRequest_Success {
    NSLog(@"标签搜索 成功");
    [self.waterFlowVC reloadWaterFlowCollectionVCData:[self.data AllSearchData]];
}
- (void)SearchDetailVCData_TagSearchRequest_Success_NotData {
    
}
- (void)SearchDetailVCData_TagSearchRequest_Fail:(NSError *)error {
    
}
// 分类数据
- (void)SearchDetailVCData_TypeSearchRequest_Success {
    NSLog(@"分类搜索 成功");
    [self.waterFlowVC reloadWaterFlowCollectionVCData:[self.data AllSearchData]];
}
- (void)SearchDetailVCData_TypeSearchRequest_Success_NotData {
    NSLog(@"分类搜索 成功 无数据");
    [self.waterFlowVC reloadWaterFlowCollectionVCData:[self.data AllSearchData]];
}
- (void)SearchDetailVCData_TypeSearchRequest_Fail:(NSError *)error {
    NSLog(@"分类搜索 成功 失败");
}

// 点赞更新完成
- (void)SearchDetailVCData_UpdateFinish:(NSInteger)row {
    [self reloadItemWith:row];
}


#pragma mark - CustomSearchDetailNavViewDelegate
// 点击返回按钮
- (void)CustomSearchDetailNavView_ClickedBackItem {
    [self popView:YES];
}
// 开始点击
- (void)CustomSearchDetailNavView_DidBeginClick {
    [self popView:NO];
}

- (void)popView:(BOOL)backItem {
    switch (self.index) {
        case 1: {
            CATransition* transition = [CATransition animation];
            transition.type = kCATransitionPush;         //改变视图控制器出现的方式
            transition.subtype = kCATransitionFromRight; //出现的位置
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            if (backItem) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            else {
                [self.navigationController popViewControllerAnimated:NO];
            }
            break;
        }
        default: {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

#pragma mark - UI
- (void)SearchDetailVCLayout {
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    // 导航栏
    self.navView = [[CustomSearchDetailNavView alloc]init];
    self.navView.delegate = self;
    self.navView.index = 2;
    self.navView.searchBar.text = self.SearchText;
    [self.view addSubview:self.navView];
    switch (self.index) {
        case 1: {
            self.navView.titleLab.text = self.SearchText;
            self.navView.searchBar.hidden = YES;
            self.navView.titleLab.hidden = NO;
            self.navView.line.hidden = NO;
            break;
        }
        case 2: {
            self.navView.titleLab.text = self.titleStr;
            self.navView.searchBar.hidden = YES;
            self.navView.titleLab.hidden = NO;
            self.navView.line.hidden = NO;
            break;
        }
        case 3: {
            self.navView.titleLab.text = self.searchTitle;
            self.navView.searchBar.hidden = YES;
            self.navView.titleLab.hidden = NO;
            self.navView.line.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    //
    self.statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.waterFlowVC = [[WaterFlowCollectionVC alloc]init];
    self.waterFlowVC.view.frame = self.view.frame;
    self.waterFlowVC.hasHeader = 1;
    self.waterFlowVC.collectionView.delegate = self;
    self.waterFlowVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:self.waterFlowVC];
    [self.view addSubview:self.waterFlowVC.view];
    [self.view sendSubviewToBack:self.waterFlowVC.view];
    
    __weak SearchDetailVC *weakSelf = self;
    self.waterFlowVC.scrollIndex = ^(CGFloat offset) {
        if (offset <= 0) {
            // 向下滑动
            weakSelf.navView.alpha = 1.0;
        }
        else if (offset > 0) {
            if (offset < weakSelf.statusRect.size.height) {
                weakSelf.navView.alpha = (weakSelf.statusRect.size.height - offset) / weakSelf.statusRect.size.height;
            }
            else {
                weakSelf.navView.alpha = 0;
            }
        }
    };
    self.waterFlowVC.ZanSelect = ^(UIButton *sender) {
        NSLog(@"点赞 = %ld",sender.tag);
        ListModel *model = [weakSelf.data ListModelWith:sender.tag];
        if (sender.selected) {
            // 取消点赞
            [weakSelf.zandata requestCancelZanWithId:model.sample_id type:@"sample" row:sender.tag type:0];
        }
        else {
            // 点赞
            [weakSelf.zandata requestZanWithId:model.sample_id type:@"sample" row:sender.tag type:0];
        }
    };
}

#pragma mark - ZanDataDelegate
// 点赞
- (void)ZanData_Zan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 成功");
    [self.data ZanSuccessWithRow:row];
}
- (void)ZanData_Zan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"点赞 失败");
}
// 取消点赞
- (void)ZanData_CancelZan_SuccessWithRow:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 成功");
    [self.data CancelZanSuccessWithRow:row];
}
- (void)ZanData_CancelZan_Fail:(NSError *)error row:(NSInteger)row type:(NSInteger)type {
    NSLog(@"取消点赞 失败");
}

- (void)reloadItemWith:(NSInteger)row {
    [UIView performWithoutAnimation:^{
        [self.waterFlowVC.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"跳转到案例详情页面");
    CaseVC *vc = [[CaseVC alloc]init];
    vc.listmodel = [self.data ListModelWith:indexPath.row];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
