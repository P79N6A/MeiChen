//
//  MyPlanVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/5.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanVC.h"
#import "MyPlanView_1.h"
#import "MyPlanView_2.h"
#import "ExcSolDetailItemCell.h"
#import "CardView_1.h"
#import "CardView_2.h"
#import "PerferView.h"

@interface MyPlanVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
    CGFloat cell_h;
    
    NSInteger points_deduct;    // 积分抵扣
    NSInteger coupon_deduct;    // 优惠券抵扣
    NSInteger discount_deduct;  // 会员折扣
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) MyPlanView_1 *view_1; // 方案效果图
@property (nonatomic, strong) MyPlanView_2 *view_2; // 推荐案例
@property (nonatomic, strong) CardView_1 *view_3;
@property (nonatomic, strong) CardView_2 *view_4;
@property (nonatomic, strong) UIButton *next;
@property (nonatomic, strong) MyDZDetailModel *model;

@property (nonatomic, copy) NSArray *selectArr;
@end

@implementation MyPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self requestMyPlanDetailWithImitate_id:self.imitate_id];
    [self CreateUI];
}



#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"PlanListVC_5", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
}

- (void)CreateViewUI {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat y_2 = 0;
    CGFloat bu_h = 45;
    points_deduct = 0;      // 积分抵扣
    coupon_deduct = 0;      // 优惠券抵扣
    discount_deduct = 0;    // 会员折扣
    
    NSMutableArray *se = [NSMutableArray array];
    for (int i = 0; i < self.model.coupons.count; i ++) {
        PlanDetailCoupons *coupons = self.model.coupons[i];
        if (coupons.is_gray == 0) {
            [se addObject:coupons];
        }
    }
    self.selectArr = [NSArray arrayWithArray:se];
    
    if (self.model.has_card == 1) {
        for (int i = 0; i < self.model.card_calc.count; i ++) {
            PlanDetailCardCalc *calc = self.model.card_calc[i];
            if ([calc.key isEqualToString:@"points_deduct"]) {
                // 积分抵扣
                points_deduct = [calc.val integerValue];
            }
            if ([calc.key isEqualToString:@"discount_deduct"]) {
                // 会员折扣
                discount_deduct = [calc.val integerValue];
            }
        }
    }
    
    for (int i = 0; i < self.model.coupons.count; i ++) {
        PlanDetailCoupons *coupons = self.model.coupons[i];
        if (coupons.is_gray == 0) {
            // 优惠券抵扣
            coupon_deduct += [coupons.coupon.value integerValue];
        }
    }
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navview.frame), width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navview.frame)-bu_h)];
    _scroll.backgroundColor = [UIColor whiteColor];//kColorRGB(0xf0f0f0);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scroll];
    
    //方案效果图
    if ([self.model.list.has_seen integerValue] == 0) {
        self.view_1 = [[MyPlanView_1 alloc]initWithFrame:CGRectMake(0, 0, width, 10)];
        [self.view_1 loadData:self.model.list];
        [_scroll addSubview:self.view_1];
        y_2 = CGRectGetMaxY(self.view_1.frame)+1.0;
    }
    
    // 推荐案例
    self.view_2 = [[MyPlanView_2 alloc]initWithFrame:CGRectMake(0, y_2, width, 10)];
    self.view_2.m_array = [NSMutableArray arrayWithArray:self.model.sample];
    [_scroll addSubview:self.view_2];
    
    // 项目详情
    CGRect rect_2 = CGRectMake(12, CGRectGetMaxY(self.view_2.frame)+10.0, width, 20);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:rect_2];
    titleLab.textColor = kColorRGB(0x333333);
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.text = NSLocalizedString(@"MyPlanVC_4", nil);
    [_scroll addSubview:titleLab];
    
    cell_h = 120;
    CGRect rect_3 = CGRectMake(0, CGRectGetMaxY(rect_2)+15, width,cell_h);
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
    
    if (self.model.has_card == 1) {
        self.view_3 = [[CardView_1 alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), width, 334)];
        [self.view_3 loadDataWith:self.model coupon_deduct:coupon_deduct];
        [self.view_3.select_2 addTarget:self action:@selector(SelectJiFenButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view_3.select_3 addTarget:self action:@selector(DidTouchYouHuiJuan:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scroll addSubview:self.view_3];
        
        _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.view_3.frame));
    }
    else {
        self.view_4 = [[CardView_2 alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), width, 50*self.model.coupons.count+80)];
        [self.view_4 loadDataWith:self.model];
        [_scroll addSubview:self.view_4];
        _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.view_4.frame));
    }
    
    self.next = [[UIButton alloc]init];
    self.next.frame = CGRectMake(0, CGRectGetMaxY(_scroll.frame), width, bu_h);
    [self.next setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:(UIControlStateNormal)];
    [self.next setTitle:NSLocalizedString(@"MyPlanVC_6", nil) forState:(UIControlStateNormal)];
    self.next.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 18];
    [self.next setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.next addTarget:self action:@selector(NextButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.next];
}

