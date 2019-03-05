//
//  CustomNavView.h
//  
//
//  Created by yangfeng on 2019/1/14.
//

#import <UIKit/UIKit.h>

@protocol CustomNavViewDelegate <NSObject>

@optional
- (void)CustomNavView_LeftItem:(UIButton *)sender;
- (void)CustomNavView_RightItem:(UIButton *)sender;

@end

@interface CustomNavView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *rightItem;

@property (weak, nonatomic) IBOutlet UIView *line;


@property (nonatomic, weak) id <CustomNavViewDelegate> delegate;

// 左侧返回按钮
- (void)LeftItemIsBack;

// 左侧白色返回按钮
- (void)LeftItemIsWhiteBack;

// 右侧返回按钮
- (void)RightItemIsUpload:(NSInteger)index;

// 右侧跳过按钮
- (void)RightItemIsSkip;

// 右侧兑换
- (void)RightItemIsExchange;

// 右侧发布
- (void)RightItemIsRelease;

// 右侧确定
- (void)RightItemIsQueue;

// 右侧积分
- (void)RightItemIsJiFen;

// 右侧 引荐管理 兑换
- (void)RightItemIsDuiHuan;

// 右侧记录
- (void)RightItemIsRecord;




@end
