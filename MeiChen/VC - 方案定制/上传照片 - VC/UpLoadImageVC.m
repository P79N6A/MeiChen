//
//  UpLoadImageVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "UpLoadImageVC.h"
#import "AddImageView.h"
#import "DemandView.h"
#import "NSString+RandomString.h"
#import "WatingPlanVC.h"
#import "imageBrowser.h"
#import "ExampleView.h"

@interface UpLoadImageVC () <CustomNavViewDelegate> {
    NetWork *net;
}
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) CustomNavView *navview;   // 导航栏
@property (nonatomic, strong) AddImageView *wholeView;  // 整体
@property (nonatomic, strong) AddImageView *localView;  // 局部
@property (nonatomic, strong) DemandView *demandView;  // 需求说明
@end

@implementation UpLoadImageVC

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
    CGFloat bu_h = 45;
    __weak typeof(self) weakSelf = self;
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsSkip];
    self.navview.line.hidden = NO;
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"UploadImageVC_1", nil);
    [self.view addSubview:self.navview];
    
    CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y - bu_h)];
    self.scroll.backgroundColor = kColorRGB(0xf0f0f0);
    self.scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scroll];
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    myTap.numberOfTapsRequired = 1;
    myTap.cancelsTouchesInView = NO;
    [self.scroll addGestureRecognizer:myTap];
    
    // 下一步
    UIButton *buu = [[UIButton alloc]init];
    buu.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - bu_h, CGRectGetWidth(self.view.frame), bu_h);
    [buu addTarget:self action:@selector(NextButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [buu setTitle:NSLocalizedString(@"UploadImageVC_7", nil) forState:UIControlStateNormal];
    [buu setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:UIControlStateNormal];
    [buu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buu];
    
    // 整体
    self.wholeView = [[AddImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.wholeView.titleLab.text = NSLocalizedString(@"UploadImageVC_8", nil);
    self.wholeView.detailLab.text = self.topcatModel.remark.front;
    [self.wholeView.exampleBu addTarget:self action:@selector(ExampleMethod_1:) forControlEvents:UIControlEventTouchUpInside];
    self.wholeView.collView.tag = 1;
    self.wholeView.block = ^{
        [weakSelf reloadLayout];
    };
    self.wholeView.blockIndex = ^(NSInteger tag, NSInteger row) {
        if ([weakSelf.wholeView arrCount] == row + 1) {
            [weakSelf.wholeView showAlert:weakSelf];
        }
        else {
            [[imageBrowser shareInstance] showImagesWith:weakSelf.wholeView.images index:row];
        }
    };
    [self.scroll addSubview:self.wholeView];
    
    // 局部
    self.localView = [[AddImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wholeView.frame) + 12, self.view.frame.size.width, 100)];
    self.localView.titleLab.text = self.topcatModel.tag_name;
    self.localView.detailLab.text = self.topcatModel.remark.part;
    [self.localView.exampleBu addTarget:self action:@selector(ExampleMethod_2:) forControlEvents:UIControlEventTouchUpInside];
    self.localView.collView.tag = 2;
    self.localView.block = ^{
        [weakSelf reloadLayout];
    };
    self.localView.blockIndex = ^(NSInteger tag, NSInteger row) {
        if ([weakSelf.localView arrCount] == row + 1) {
            [weakSelf.localView showAlert:weakSelf];
        }
        else {
            [[imageBrowser shareInstance] showImagesWith:weakSelf.localView.images index:row];
        }
    };
    [self.scroll addSubview:self.localView];
    
    // 需求说明
    self.demandView = [[DemandView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.localView.frame) + 12, self.scroll.frame.size.width, 165)];
    [self.scroll addSubview:self.demandView];
    
    [self reloadLayout];
}

- (void)reloadLayout {
    self.localView.frame = ({
        CGRect frame = self.localView.frame;
        frame.origin.y = CGRectGetMaxY(self.wholeView.frame) + 12;
        frame;
    });
    
    self.demandView.frame = ({
        CGRect frame = self.demandView.frame;
        frame.origin.y = CGRectGetMaxY(self.localView.frame) + 12;
        frame.size.width = CGRectGetWidth(self.scroll.frame);
        frame;
    });
    
    CGFloat sc_h = CGRectGetMaxY(self.demandView.frame);
    self.demandView.frame = ({
        CGRect frame = self.demandView.frame;
        if (sc_h < self.scroll.frame.size.height) {
            frame.size.height += (self.scroll.frame.size.height - sc_h);
        }
        frame;
    });
    
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, CGRectGetMaxY(self.demandView.frame));
}

#pragma mark - CustomNavViewDelegate
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    // 跳过
    [self showSkipAlert];
}

#pragma mark - 示例
- (void)ExampleMethod_1:(UIButton *)button {
    [self example_1];
}
- (void)ExampleMethod_2:(UIButton *)button {
    [self example_2];
}

