//
//  ReviewVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ReviewVC.h"

#import "CustomSearchDetailNavView.h"   // 导航栏
#import "MessageSendView.h"
#import "ReviewData.h"
#import "ReviewCell.h"

@interface ReviewVC () <CustomSearchDetailNavViewDelegate,UITableViewDelegate, UITableViewDataSource, ReviewDataDelegate> {
    CGRect oldFrame;
}
// 导航栏
@property (nonatomic, strong) CustomSearchDetailNavView *navView;
@property (nonatomic, strong) UITableView *tabview;
@property (nonatomic, strong) MessageSendView *sendView;
@property (nonatomic, strong) ReviewData *data;
@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [[ReviewData alloc]init];
    self.data.delegate = self;
    self.data.dailyModel = self.model;
    [self.data requestReviewData:NO];
    
    [self buildBaseUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}



#pragma mark - ReviewDataDelegate
// 评论数据
- (void)RequestReviewData_Success {
    NSLog(@"评论数据 获取成功");
    [self.tabview reloadData];
}
- (void)RequestReviewData_Fail:(NSError *)error {
    NSLog(@"评论数据 获取失败");
}
// 提交评论
- (void)SubmitReview_Success:(NSInteger)row {
    NSLog(@"提交评论 成功");
    if ([self.sendView isRelay]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ReviewVC_13", nil)];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ReviewVC_12", nil)];
    }
    [self.sendView cleanData];
    // 请求评论数据
    [self.data requestReviewData:YES];
}
- (void)SubmitReview_Fail:(NSError *)error {
    NSLog(@"提交评论 失败");
    if ([self.sendView isRelay]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ReviewVC_15", nil)];
    }
    else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ReviewVC_14", nil)];
    }
}


#pragma mark - UI
- (void)buildBaseUI {
    // 导航栏
    NSString *title = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"ReviewVC_1", nil),self.model.comment_num,NSLocalizedString(@"ReviewVC_2", nil)];
    // 导航栏
    self.navView = [[CustomSearchDetailNavView alloc]init];
    self.navView.delegate = self;
    self.navView.index = 2;
    self.navView.titleLab.text = title;
    [self.view addSubview:self.navView];
    
    //
    self.sendView = [[MessageSendView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 55, CGRectGetWidth(self.view.frame), 55)];
    [self.sendView.send addTarget:self action:@selector(MessageSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView loadIcon:[UserData shareInstance].user.avatar];
    [self.view addSubview:self.sendView];
    
    CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    oldFrame = CGRectMake(0, y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - y - CGRectGetHeight(self.sendView.frame));
    self.tabview = [[UITableView alloc]initWithFrame:oldFrame];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tabview];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideKeyBoard)];
    [self.tabview addGestureRecognizer:gesture];
    
    // KVO 监听frame
    [self.sendView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view bringSubviewToFront:self.sendView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data numbersOfRows];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    reviewModel *model = [self.data modelWithRow:indexPath.row];
    [cell loadDataWith:model louzhuid:self.louzhuId];
    cell.message.tag = indexPath.row;
    [cell.message addTarget:self action:@selector(MessageMethod:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.data cellHeightWith:indexPath.row];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (BOOL)prefersHomeIndicatorAutoHidden{
//
//    return YES;
//}


#pragma mark - 点击回复
- (void)MessageMethod:(UIButton *)sender {
    self.sendView.send.tag = sender.tag;
    [self.sendView ReplayWith:[self.data modelWithRow:sender.tag]];
}

#pragma mark - 发送评论/回复
- (void)MessageSend:(UIButton *)sender {
    NSString *content = self.sendView.textfield.text;
    NSLog(@"content = %@",content);
    if (content.length == 0) {
        return;
    }
    [SVProgressHUD show];
    // 回复
    if ([self.sendView isRelay]) {
        NSLog(@"回复");
        reviewModel *model = [self.data modelWithRow:sender.tag];
        [self.data requestUploadReviewWithContent:content foreign_id:model.comment_id replayId:model.pid row:sender.tag];
    }
    // 评论
    else {
        NSLog(@"评论");
        [self.data requestUploadReviewWithContent:content foreign_id:self.model.daily_id replayId:nil row:sender.tag];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - CustomSearchDetailNavViewDelegate
- (void)CustomSearchDetailNavView_ClickedBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        CGFloat y = CGRectGetMaxY(oldFrame) - self.sendView.frame.origin.y;
        self.tabview.frame = ({
            CGRect frame = oldFrame;
            frame.size.height = oldFrame.size.height - y;
            frame;
        });
    }
}

- (void)HideKeyBoard {
    [self.sendView.textfield resignFirstResponder];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
    [self.sendView removeObserver:self forKeyPath:@"frame"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
