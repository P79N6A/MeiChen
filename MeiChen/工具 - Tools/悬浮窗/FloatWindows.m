//
//  FloatWindows.m
//  meirong
//
//  Created by yangfeng on 2019/1/29.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "FloatWindows.h"
#import "WatingPlanVC.h"

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3       //位置改变动画时间
#define left_gap 6 // 左右距离边缘的位置
#define top_gap 20  // 上下距离边缘的位置

@interface FloatWindows () {
    CGFloat floatWith;
    CGFloat float_gap;
    
    NSInteger start_Time;
    NSInteger gap_Time;
}
@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UIButton *mainImageButton;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FloatWindows

static FloatWindows *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
+ (instancetype)shareInstance {
    return [[self alloc]init];
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
//        self.windowLevel = UIWindowLevelAlert - 1;  //如果想在 alert 之上，则改成 + 2
//        self.rootViewController = [UIViewController new];
//        [self makeKeyAndVisible];
        
        floatWith = 60;
        float_gap = 9.0;//floatWith * (8.0 / 45.0);
        self.frame = (CGRect){kScreenWidth-left_gap-floatWith,kScreenHeight-kTabBarHeight-15-floatWith,floatWith,floatWith};
        
        CGRect rect = CGRectMake(0, 0, floatWith, floatWith);
        UIImageView *imv = [[UIImageView alloc]initWithFrame:rect];
        UIView *whiteView = [[UIView alloc]initWithFrame:imv.frame];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.shadowColor = [UIColor blackColor].CGColor;
        whiteView.layer.shadowOpacity = 0.3;
        whiteView.layer.shadowOffset = CGSizeMake(0,0);
        whiteView.layer.shadowRadius = 2;
        whiteView.clipsToBounds = NO;
        whiteView.layer.cornerRadius = floatWith / 2.0;
        [whiteView addSubview:imv];
        
        [self addSubview:whiteView];
        
        _mainImageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainImageButton setFrame:(CGRect){float_gap, float_gap,floatWith - float_gap * 2, floatWith - float_gap * 2}];
        [_mainImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mainImageButton.titleLabel.font = [UIFont boldSystemFontOfSize:8];
        [_mainImageButton setBackgroundImage:[UIImage imageNamed:@"闹钟"] forState:UIControlStateNormal];
        [_mainImageButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _mainImageButton.adjustsImageWhenHighlighted = NO;
        NSString *title = [self getTimeStr:0];
        [_mainImageButton setTitle:title forState:UIControlStateNormal];
        [self addSubview:_mainImageButton];
        
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        _pan.delaysTouchesBegan = NO;
        [self addGestureRecognizer:_pan];
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:_tap];
    }
    return self;
}

#pragma mark - 判断是否弹出浮窗
- (void)CanShowFloatingWindows {
    NSDictionary *dic = [[UserDefaults shareInstance] ReadPlanSettingData];
    NSLog(@"开始定制时间 = %@",dic);
    if (dic == nil) {
        [self dissmissWindow];
    }
    else {
        [self showWindow];
    }
}

- (void)dissmissWindow{
    self.hidden = YES;
    if (self.timer) {
        [self.timer invalidate];
    }
}
- (void)showWindow{
    self.hidden = NO;
    [self StartTimer];
}

- (void)StartTimer {
    NSDictionary *dic = [[UserDefaults shareInstance] ReadPlanSettingData];
    start_Time = [dic[@"nowTime"] integerValue];
    gap_Time = [dic[@"hour"] integerValue];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantPast]];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timeMethod {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSInteger gap = nowTime - start_Time;
    CGFloat k = gap / 1.0 / (gap_Time * 3600);
    if (k > 1) {
        [self.timer setFireDate:[NSDate distantFuture]];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [self getTimeStr:(gap_Time * 3600) - gap];
        [_mainImageButton setTitle:title forState:UIControlStateNormal];
    });
}

- (NSString *)getTimeStr:(NSInteger)time {
    NSInteger min = time / 60;
    NSInteger sec = time % 60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",min,sec];
}

#pragma mark - 按钮方法
- (void)click:(UIButton *)sender {
    NSLog(@"按钮方法");
    UIViewController *currentvc = [self getCurrentViewController];
    if (currentvc.navigationController != nil) {
        WatingPlanVC *vc = [[WatingPlanVC alloc]init];
        vc.fake_member_num = [[UserDefaults shareInstance] ReadRegisterNumber];
        vc.fake_former_num = [[UserDefaults shareInstance] ReadPlanNumber];
        [vc setHidesBottomBarWhenPushed:YES];
        [currentvc.navigationController pushViewController:vc animated:YES];
    }
}

//改变位置
- (void)locationChange:(UIPanGestureRecognizer*)p {
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    switch (p.state) {
        case UIGestureRecognizerStateBegan: {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(panPoint.x, panPoint.y);
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.center = CGPointMake(panPoint.x, panPoint.y);
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // 吸附边缘
            [self changeButtonLocation:panPoint];
            break;
        }
        default:
            break;
    }
}

- (void)changeButtonLocation:(CGPoint)panPoint {
    CGPoint newPoint;
    newPoint.x = panPoint.x < kScreenWidth / 2.0? (left_gap + floatWith / 2.0):(kScreenWidth - left_gap - floatWith / 2.0);
    newPoint.y = panPoint.y < top_gap? (top_gap + floatWith / 2.0):(panPoint.y > kScreenHeight - top_gap? (kScreenHeight - top_gap - floatWith / 2.0):panPoint.y);
    [UIView animateWithDuration:animateDuration animations:^{
        self.center = newPoint;
    }];
}

- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){//1、tabBarController
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){//2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}

@end
