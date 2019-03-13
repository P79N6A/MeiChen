//
//  PayMethodView.m
//  meirong
//
//  Created by yangfeng on 2019/3/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PayMethodView.h"

@interface PayMethodView () {
    CGRect oldFrame;
    CGRect newFrame;
    NetWork *net;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation PayMethodView


- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PayMethodView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 264.0/667.0*height;
        oldFrame = CGRectMake(0, height, width, vi_h);
        newFrame = CGRectMake(0, height-vi_h, width, vi_h);
        self.frame = oldFrame;
        net = [[NetWork alloc]init];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.lab_1.text = NSLocalizedString(@"ChongZhi_6", nil);
        self.lab_2.text = NSLocalizedString(@"ChongZhi_7", nil);
        self.lab_3.text = NSLocalizedString(@"ChongZhi_8", nil);
        self.lab_4.text = NSLocalizedString(@"ChongZhi_9", nil);
        
    }
    return self;
}



- (void)loadPrice:(NSString *)str {
    self.price.text = str;
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        [window addSubview:self.backButton];
        [window addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = newFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    });
}

- (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = oldFrame;
            self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.backButton removeFromSuperview];
        }];
    });
}

- (void)HideMethod:(UIButton *)sender {
    [self hide];
    [self back:nil];
}

- (IBAction)BackMethod:(UIButton *)sender {
    [self hide];
    [self back:self.price.text];
}

- (IBAction)CloseMethod:(UIButton *)sender {
    [self hide];
    [self back:nil];
}

- (IBAction)WeChatMethod:(UIButton *)sender {
    NSLog(@"微信 支付");
    [SVProgressHUD show];
    [self requestWeChat:[self PriceStringWith:self.price.text] block:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (self.recharge) {
            self.recharge(error);
        }
        if (error == nil) {
            NSLog(@"微信充值 -- 成功");
        }
        else {
            NSLog(@"微信充值 -- 失败");
        }
    }];
}

- (IBAction)AlPayMethod:(UIButton *)sender {
    NSLog(@"支付宝 支付");
    [SVProgressHUD show];
    [self requestAlipay:[self PriceStringWith:self.price.text] block:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (self.recharge) {
            self.recharge(error);
        }
        if (error == nil) {
            NSLog(@"支付宝充值 -- 成功");
        }
        else {
            NSLog(@"支付宝充值 -- 失败");
        }
    }];
}

- (void)back:(NSString *)str {
    if (self.blockprice) {
        self.blockprice(str);
    }
}

- (NSString *)PriceStringWith:(NSString *)str {
    NSString *priceStr = [str stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    CGFloat pricef = [priceStr floatValue];
    return [NSString stringWithFormat:@"%.0f",pricef];
}

#pragma mark - 1 - 微信充值
- (void)requestWeChat:(NSString *)price block:(void (^)(NSError *error))block {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"total_amount"] = price;
    m_dic[@"pay_type"] = @"wxpay";
    [net requestWithUrl:@"card/charge-wx" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"微信充值 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 1: {
                NSLog(@"微信充值message = %@",responseObject[@"message"]);
                NSDictionary *data = responseObject[@"data"];
                [self CheckWeChat:data[@"charge_no"] Failure:^(NSError *error) {
                    block(error);
                }];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        block(error);
        
    } Failure:^(NSError *error) {
        block(error);
    }];
}
// 查询微信充值结果
- (void)CheckWeChat:(NSString *)charge_no Failure:(void (^)(NSError *error))failureTask {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"charge_no"] = charge_no;
    m_dic[@"pay_type"] = @"wxpay";
    [net requestWithUrl:@"card/charge-find-wx" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"微信充值结果 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 1: {
                NSLog(@"微信充值结果message = %@",responseObject[@"message"]);
                failureTask(nil);
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        failureTask(error);
        
    } Failure:^(NSError *error) {
        failureTask(error);
    }];
}

#pragma mark - 2 - 支付宝充值
- (void)requestAlipay:(NSString *)price block:(void (^)(NSError *error))block {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"total_amount"] = price;
    m_dic[@"pay_type"] = @"alipay";
    [net requestWithUrl:@"card/charge-alipay" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"支付宝充值 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 1: {
                NSLog(@"支付宝充值message = %@",responseObject[@"message"]);
                NSDictionary *data = responseObject[@"data"];
                [self CheckAlipay:data[@"charge_no"] Failure:^(NSError *error) {
                    block(error);
                }];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        block(error);
        
    } Failure:^(NSError *error) {
        block(error);
    }];
}
// 查询支付宝充值结果
- (void)CheckAlipay:(NSString *)charge_no Failure:(void (^)(NSError *error))failureTask {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"charge_no"] = charge_no;
    m_dic[@"pay_type"] = @"wxpay";
    [net requestWithUrl:@"card/charge-find-alipay" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"支付宝充值结果 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 1: {
                failureTask(nil);
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        failureTask(error);
        
    } Failure:^(NSError *error) {
        failureTask(error);
    }];
}






@end
