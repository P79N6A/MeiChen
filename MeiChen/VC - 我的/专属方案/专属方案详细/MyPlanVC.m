//
//  MyPlanVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/24.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanVC.h"
#import "PlanItemCell.h"
#import "MyPlanData.h"
#import "MyPlanView_3.h"
#import "MyPlanView_4.h"
#import "PerferView.h"

@interface MyPlanVC () <CustomNavViewDelegate, UIScrollViewDelegate, MyPlanDataDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGFloat cell_h;
    CGPoint oldPoint;
    NSInteger jifen;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) MyPlanView_3 *view_3;
@property (nonatomic, strong) MyPlanView_4 *view_4;

@property (nonatomic, strong) MyPlanData *data;
@property (nonatomic, copy) NSArray *selectArr;
@end

@implementation MyPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[MyPlanData alloc]init];
    self.data.delegate = self;
    [self.data requestMyPlanDetailWithOrder_id:self.order_id];
    [self CreateUI];
    
    // 添加了一个 键盘即将显示时的监听，如果接收到通知，将调用 keyboardWillApprear：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillApprear:) name:UIKeyboardWillShowNotification object:nil];
    // 添加监听， 键盘即将隐藏的时候，调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 协议
- (void)MyPlanData_DownLoadDetailData_Success {
    [self CreateViewUI];
}
- (void)MyPlanData_DownLoadDetailData_Fail:(NSError *)error {
    NSLog(@"下载失败");
}
// 支付成功
- (void)MyPlanData_Pay_Success {
    NSLog(@"支付成功");
    [SVProgressHUD dismiss];
}
// 支付失败
- (void)MyPlanData_Pay_Fail:(NSError *)error {
    NSLog(@"支付失败");
    [SVProgressHUD dismiss];
}




#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = self.titleStr;
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
}

- (void)CreateViewUI {
    CGFloat width = CGRectGetWidth(self.view.frame);
    self.selectArr = [NSArray arrayWithArray:self.data.model.coupons];
    jifen = self.data.model.points_deduct;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navview.frame), width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navview.frame))];
    _scroll.backgroundColor = [UIColor whiteColor];//kColorRGB(0xf0f0f0);
    _scroll.delegate = self;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scroll];
    
    CGRect rect_2 = CGRectMake(12, 15, width, 20);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:rect_2];
    titleLab.textColor = kColorRGB(0x333333);
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.text = self.data.model.title;
    [_scroll addSubview:titleLab];
    
    cell_h = 120;
    CGRect rect_3 = CGRectMake(0, CGRectGetMaxY(rect_2)+15, width, (cell_h)*self.data.model.item.count);
    self.tabview = [[UITableView alloc]initWithFrame:rect_3 style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:self.tabview];

    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabview.frame), width, 10)];
    lineV.backgroundColor = kColorRGB(0xf0f0f0);
    [_scroll addSubview:lineV];
    
    if (self.data.model.has_card == 1) {
        self.view_3 = [[MyPlanView_3 alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), width, 370)];
        [self.view_3 loadDataWith:self.data.model];
        [self.view_3.select_2 addTarget:self action:@selector(SelectJiFenButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view_3.select_3 addTarget:self action:@selector(DidTouchYouHuiJuan:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view_3.pay addTarget:self action:@selector(ButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scroll addSubview:self.view_3];
        
        _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.view_3.frame));
    }
    else {
        CGFloat y = CGRectGetMaxY(lineV.frame);
        CGFloat he = _scroll.frame.size.height - y;
        if (he < 166) {
            he = 166;
        }
        self.view_4 = [[MyPlanView_4 alloc]initWithFrame:CGRectMake(0, y, width, he)];
        [self.view_4 loadDataWith:self.data.model];
        [self.view_4.select_1 addTarget:self action:@selector(DidTouchYouHuiJuan:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view_4.pay addTarget:self action:@selector(ButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scroll addSubview:self.view_4];
        _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.view_4.frame));
    }
    
    
}

