//
//  PhotosBrowserVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosBrowserVC.h"
#import "TabContentView.h"      // 分页控件
#import "OneImagesVC.h"

@interface PhotosBrowserVC () <UIScrollViewDelegate> {
    CGRect oldFrame;
    CGRect newFrame;
    NSInteger indexSelect;
    BOOL hiddenStatusBar;
}
@property (nonatomic,strong) TabContentView *tabContent;
@property (nonatomic, strong) UIView *navview;
@property (nonatomic, strong) UIButton *rightItem;
@end

@implementation PhotosBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
    
    [self LoadImageVC];
    
    //[self prefersStatusBarHidden];
    //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

/*
-(BOOL)prefersStatusBarHidden {
    return YES; //隐藏为YES，显示为NO
}
 */

- (void)LoadImageVC {
    NSInteger count = [self.data numbersOfRowIntSection:self.section];
    NSMutableArray *contents = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < count; i ++) {
        OneImagesVC *vc = [[OneImagesVC alloc]init];
        vc.view.tag = i;
        vc.asset = [self.data numberOfAssetWithSection:self.section row:i];
        vc.touch = ^{
            if (weakSelf.navview.frame.origin.y == oldFrame.origin.y) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.navview.frame = newFrame;
                }];
            }
            else if (weakSelf.navview.frame.origin.y == newFrame.origin.y) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.navview.frame = oldFrame;
                }];
            }
        };
        [contents addObject:vc];
    }
    indexSelect = self.row;
    [self reloadRightItem];
    [self.tabContent configParam:contents Index:self.row block:^(NSInteger index) {
        NSLog(@"index = %ld",index);
        indexSelect = index;
        [self reloadRightItem];
    }];
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    self.tabContent=[[TabContentView alloc]initWithFrame:self.view.frame];
    self.tabContent.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tabContent];
    
    oldFrame = CGRectMake(0, 0, statusRect.size.width, statusRect.size.height + 44);
    newFrame = CGRectMake(0, -(statusRect.size.height + 44), statusRect.size.width, statusRect.size.height + 44);
    self.navview = [[UIView alloc]initWithFrame:oldFrame];
    self.navview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.view addSubview:self.navview];
    
    UIButton *leftItem = [[UIButton alloc]initWithFrame:CGRectMake(0, statusRect.size.height, 44, 44)];
    [leftItem setImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(LeftItemMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navview addSubview:leftItem];
    
    CGFloat ri_w = 25;
    _rightItem = [[UIButton alloc]initWithFrame:CGRectMake(statusRect.size.width - 44, statusRect.size.height + (44 - ri_w) / 2.0, ri_w, ri_w)];
    [_rightItem addTarget:self action:@selector(RightItemMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    _rightItem.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightItem setBackgroundImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [_rightItem setBackgroundImage:[UIImage imageNamed:@"选择背景"] forState:UIControlStateSelected];
    _rightItem.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightItem.contentMode = UIViewContentModeScaleAspectFit;
    [self.navview addSubview:_rightItem];
}

- (void)LeftItemMethod:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RightItemMethod:(UIButton *)sender {
    [self.data selectImageWith:sender.selected section:self.section row:indexSelect];
    [self reloadRightItem];
    [self.data deleteIndexPathWith:sender.selected section:self.section row:indexSelect];
}

- (void)reloadRightItem {
    if ([self.data haveAssetInSection:self.section row:indexSelect]) {
        _rightItem.selected = YES;
        [_rightItem setTitle:[self.data titleButtonWithSection:self.section row:indexSelect] forState:UIControlStateSelected];
    }
    else {
        _rightItem.selected = NO;
        [_rightItem setTitle:nil forState:UIControlStateNormal];
    }
}

//- (void)RightItemTitleNotSelect {
//    [_rightItem setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
//    [_rightItem setTitle:@"" forState:UIControlStateNormal];
//}
//
//- (void)RightItemTitleDidSelect:(NSInteger)index {
//    [_rightItem setImage:[UIImage imageNamed:@"选择背景"] forState:UIControlStateNormal];
//    [_rightItem setTitle:[NSString stringWithFormat:@"%ld",index] forState:UIControlStateNormal];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
