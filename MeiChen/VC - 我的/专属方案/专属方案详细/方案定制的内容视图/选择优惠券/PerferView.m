//
//  YouHuiJuanView.m
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PerferView.h"
#import "PerferCell.h"

@interface PerferView () <UITableViewDelegate, UITableViewDataSource> {
    CGRect hideFrame;
    CGRect showFrame;
    NSArray *oldSelect;
}
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation PerferView

- (instancetype)init {
    if (self=[super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PerferView" owner:nil options:nil] firstObject];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat vi_h = 400;
        hideFrame = (CGRect){0,height,width,vi_h};
        showFrame = (CGRect){0,height-vi_h,width,vi_h};
        self.frame = hideFrame;
        self.m_arr = [NSMutableArray array];
        self.m_select = [NSMutableArray array];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self.backButton addTarget:self action:@selector(HideMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.bounces = NO;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
        
        self.titleLab.text = NSLocalizedString(@"MyPlanVC_26", nil);
        [self.queue setTitle:NSLocalizedString(@"MyPlanVC_28", nil) forState:(UIControlStateNormal)];
    }
    return self;
}

- (void)setM_arr:(NSMutableArray *)m_arr {
    _m_arr = [NSMutableArray arrayWithArray:m_arr];
//    m_select = [NSMutableArray array];
//    for (int i = 0; i < _m_arr.count; i ++) {
//        PlanDetailCoupons *model = _m_arr[i];
//        if ([model.is_gray integerValue] == 0) {
//            [m_select addObject:model];
//        }
//    }
    [self.tabview reloadData];
}

- (void)setM_select:(NSMutableArray *)m_select {
    _m_select = [NSMutableArray arrayWithArray:m_select];
    [self.tabview reloadData];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    [window addSubview:self.backButton];
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = showFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = hideFrame;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backButton removeFromSuperview];
    }];
}

- (void)HideMethod:(UIButton *)sender {
    [self hide];
}

- (IBAction)CloseMethod:(UIButton *)sender {
    [self hide];
}

- (IBAction)QueueMethod:(UIButton *)sender {
    if (self.selectArray) {
        self.selectArray(_m_select);
    }
    [self hide];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_arr.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PerferCell *cell = [PerferCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.select addTarget:self action:@selector(SelectMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.select.tag = indexPath.row;
    if (indexPath.row < self.m_arr.count) {
        [cell loadDataWithIndexPath:indexPath item:self.m_arr[indexPath.row] select:_m_select];
    }
    else {
        [cell NotDelect:_m_select];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 选择优惠券
- (void)SelectMethod:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag < self.m_arr.count) {
        PlanDetailCoupons *item = self.m_arr[sender.tag];
        if (sender.isSelected) {
            [_m_select addObject:item];
        }
        else {
            [_m_select removeObject:item];
        }
    }
    else {
        if (sender.isSelected) {
            oldSelect = [NSArray arrayWithArray:_m_select];
            _m_select = [NSMutableArray array];
        }
        else {
            _m_select = [NSMutableArray arrayWithArray:oldSelect];
        }
    }
    [self.tabview reloadData];
}

















@end
