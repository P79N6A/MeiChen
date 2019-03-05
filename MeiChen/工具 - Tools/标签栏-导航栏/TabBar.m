//
//  TabBar.m
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "TabBar.h"
#import "RecommendHomePageVC.h"
#import "PlanCustomizeVC.h"
#import "MyVC.h"

@interface TabBar () {
    NSInteger tabTag;
}
@end

@implementation TabBar

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.tabBarItem.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"Push__%ld",tabTag] object:nil];
        return NO;
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 0:tabTag = 0; break;
        case 2:tabTag = 2; break;
        default:
            break;
    }
}



+ (void)initialize {
    // 获取当前类下所有的tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:m_dic forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // 改变tabar的颜色
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self setUpChildViewController];
}

#pragma mark - 添加TabBarItem上的子控件
- (void)setUpChildViewController {
    
    RecommendHomePageVC *first = [[RecommendHomePageVC alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:first];
    nav1.tabBarItem.tag = 0;
    [self OneChildViewController:nav1 image:[UIImage imageNamed:@"推荐首页_1"] selectedImage:[self imageWithOriginalName:@"推荐首页_2"] title:nil];
    
    UINavigationController *nav2 = [[UINavigationController alloc] init];
    nav2.tabBarItem.tag = 1;
    [self OneChildViewController:nav2 image:[UIImage imageNamed:@"方案定制_1"] selectedImage:[self imageWithOriginalName:@"方案定制_2"] title:nil];
    
    MyVC *third = [[MyVC alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:third];
    nav3.tabBarItem.tag = 2;
    [self OneChildViewController:nav3 image:[UIImage imageNamed:@"我的_1"] selectedImage:[self imageWithOriginalName:@"我的_2"] title:nil];
}

- (UIImage *)imageWithOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)OneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    if (title != nil) {
        viewController.tabBarItem.title = title;
    }
    else {
        CGFloat offset = 5.0;
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    [self addChildViewController:viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
