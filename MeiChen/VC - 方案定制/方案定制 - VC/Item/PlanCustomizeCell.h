//
//  PlanCustomizeCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/17.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCustomizeCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)imvColorWith:(NSInteger)row;


@end
