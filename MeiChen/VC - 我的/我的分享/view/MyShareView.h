//
//  MyShareView.h
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShareView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labCard;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *labValue_1;
@property (weak, nonatomic) IBOutlet UILabel *labValue_2;
@property (weak, nonatomic) IBOutlet UILabel *labShare;
@property (weak, nonatomic) IBOutlet UICollectionView *collview;

@end