#pragma mark - 抵扣积分
- (void)SelectJiFenButtonMethod:(UIButton *)button {
    button.selected = !button.selected;
    [self UpdatePointsDeduct:button.isSelected];
    [self UpdatePrice];
}
#pragma mark - 选择优惠券
- (void)DidTouchYouHuiJuan:(UIButton *)button {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    PerferView *view = [[PerferView alloc]init];
    view.m_arr = [NSMutableArray arrayWithArray:self.data.model.coupons];
    view.m_select = [NSMutableArray arrayWithArray:_selectArr];
    view.selectArray = ^(NSArray *array) {
        weakSelf.selectArr = [NSArray arrayWithArray:array];
        [weakSelf UpdateCouponDeduct:array];
        [weakSelf UpdatePrice];
    };
    [view show];
}

// 更新积分抵扣
- (void)UpdatePointsDeduct:(BOOL)select {
    if (select) {
        self.data.model.points_deduct = jifen;
    }
    else {
        self.data.model.points_deduct = 0;
    }
}

// 更新优惠券抵扣额度
- (void)UpdateCouponDeduct:(NSArray *)array {
    NSInteger coupon_deduct = 0;
    for (int i = 0; i < array.count; i ++) {
        PlanDetailCoupons *model = array[i];
        if ([model.is_gray integerValue] == 0) {
            coupon_deduct += [model.coupon.value integerValue];
        }
    }
    self.data.model.coupon_deduct = coupon_deduct;
}

// 更新价格
- (void)UpdatePrice {
    self.data.model.total_deduct = self.data.model.discount_deduct+self.data.model.points_deduct+self.data.model.coupon_deduct;
    self.data.model.total_price = self.data.model.pre_total_price-self.data.model.total_deduct;
    if (self.data.model.has_card == 1) {
        [self.view_3 loadDataWith:self.data.model];
    }
    else {
        [self.view_4 loadDataWith:self.data.model];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.model.item.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanItemCell *cell = [PlanItemCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PlanDetailItem *item = self.data.model.item[indexPath.row];
    [cell loadDataWithIndexPath:indexPath item:item];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_h;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 立即支付
- (void)ButtonMethod:(UIButton *)sender {
    NSLog(@"立即支付");
    BOOL point_deduct;
    BOOL coupon_deduct;
    NSString *text;
    if (self.data.model.has_card == 1) {
        point_deduct = self.view_3.select_2.selected;
        text = self.view_3.tf.text;
    }
    else {
        point_deduct = self.view_4.select_1.selected;
        text = self.view_4.tf.text;
    }
    coupon_deduct = self.selectArr.count>0?YES:NO;
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < self.selectArr.count; i ++) {
        PlanDetailCoupons *model = self.selectArr[i];
        [m_arr addObject:model.coupon_id];
    }
    [SVProgressHUD show];
    [self.data requestPayWithPoint:point_deduct Coupon:coupon_deduct coupon:m_arr text:text];
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
    
    CGRect rect;
    CGFloat tf_maxy;
    if (self.data.model.has_card == 1) {
        rect=[self.scroll convertRect:self.view_3.frame toView:self.view];
    }
    else {
        rect=[self.scroll convertRect:self.view_4.frame toView:self.view];
    }
    tf_maxy = rect.size.height+rect.origin.y;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat key_y = keywindow.frame.size.height - keyBoardH;
    oldPoint = self.scroll.contentOffset;
    if (tf_maxy > key_y) {
        CGPoint bottomOffset = CGPointMake(0, self.scroll.contentOffset.y + (tf_maxy - key_y));
        [UIView animateWithDuration:interval animations:^{
            [self.scroll setContentOffset:bottomOffset animated:YES];
        }];
    }
}

#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:interval animations:^{
        [self.scroll setContentOffset:oldPoint animated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
