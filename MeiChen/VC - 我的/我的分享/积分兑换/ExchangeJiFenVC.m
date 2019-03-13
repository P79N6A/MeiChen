//
//  ExchangeJiFenVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeJiFenVC.h"
#import "ExchangeRecordVC.h"
#import "ExchangeJiFenView.h"

@interface ExchangeJiFenVC () <CustomNavViewDelegate> {
    NetWork *net;
    CGRect oldFrame;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) ExchangeJiFenView *jifenview;
@end

@implementation ExchangeJiFenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self CreateUI];
    
    // 添加了一个 键盘即将显示时的监听，如果接收到通知，将调用 keyboardWillApprear：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillApprear:) name:UIKeyboardWillShowNotification object:nil];
    // 添加监听， 键盘即将隐藏的时候，调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsRecord];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"ExchangeJiFenVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    CGFloat y = CGRectGetMaxY(self.navview.frame);
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    oldFrame = CGRectMake(0, y, width, height-y);
    self.jifenview = [[ExchangeJiFenView alloc]initWithFrame:oldFrame];
    [self.jifenview loadNaneLab:self.jifen];
    [self.jifenview.all addTarget:self action:@selector(AllButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.jifenview.submit addTarget:self action:@selector(SubmitButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.jifenview];
}

#pragma mark - 全部
- (void)AllButtonMethod:(UIButton *)sender {
    self.jifenview.tf_price.text = [NSString stringWithFormat:@"%ld",self.jifen];
}

#pragma mark - 提交
- (void)SubmitButtonMethod:(UIButton *)sender {
    
    self.jifenview.tf_price.text = @"5000";
    self.jifenview.tf_name.text = @"杨峰";
    self.jifenview.tf_number.text = @"6227 1885 9640 0056 3281";
    
    if ([self.jifenview.tf_price.text integerValue] < 5000) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"ExchangeJiFenVC_6", nil)];
        return;
    }
    if (self.jifenview.tf_name.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"ExchangeJiFenVC_17", nil)];
        return;
    }
    if (![Tools checkBankCardNumber:self.jifenview.tf_number.text]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"ExchangeJiFenVC_16", nil)];
        return;
    }
    [self requestData];
}


#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    NSLog(@"记录");
    ExchangeRecordVC *vc = [[ExchangeRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 键盘即将显示的时候调用
- (void)keyboardWillApprear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    // 间隔时间
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyboardRect = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    // 键盘高度
    CGFloat keyBoardH =  keyboardRect.size.height;

    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    id firstResponder = [keywindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        UITextField *textview = (UITextField *)firstResponder;
        CGRect rect=[self.jifenview convertRect:textview.frame toView:self.view];
        CGFloat cell_maxy = rect.origin.y + rect.size.height;
        CGFloat key_y = keywindow.frame.size.height - keyBoardH;
        if (cell_maxy > key_y) {
            CGRect newRect = ({
                CGRect frame = oldFrame;
                frame.origin.y -= (cell_maxy - key_y);
                frame;
            });
            [UIView animateWithDuration:interval animations:^{
                self.jifenview.frame = newRect;
            }];
        }
    }
}


#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:interval animations:^{
        self.jifenview.frame = oldFrame;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}



#pragma mark - 网络请求
- (void)requestData {
    NSString *BlankStr = [self.jifenview.tf_number.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"withdraw_points"] = self.jifenview.tf_price.text;
    m_dic[@"realname"] = self.jifenview.tf_name.text;
    m_dic[@"bank_card"] = BlankStr;
    [SVProgressHUD show];
    [net requestWithUrl:@"agent/points-withdraw" Parames:m_dic Success:^(id responseObject) {
        [self ParsingData:responseObject];
    } Failure:^(NSError *error) {
        [self requestFail:error];
    }];
}

// 获取数据 - 成功
- (void)requestSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:nil];
        [self CustomNavView_RightItem:nil];
    });
}
// 获取数据 - 失败
- (void)requestFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    });
}

#pragma mark - 解析数据
// 1、解析数据
- (void)ParsingData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        NSLog(@"解析数据 = %@",responseObject);
        switch (code) {
                case 0: {
                    [SVProgressHUD dismiss];
                    [Tools JumpToLoginVC:responseObject];
                    break;
                }
                case 1: {
                    [self requestSuccess];
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
        [self requestFail:error];
    });
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
