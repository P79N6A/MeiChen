//
//  ServersView.h
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServersView : UIView

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *proView;

@property (weak, nonatomic) IBOutlet UILabel *detial;

@property (weak, nonatomic) IBOutlet UICollectionView *collview;

@property (weak, nonatomic) IBOutlet UILabel *headeLab;

@property (weak, nonatomic) IBOutlet UILabel *ALab_1;
@property (weak, nonatomic) IBOutlet UILabel *ALab_2;
@property (weak, nonatomic) IBOutlet UIButton *Abutt;

@property (weak, nonatomic) IBOutlet UILabel *BLab_1;
@property (weak, nonatomic) IBOutlet UILabel *BLab_2;
@property (weak, nonatomic) IBOutlet UIButton *Bbutt;


@property (nonatomic, strong) NSMutableArray *m_array;

- (void)loadDataWith:(SurgeryModel *)model;


@end
