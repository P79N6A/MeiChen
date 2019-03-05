//
//  Tools.m
//  meirong
//
//  Created by yangfeng on 2018/12/10.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "Tools.h"
#import "LoginVC.h"
#import "WatingPlanVC.h"

@interface Tools () {
    dispatch_source_t _timer;
    CGRect oldframe;
}


@end

@implementation Tools

// 创建静态对象 防止外部访问
static Tools *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+ (instancetype)shareInstance {
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}




+ (void)SetSVProgressHUD {
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (BOOL)JumpToLoginVC:(id)response {
    id objs = response[@"data"];
    if ([objs isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = [NSDictionary dictionaryWithDictionary:response[@"data"]];
        if ([[data allKeys] containsObject:@"code"]) {
            NSInteger code2 = [data[@"code"] integerValue];
            switch (code2) {
                case 104: {
                    [[self class] jumpToLogin:data[@"message"]];
                    return YES;
                    break;
                }
                case 105: {
                    [[self class] jumpToLogin:data[@"message"]];
                    return YES;
                }
                default:
                    break;
            }
        }
    }
    return NO;
}

+ (void)jumpToLogin:(NSString *)string {
    [SVProgressHUD showInfoWithStatus:string];
    [[UserDefaults shareInstance] WriteAccessTokenWith:nil];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    LoginVC *vc = [[LoginVC alloc]init];
    vc.autoAuthorization = NO;
    windows.rootViewController = vc;
    [windows makeKeyAndVisible];
}

/** 分享 */
+ (void)mq_share:(NSArray *)items target:(id)target {
    if (items.count == 0 && target == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks];
    }else {
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@">>>>>success");
        }else {
            NSLog(@">>>>>faild");
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = target;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

// 保存图片
+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName  {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",imageName]];  // 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    return result;
}

// 取出图片
+ (UIImage *)getImageWithName:(NSString *)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",imageName]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

// 保存日志文件
+ (void)redirectFileToDocumentFolder:(NSDictionary *)diction filename:(NSString *)filename
{
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
    
    BOOL isSucceed = [diction writeToFile:newFielPath atomically:YES];
    if (isSucceed) {
        NSLog(@"存储成功");
    }
    else {
        NSLog(@"存储失败");
    }
}

// 计算字符串尺寸
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
