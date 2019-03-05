//
//  CustomSearchNavView.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchNavViewDelegate <NSObject>

// 可选协议方法
@optional
// 点击右边按钮
- (void)CustomSearchNavViewClickedRightItem;
// 点击键盘搜索
- (void)CustomSearchNavViewSearchWith:(NSString *)text;
// 开始点击
- (void)CustomSearchNavViewDidBeginClick;

@end

@interface CustomSearchNavView : UIView

// 根据不同的控制器设置不同的按钮
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) id <CustomSearchNavViewDelegate> delegate;




@end
