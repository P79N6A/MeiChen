//
//  MyPlanView_2.m
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanView_2.h"
#import "MyPlanItem.h"

static NSString *identifier = @"CellItem";

@interface MyPlanView_2 () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation MyPlanView_2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyPlanView_2" owner:nil options:nil] firstObject];
//        defaultHeight = 142;//329;
        self.frame = ({
            CGRect rect = frame;
            rect.size.height = 142;
            rect;
        });
        self.m_array = [NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collView.collectionViewLayout = layout;
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.alwaysBounceVertical = YES;
    self.collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collView registerClass:[MyPlanItem class] forCellWithReuseIdentifier:identifier];
    self.collView.backgroundColor = [UIColor clearColor];
    
    [self titleLabel:NSLocalizedString(@"MyPlanVC_3", nil)];
}

// 推荐案例
- (void)titleLabel:(NSString *)str {
    self.titleLab.text = str;
    self.titleLab.backgroundColor = [UIColor clearColor];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.m_array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPlanItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionDelegate 集合试图协议
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(220, 80);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 15, 0);//上 左 下 右
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}
// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12.0;
}





@end
