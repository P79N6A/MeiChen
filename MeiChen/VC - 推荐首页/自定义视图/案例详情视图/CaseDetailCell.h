//
//  CaseDetailCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/3.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaseDetailCellDelegate <NSObject>

@optional
- (void)CaseDetailCellDidSelectZan:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
- (void)CaseDetailCellDidSelectMessageIndexPath:(NSIndexPath *)indexPath;
@end


@interface CaseDetailCell : UITableViewCell

@property (weak, nonatomic) id <CaseDetailCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *time_1;

@property (weak, nonatomic) IBOutlet UILabel *time_2;

@property (weak, nonatomic) IBOutlet UILabel *title_1;

@property (weak, nonatomic) IBOutlet UILabel *title_2;

@property (weak, nonatomic) IBOutlet UIView *ImagesView;

@property (weak, nonatomic) IBOutlet UIImageView *imv_1;

@property (weak, nonatomic) IBOutlet UIImageView *imv_2;

@property (weak, nonatomic) IBOutlet UIImageView *imv_3;

@property (weak, nonatomic) IBOutlet UIImageView *imv_4;

@property (weak, nonatomic) IBOutlet UIImageView *imv_5;

@property (weak, nonatomic) IBOutlet UIImageView *imv_6;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_1;

@property (weak, nonatomic) IBOutlet UIButton *bu_2;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIView *line_2;


- (void)loadDataWithModel:(DailyModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)loadTime_2:(NSInteger)index;

@end
