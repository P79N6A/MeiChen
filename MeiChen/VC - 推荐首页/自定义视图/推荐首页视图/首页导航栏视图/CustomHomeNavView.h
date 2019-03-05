//
//  YFCustonView.h
//  meirong
//
//  Created by yangfeng on 2019/1/8.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomHomeNavViewDelegate <NSObject>

// 可选协议方法
@optional
- (void)CustomHomeNavViewTouchUpInsideRightItem:(UIButton *)sender;

- (void)CustomHomeNavViewTouchUpInsideTextField;

@end

@interface CustomHomeNavView : UIView

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *rightItem;

@property (weak, nonatomic) IBOutlet UIButton *TFItem;

@property (nonatomic, weak) id <CustomHomeNavViewDelegate> delegate;


@end
