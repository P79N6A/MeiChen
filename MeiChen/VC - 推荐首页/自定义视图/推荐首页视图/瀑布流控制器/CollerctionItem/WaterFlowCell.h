//
//  WaterFlowCell.h
//  meirong
//
//  Created by yangfeng on 2018/12/14.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFlowCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIButton *zan;

@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)loadData:(id)data;

@end
