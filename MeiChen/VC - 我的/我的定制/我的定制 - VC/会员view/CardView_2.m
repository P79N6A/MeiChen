//
//  CardView_2.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CardView_2.h"
#import "NewPerferCell.h"

@interface CardView_2 () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat cell_h;
    NSMutableArray *m_arr;
}
@end

@implementation CardView_2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CardView_2" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.lab_1.text = NSLocalizedString(@"MyPlanVC_9", nil);
        [self settingPrice_1:0];
        m_arr = [NSMutableArray array];
        
        cell_h = 50;
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.bounces = NO;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadDataWith:(MyDZDetailModel *)model {
    [self settingPrice_1:model.total_price];
    m_arr = [NSMutableArray arrayWithArray:model.coupons];
    [self.tabview reloadData];
}

- (void)settingPrice_1:(NSInteger)str {
    self.price_1.text = [NSString stringWithFormat:@"￥%ld",str];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPerferCell *cell = [NewPerferCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:indexPath model:m_arr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_h;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
