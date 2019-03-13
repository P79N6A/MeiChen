//
//  MyShareItem.h
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShareItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIButton *button;

- (void)loadData:(ShareMintermsModel *)model;

@end
