//
//  MyShareVC.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareVC.h"
#import "MyShareView.h"
#import "MyShareCell.h"
#import "ExchangeVC.h"

@interface MyShareVC () <CustomNavViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    CGFloat item_h;
    CGFloat item_w;
    CGFloat cell_h;
    CGFloat left;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UITableView *tabview;
@end

@implementation MyShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateUI];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    MyShareCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyShareCell" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return cell_h;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.backgroundColor = [UIColor whiteColor];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"MyShareVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    [self loadContentView];
}
#pragma mark - 加载内容UI
- (void)loadContentView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    [self.navview RightItemIsJiFen];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navview.frame), width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navview.frame))];
    _scroll.backgroundColor = kColorRGB(0xf0f0f0);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    
    left = 12;
    item_w = (width-left*3)/2.0;
    item_h = item_w*(95.0/170.0);
    cell_h = 122;
    
    NSInteger count = 4;
    NSInteger shang = count / 2;
    NSInteger yushu = count % 2;
    CGFloat share_h = yushu==0?(shang*(item_h+left)):((shang+1)*(item_h+left));
    
    MyShareView *shareview = [[MyShareView alloc]initWithFrame:CGRectMake(0, 0, width, 171+47+share_h)];
    [_scroll addSubview:shareview];
    
    NSInteger cellCount = 2;
    CGFloat tab_h = cellCount*cell_h;
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(shareview.frame)+10,width,tab_h} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:self.tabview];
    
    _scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(self.tabview.frame));
}


#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    ExchangeVC *vc = [[ExchangeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
