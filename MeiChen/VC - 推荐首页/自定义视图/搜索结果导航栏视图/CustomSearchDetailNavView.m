//
//  CustomSearchDetailNavView.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CustomSearchDetailNavView.h"

@interface CustomSearchDetailNavView () <UISearchBarDelegate, UITextFieldDelegate>

@end

@implementation CustomSearchDetailNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchDetailNavView" owner:nil options:nil] firstObject];
        self.index = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBar.placeholder = NSLocalizedString(@"tuijian_7", nil);
    self.searchBar.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchBar.delegate = self;
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    searchField.layer.masksToBounds = YES;
    
    self.line.hidden = YES;
    
    self.titleLab.textColor = kColorRGB(0x333333);
    self.titleLab.font = [UIFont boldSystemFontOfSize:18];
    self.titleLab.hidden = YES;
    
    ///设置搜索条背景颜色
    for (UIView *subview in self.searchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
            }else{
                grandSonView.alpha = 0.0f;
            }
        }//for cacheViews
    }//subviews
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.frame = CGRectMake(0, 0, statusRect.size.width, statusRect.size.height + 44);
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
    searchField.layer.cornerRadius = searchField.frame.size.height / 2.0;
    
    [self CustomTitle:self.index];
}

// 根据不同的控制器设置不同的titleView
- (void)CustomTitle:(NSInteger)index {
    switch (index) {
        case 1: { // 从搜索页进入
            [self.back setTitle:nil forState:UIControlStateNormal];
            [self.back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            self.titleLab.hidden = YES;
            self.line.hidden = YES;
            self.searchBar.hidden = NO;
            break;
        }
        case 2: { // 从分类页进入
            [self.back setTitle:nil forState:UIControlStateNormal];
            [self.back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            self.titleLab.hidden = NO;
            self.line.hidden = NO;
            self.searchBar.hidden = YES;
            break;
        }
        case 3: { // 从分类页进入
            [self.back setTitle:nil forState:UIControlStateNormal];
            [self.back setImage:[UIImage imageNamed:@"返回2"] forState:UIControlStateNormal];
            self.titleLab.hidden = NO;
            self.line.hidden = NO;
            self.searchBar.hidden = YES;
            break;
        }
        default:
            break;
    }
}

// 搜索页导航视图
- (void)ButtonWithSearchVC:(UIButton *)button {
    [button setTitle:NSLocalizedString(@"SearchHistoty_1", nil) forState:UIControlStateNormal];
    [button setTitleColor:kColorRGB(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
}

#pragma mark - 返回按钮
- (IBAction)BackButtonMehod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomSearchDetailNavView_ClickedBackItem)]) {
        [self.delegate CustomSearchDetailNavView_ClickedBackItem];
    }
}

#pragma mark - UISearchBarDelegate
// 将要开始编辑文本时会调用该方法，返回 NO 将不会变成第一响应者
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomSearchDetailNavView_DidBeginClick)]) {
        [self.delegate CustomSearchDetailNavView_DidBeginClick];
    }
    switch (self.index) {
        case 1: {
            return NO;
            break;
        }
        default:
            break;
    }
    return YES;
}









@end
