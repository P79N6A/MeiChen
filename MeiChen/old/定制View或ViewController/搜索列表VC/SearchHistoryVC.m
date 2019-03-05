//
//  SearchHistoryVC.m
//  meirong
//
//  Created by yangfeng on 2018/12/19.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "SearchHistoryVC.h"

@interface SearchHistoryVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *listArray;

@end

@implementation SearchHistoryVC

- (NSArray *)listArray {
    if (_listArray || _listArray.count == 0) {
        NSArray *array = [[UserDefaults shareInstance] ReadSeacrhHistory];
        if (array == nil) {
            _listArray = @[NSLocalizedString(@"tuijian_8", nil),
                           NSLocalizedString(@"tuijian_9", nil),
                           NSLocalizedString(@"tuijian_10", nil),
                           NSLocalizedString(@"tuijian_11", nil),
                           NSLocalizedString(@"tuijian_12", nil)];
        }
        else {
            _listArray = [NSArray arrayWithArray:array];
        }
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.bounces = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _listArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"w");
}

- (IBAction)CleanButtonMethod:(UIButton *)sender {
    [[UserDefaults shareInstance] CleanSeacrhHistory];
    [self.tab reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
