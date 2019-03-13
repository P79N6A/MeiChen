//
//  ServersItem.h
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServersItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (weak, nonatomic) IBOutlet UIImageView *icon2;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *butt;

- (void)loadData:(FicheModel *)model;

@end
