//
//  MyPlanView_2.h
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanView_2 : UIView

// 推荐案例
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UICollectionView *collView;

@property (nonatomic, strong) NSMutableArray *m_array;

// 推荐案例
- (void)titleLabel:(NSString *)str;

@end