#pragma mark - 立即预约
- (void)NextButtonMethod:(UIButton *)sender {
    
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
    view.m_arr = [NSMutableArray arrayWithArray:self.model.coupons];
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
    for (int i = 0; i < self.model.card_calc.count; i ++) {
        PlanDetailCardCalc *calc = self.model.card_calc[i];
        if ([calc.val isEqualToString:@"points_deduct"]) {
            if (select) {
                calc.val = [NSString stringWithFormat:@"%ld",points_deduct];
            }
            else {
                calc.val = @"0";
            }
            break;
        }
    }
}

// 更新优惠券抵扣额度
- (void)UpdateCouponDeduct:(NSArray *)array {
    NSInteger coupon = 0;
    for (int i = 0; i < array.count; i ++) {
        PlanDetailCoupons *model = array[i];
        if (model.is_gray == 0) {
            coupon += [model.coupon.value integerValue];
        }
    }
    coupon_deduct = coupon;
}

// 更新价格
- (void)UpdatePrice {
    self.model.total_deduct = discount_deduct+points_deduct+coupon_deduct;
    self.model.total_price = self.model.init_total_price-self.model.total_deduct;
    if (self.model.has_card == 1) {
        [self.view_3 loadDataWith:self.model coupon_deduct:coupon_deduct];
    }
    else {
        [self.view_4 loadDataWith:self.model];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExcSolDetailItemCell *cell = [ExcSolDetailItemCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadDataWithIndexPath:indexPath model:self.model.list];
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

#pragma mark - 请求数据 - 下载详情
- (void)requestMyPlanDetailWithImitate_id:(NSString *)imitate_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"imitate_id"] = imitate_id;
    [net requestWithUrl:@"former/my-detail" Parames:m_dic Success:^(id responseObject) {
        [self ParsingPlanDetailData:responseObject];
    } Failure:^(NSError *error) {
        [self DownLoadMyPlanDetailFail:error];
    }];
}
// 下载定制详情 - 成功
- (void)DownLoadMyPlanDetailSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self CreateViewUI];
    });
}
// 下载定制详情 - 失败
- (void)DownLoadMyPlanDetailFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - 解析数据
// 1、解析定制详细数据
- (void)ParsingPlanDetailData:(id)responseObject {
    // 异步解析数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                MyDZDetailModel *model = [MTLJSONAdapter modelOfClass:[MyDZDetailModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                if (model != nil) {
                    self.model = model;
                    [self DownLoadMyPlanDetailSuccess];
                    return;
                }
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
        [self DownLoadMyPlanDetailFail:error];
    });
}

