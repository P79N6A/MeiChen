//
//  SegmentCell.h
//  meirong
//
//  Created by yangfeng on 2018/12/17.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientLabel.h"

@interface SegmentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) UIView *bgView;

- (void)colorLayerWithText:(NSString *)text font:(UIFont *)font is:(BOOL)is;

- (void)colorLayer:(UIView *)view ;

@end
