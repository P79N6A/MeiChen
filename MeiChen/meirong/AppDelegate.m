//
//  AppDelegate.m
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBar.h"


#import "LoginVC.h"
#import "Tools.h"
#import "CameraVC.h"
#import "PhotosVC.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface AppDelegate ()

@property (nonatomic, strong) OSSClient *client;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 友盟
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:UM_AppKey channel:@"ios_test"];
    
    
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
    
    id accessToken = [[UserDefaults shareInstance] ReadAccessToken];
    if (accessToken != nil && [UserData shareInstance].user != nil) {
        [self JumpToTabBar];
    }
    else {
        [self JumpToLoginVC];
    }
    // 向微信终端程序注册
    [WXApi registerApp:APPID];
    
    [Tools SetSVProgressHUD];
    [[AliyunOSSUpload shareOSSClientObj] setupEnvironment];
    return YES;
}

// 跳转登录
- (void)JumpToLoginVC {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LoginVC *vc = [[LoginVC alloc]init];
    vc.autoAuthorization = YES;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

// 跳转到主页
- (void)JumpToTabBar {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    TabBar *vc = [[TabBar alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 如果在相机界面退到后台，则退出相机界面
//    UIViewController *vc = [self getPresentedViewController];
//    NSLog(@"vc = %@",vc);
//    if ([vc isMemberOfClass:[CameraVC class]] ||
//        [vc isMemberOfClass:[PhotosVC class]]) {
//        [vc dismissViewControllerAnimated:YES completion:nil];
//    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//- (UIViewController *)getPresentedViewController {
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    return topVC;
//}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 微信的代理
//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    NSLog(@"微信的代理回调");
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        if (aresp.errCode== 0)
        {
            [center postNotificationName:WECHAT_NOTIFICATION object:nil userInfo:@{@"code":aresp.code}];
        }
        else {
            [center postNotificationName:WECHATCENTER_NOTIFICATION object:nil userInfo:nil];
        }
    }
}





@end
