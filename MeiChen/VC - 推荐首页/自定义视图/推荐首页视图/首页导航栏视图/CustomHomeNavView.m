//
//  YFCustonView.m
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "CustomHomeNavView.h"

@implementation CustomHomeNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomHomeNavView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.TFItem.backgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = NSLocalizedString(@"tuijian_7", nil);
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
}

- (IBAction)TFItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomHomeNavViewTouchUpInsideTextField)]) {
        [self.delegate CustomHomeNavViewTouchUpInsideTextField];
    }
}

- (IBAction)RightItemMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomHomeNavViewTouchUpInsideRightItem:)]) {
        [self.delegate CustomHomeNavViewTouchUpInsideRightItem:sender];
    }
}

@end
