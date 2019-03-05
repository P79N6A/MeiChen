//
//  CustomSearchNavView.m
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CustomSearchNavView.h"

@interface CustomSearchNavView () <UISearchBarDelegate, UITextFieldDelegate>

@end

@implementation CustomSearchNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchNavView" owner:nil options:nil] firstObject];
        self.index = -1;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBar.placeholder = NSLocalizedString(@"tuijian_7", nil);
    self.searchBar.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    searchField.layer.masksToBounds = YES;

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
    
    [self CustomNavVieWWithRightItem:self.index];
}

// 根据不同的控制器设置不同的按钮
- (void)CustomNavVieWWithRightItem:(NSInteger)index {
    for (id searchbuttons in [[self.searchBar subviews][0]subviews]) {
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            switch (index) {
                case 0: {
                    // 推荐首页导航视图
                    [self ButtonWithRecommendHomePageVC:cancelButton];
                    break;
                }
                case 1: {
                    // 搜索页导航视图
                    [self ButtonWithSearchVC:cancelButton];
                    break;
                }
                default:
                    break;
            }
        }
    }
    [self setNeedsLayout];
}

// 推荐首页导航视图
- (void)ButtonWithRecommendHomePageVC:(UIButton *)button {
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
}
// 搜索页导航视图
- (void)ButtonWithSearchVC:(UIButton *)button {
    [button setTitle:NSLocalizedString(@"SearchHistoty_1", nil) forState:UIControlStateNormal];
    [button setTitleColor:kColorRGB(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
}

#pragma mark - UISearchBarDelegate
// 将要开始编辑文本时会调用该方法，返回 NO 将不会变成第一响应者
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomSearchNavViewDidBeginClick)]) {
        [self.delegate CustomSearchNavViewDidBeginClick];
    }
    switch (self.index) {
        case 0: {
            return NO;
            break;
        }
        default:
            break;
    }
    return YES;
}
// 键盘上的搜索按钮点击的会调用该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomSearchNavViewSearchWith:)]) {
        [self.delegate CustomSearchNavViewSearchWith:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomSearchNavViewClickedRightItem)]) {
        [self.delegate CustomSearchNavViewClickedRightItem];
    }
}



@end
