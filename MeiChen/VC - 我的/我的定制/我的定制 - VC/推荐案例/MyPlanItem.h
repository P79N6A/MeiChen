//
//  MyPlanItem.h
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)loadIcon:(NSString *)url;

- (void)loadTitleLabel:(NSString *)str;

- (void)loadDataWith:(NSIndexPath *)indexPath model:(MyDZSampleModel *)model;

@end
