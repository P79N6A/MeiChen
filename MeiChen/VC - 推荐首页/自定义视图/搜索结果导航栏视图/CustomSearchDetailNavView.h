//
//  CustomSearchDetailNavView.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchDetailNavViewDelegate <NSObject>

// 可选协议方法
@optional
// 点击返回按钮
- (void)CustomSearchDetailNavView_ClickedBackItem;
// 开始点击
- (void)CustomSearchDetailNavView_DidBeginClick;

@end

@interface CustomSearchDetailNavView : UIView

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *back;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIView *line;


// 根据不同的控制器设置不同的按钮
@property (nonatomic) NSInteger index;

@property (nonatomic, weak) id <CustomSearchDetailNavViewDelegate> delegate;

@end
