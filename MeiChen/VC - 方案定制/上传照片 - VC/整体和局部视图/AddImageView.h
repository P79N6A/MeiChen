//
//  AddImageView.h
//  meirong
//
//  Created by yangfeng on 2019/1/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockFrame)(void);
typedef void(^blockIndexPath)(NSInteger tag, NSInteger row);
@interface AddImageView : UIView

@property (nonatomic, copy) blockFrame block;
@property (nonatomic, copy) blockIndexPath blockIndex;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UIButton *exampleBu;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UICollectionView *collView;

- (NSInteger)arrCount;

- (void)AddImages:(NSArray *)images;

- (void)showAlert:(UIViewController *)vc;

@end
