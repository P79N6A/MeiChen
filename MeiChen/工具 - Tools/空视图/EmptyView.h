//
//  EmptyView.h
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyViewDelegate <NSObject>

@optional
- (void)EmptyViewDidTouch;

@end

@interface EmptyView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (nonatomic, weak) id<EmptyViewDelegate> delegate;

@end
