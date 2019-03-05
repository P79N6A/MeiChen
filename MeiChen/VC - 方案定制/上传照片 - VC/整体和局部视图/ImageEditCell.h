//
//  ImageEditCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/19.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEditCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIButton *deleteBu;

- (void)SettingDeleteButtonWidth:(NSInteger)width;

@end