- (MyDZDetailModel *)settingModel:(MyDZDetailModel *)mo {
    MyDZDetailModel *model = mo;
    
    PlanDetailCouponsCoupon *coupon_1 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_1.title = @"新人优惠券";
    coupon_1.value = @"600";
    
    PlanDetailCouponsCoupon *coupon_2 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_2.title = @"店庆优惠券";
    coupon_2.value = @"200";
    
    PlanDetailCouponsCoupon *coupon_3 = [[PlanDetailCouponsCoupon alloc]init];
    coupon_3.title = @"老板送的优惠券";
    coupon_3.value = @"150";
    
    PlanDetailCoupons *coupons_1 = [[PlanDetailCoupons alloc]init];
    coupons_1.is_gray = 0;
    coupons_1.coupon = coupon_1;
    coupons_1.coupon_id = @"1";
    
    PlanDetailCoupons *coupons_2 = [[PlanDetailCoupons alloc]init];
    coupons_2.is_gray = 0;
    coupons_2.coupon = coupon_2;
    coupons_2.coupon_id = @"2";
    
    PlanDetailCoupons *coupons_3 = [[PlanDetailCoupons alloc]init];
    coupons_3.is_gray = 1;
    coupons_3.coupon = coupon_3;
    coupons_3.coupon_id = @"3";
    
    // 优惠券
    model.coupons = @[coupons_1,coupons_2,coupons_3];
    
    PlanDetailCouponCalc *calc_1 = [[PlanDetailCouponCalc alloc]init];
    calc_1.remark = @"可用有效优惠券数";
    calc_1.key = @"valid_coupon_num";
    calc_1.val = 2;
    
    PlanDetailCouponCalc *calc_2 = [[PlanDetailCouponCalc alloc]init];
    calc_2.remark = @"有效优惠券扣减";
    calc_2.key = @"valid_coupon_deduct";
    calc_2.val = 800;
    
    // 会员等级
    PlanDetailCardCalc *cardcalc_1 = [[PlanDetailCardCalc alloc]init];
    cardcalc_1.remark = @"会员等级";
    cardcalc_1.key = @"card_title";
    cardcalc_1.val = @"神级会员";
    
    // 会员折扣
    PlanDetailCardCalc *cardcalc_2 = [[PlanDetailCardCalc alloc]init];
    cardcalc_2.remark = @"会员折扣";
    cardcalc_2.key = @"discount";
    cardcalc_2.val = @"8.6";
    
    // 会员折扣扣减
    PlanDetailCardCalc *cardcalc_3 = [[PlanDetailCardCalc alloc]init];
    cardcalc_3.remark = @"会员折扣扣减";
    cardcalc_3.key = @"discount_deduct";
    cardcalc_3.val = @"1040";
    
    // 积分倍数
    PlanDetailCardCalc *cardcalc_4 = [[PlanDetailCardCalc alloc]init];
    cardcalc_4.remark = @"积分倍数";
    cardcalc_4.key = @"points_get_multiple";
    cardcalc_4.val = @"1.3";
    
    // 本次可累计积分
    PlanDetailCardCalc *cardcalc_5 = [[PlanDetailCardCalc alloc]init];
    cardcalc_5.remark = @"本次可累计积分";
    cardcalc_5.key = @"points_get";
    cardcalc_5.val = @"10400";
    
    // 积分抵扣比例
    PlanDetailCardCalc *cardcalc_6 = [[PlanDetailCardCalc alloc]init];
    cardcalc_6.remark = @"积分抵扣比例";
    cardcalc_6.key = @"points_deduct_rate";
    cardcalc_6.val = @"10";
    
    // 会员累计积
    PlanDetailCardCalc *cardcalc_7 = [[PlanDetailCardCalc alloc]init];
    cardcalc_7.remark = @"会员累计积";
    cardcalc_7.key = @"points_current";
    cardcalc_7.val = @"8000";
    
    // 本次订单最大抵扣可用积分
    PlanDetailCardCalc *cardcalc_8 = [[PlanDetailCardCalc alloc]init];
    cardcalc_8.remark = @"本次订单最大抵扣可用积分";
    cardcalc_8.key = @"points_use_max";
    cardcalc_8.val = @"190000";
    
    // 最终可用积分
    PlanDetailCardCalc *cardcalc_9 = [[PlanDetailCardCalc alloc]init];
    cardcalc_9.remark = @"最终可用积分";
    cardcalc_9.key = @"points_use";
    cardcalc_9.val = @"5000";
    
    // 可用积分抵扣
    PlanDetailCardCalc *cardcalc_10 = [[PlanDetailCardCalc alloc]init];
    cardcalc_10.remark = @"可用积分抵扣";
    cardcalc_10.key = @"points_deduct";
    cardcalc_10.val = @"50";
    
    model.card_calc = @[cardcalc_1,cardcalc_2,cardcalc_3,
                        cardcalc_4,cardcalc_5,cardcalc_6,
                        cardcalc_7,cardcalc_8,cardcalc_9,
                        cardcalc_10];
    
    model.has_card = 0;
    
    // 优惠券统计
    model.coupon_calc = @[calc_1,calc_2];
    
    NSInteger pre_total_price = 8000;
    NSInteger discount_deduct = 0;//1040;   // 折扣扣除
    NSInteger points_deduct = 0;//50;    // 点扣除
    NSInteger coupon_deduct = 800; //息票中扣除
    model.total_deduct =  discount_deduct+points_deduct+coupon_deduct;
    model.total_price = pre_total_price-model.total_deduct;
    
    return model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
