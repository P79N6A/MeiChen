//
//  ExchangeView_2.m
//  meirong
//
//  Created by yangfeng on 2019/3/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeView_2.h"
#import "ExchViewCell_2.h"
#import "ProView.h"

@interface ExchangeView_2 () <UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) ProView *pro;

@end


@implementation ExchangeView_2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeView_2" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabview.backgroundColor = [UIColor whiteColor];
        
        self.pro = [[ProView alloc]initWithFrame:CGRectMake(0, 0, self.proView.frame.size.width, self.proView.frame.size.height)];
        [self.proView addSubview:self.pro];
        
        [self.pro settingProgressValue:83];
        [self settingLab:@"83"];
        
    }
    return self;
}

// 已引荐 83 人
- (void)settingLab:(NSString *)str {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:NSLocalizedString(@"ExchangeVC_15", nil)];
    [m_str appendString:@" "];
    [m_str appendString:str];
    [m_str appendString:@" "];
    [m_str appendString:NSLocalizedString(@"ExchangeVC_13", nil)];
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:m_str];
    NSRange range = [m_str rangeOfString:str];
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x333333) range:NSMakeRange(0, m_str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] range:NSMakeRange(0, m_str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x418DD9) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:range];
    self.lab.attributedText = attribut;
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    ExchViewCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchViewCell_2" owner:nil options:nil] firstObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 70;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