#pragma mark - 方案生成
- (void)NextButtonMethod:(UIButton *)sender {
    [[UserDefaults shareInstance] CleanPlanRecode];
    if ([[UserDefaults shareInstance] HaveSubmitPlan]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"UploadImageVC_19", nil)];
        return;
    }
    
    NSInteger k1 = self.uploadImagesArray.count + self.serverImagesArray.count;
    NSInteger k2 = self.wholeView.images.count;
    NSInteger k3 = self.localView.images.count;
    
    if (k1 == 0 && k2 == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"UploadImageVC_15", nil)];
        return;
    }
    if (k3 == 0) {
        [SVProgressHUD showInfoWithStatus:self.topcatModel.remark.part];
        return;
    }
    if ([self.demandView.textView.text isEqualToString:[self.demandView defaultString]]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"UploadImageVC_16", nil)];
        [self.demandView.textView becomeFirstResponder];
        return;
    }
    
    // 浏览图片 https://mecen.oss-cn-shenzhen.aliyuncs.com/def
    [SVProgressHUD show];
    dispatch_group_t group =  dispatch_group_create();

    // 上传图片到oss
    NSMutableArray *m_arr = [NSMutableArray array];
    [m_arr addObject:self.uploadImagesArray];
    [m_arr addObject:self.wholeView.images];
    [m_arr addObject:self.localView.images];
    
    NSMutableArray *m_nameArr = [NSMutableArray array];
    
    NSMutableString *m_file = [NSMutableString string];
    [m_file appendString:@"imitate"];
    
    NSDateFormatter *formatter_1 = [[NSDateFormatter alloc]init];
    [formatter_1 setDateFormat:@"yyyy-MM"];
    NSString *time_1 = [formatter_1 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_1];
    
    NSDateFormatter *formatter_2 = [[NSDateFormatter alloc]init];
    [formatter_2 setDateFormat:@"dd"];
    NSString *time_2 = [formatter_2 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_2];

    for (int i = 0; i < m_arr.count; i ++) {
        NSArray *arr = [NSArray arrayWithArray:m_arr[i]];
        NSMutableArray *nameArr = [NSMutableArray array];
        for (int j = 0; j < arr.count; j ++) {
            NSString *ima = [NSString stringWithFormat:@"ios_%@.png",[NSString randomString:32]];
            // 生成图片名称
            NSString *imageName = [NSString stringWithFormat:@"%@/%@",m_file,ima];
            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",[[AliyunOSSUpload shareOSSClientObj] dowmLoadURL], imageName];
            [nameArr addObject:imageUrl];
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = (UIImage *)arr[j];
                NSData *data = [image compressQualityWithMaxLength:(5*1024*1024)];
                [[AliyunOSSUpload shareOSSClientObj] updateToALi:data imageName:imageName];
            });
        }
        [m_nameArr addObject:nameArr];
    }
    // 全部上传图片完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSMutableArray *target = [NSMutableArray array];
        [target addObjectsFromArray:m_nameArr[0]];
        for (int i = 0; i < self.serverImagesArray.count; i ++) {
            ImageModel *model = self.serverImagesArray[i];
            [target addObject:model.img];
        }
        [self SubmitPlanRequestWithTarget:target unitary:m_nameArr[1] part:m_nameArr[2]];
    });
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

    // 对 tableView  执行动画，向上平移
    [UIView animateWithDuration:interval animations:^{
        CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height + keyBoardH - 45);
        [self.scroll setContentOffset:bottomOffset animated:YES];
    }];
}


#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:interval animations:^{
        CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height);
        [self.scroll setContentOffset:bottomOffset animated:YES];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)scrollTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)showSkipAlert{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"UploadImageVC_12", nil) message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_13", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self CustomNavView_LeftItem:nil];
    }];

    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_14", nil) style:(UIAlertActionStyleDefault) handler:nil];
    
    [action_1 setValue:kColorRGB(0x666666) forKey:@"titleTextColor"];
    [action_2 setValue:kColorRGB(0x21C9D9) forKey:@"titleTextColor"];
    
    [controller addAction:action_1];
    [controller addAction:action_2];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 方案生成
- (void)SubmitPlanRequestWithTarget:(NSArray *)target unitary:(NSArray *)unitary part:(NSArray *)part {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"style_tag_id"] = self.styleModel.tag_id;
    m_dic[@"part_tag_id"] = self.topcatModel.tag_id;
    m_dic[@"remark"] = self.demandView.textView.text;
    m_dic[@"target"] = target;      // target   目标图片
    m_dic[@"unitary"] = unitary;    // unitary  整体图片
    m_dic[@"part"] = part;          // part     部位图片
    [net requestWithUrl:@"former/do-appeal" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"方案生成 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                if ([Tools JumpToLoginVC:responseObject]) {
                    [SVProgressHUD dismiss];
                }
                break;
            }
            case 1: {
                [SVProgressHUD dismiss];
                NSDictionary *diction = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                // 默认间隔时间为1小时
                [[UserDefaults shareInstance] WritePlanSettingData:diction];
                
                NSString *member = [NSString stringWithFormat:@"%@",diction[@"fake_member_num"]];
                NSString *former = [NSString stringWithFormat:@"%@",diction[@"fake_former_num"]];
    
                // 判断是否需要弹出浮窗
                [[FloatWindows shareInstance] CanShowFloatingWindows];
                
                WatingPlanVC *vc = [[WatingPlanVC alloc]init];
                vc.from = 1;
                vc.fake_member_num = member;
                vc.fake_former_num = former;
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
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
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

// 示例一
- (void)example_1 {
    ExampleView *ex_view = [[ExampleView alloc]init];
    ex_view.titleStr = NSLocalizedString(@"UploadImageVC_17", nil);
    ex_view.messageStr = self.topcatModel.remark.front;
    [ex_view ShowImages:self.topcatModel.remark.front_photo];
}

// 示例二
- (void)example_2 {
    ExampleView *ex_view = [[ExampleView alloc]init];
    ex_view.titleStr = self.topcatModel.tag_name;
    ex_view.messageStr = self.topcatModel.remark.part;
    [ex_view ShowImages:self.topcatModel.remark.part_photo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
