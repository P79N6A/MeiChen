//
//  AddDiaryView.h
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosAddView.h"

@protocol AddDiaryViewDelegate <NSObject>

@optional
- (void)AddDiaryView_AddDiaryButton:(UIButton *)button;
- (void)AddDiaryView_DidSelectProjectButton:(UIButton *)button;
- (void)AddDiaryView_TableViewFrame:(CGFloat)height;
- (void)AddDiaryView_DeleteOneDiaryWith:(DailyDetailItem *)item;
@end

@interface AddDiaryView : UIView

@property (weak, nonatomic) id<AddDiaryViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;
@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UIView *photosView;

@property (weak, nonatomic) IBOutlet UIView *iconView;

@property (weak, nonatomic) IBOutlet UITableView *tabview;

@property (nonatomic, strong) PhotosAddView *view_1;
@property (nonatomic, strong) PhotosAddView *view_2;

@property (nonatomic, strong) DiaryDetailModel *diaryModel;
@property (nonatomic, strong) NSString *DiaryStatus;
@property (nonatomic) BOOL isfirst;
@property (nonatomic, strong) NSMutableArray *heightArr;

- (void)LoadButton_2:(NSArray *)array;

@end
