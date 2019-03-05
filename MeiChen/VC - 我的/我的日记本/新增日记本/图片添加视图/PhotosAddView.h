//
//  PhotosAddView.h
//  meirong
//
//  Created by yangfeng on 2019/2/16.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockFrame)(CGRect frame);
@interface PhotosAddView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collview;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat cell_w;
@property (nonatomic) NSInteger MaxCount;
@property (nonatomic) NSInteger ColumnsCount;   // 列数
@property (nonatomic) BOOL isleft;  // 是否靠右边
@property (nonatomic) BOOL updateFrame;
@property (nonatomic) BOOL onlyShow;

@property (nonatomic, copy) blockFrame framblock;

- (void)updateViewFrame;

@end
