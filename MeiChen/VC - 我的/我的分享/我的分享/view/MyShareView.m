//
//  MyShareView.m
//  meirong
//
//  Created by yangfeng on 2019/3/1.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyShareView.h"
#import "MyShareItem.h"

static NSString *identifier = @"itemCell";

@interface MyShareView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    ShareModel *data;
}

@end

@implementation MyShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyShareView" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.lab_1.text = NSLocalizedString(@"MyShareVC_2", nil);
        self.lab_2.text = NSLocalizedString(@"MyShareVC_3", nil);
        self.labShare.text = NSLocalizedString(@"MyShareVC_4", nil);
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 30.0;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collview.delegate = self;
        _collview.dataSource = self;
        _collview.alwaysBounceVertical = YES;
        _collview.bounces = NO;
        _collview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_collview registerClass:[MyShareItem class] forCellWithReuseIdentifier:identifier];
        [_collview reloadData];
    }
    return self;
}

- (void)loadData:(ShareModel *)model {
    data = model;
    NSString *title = [model.base_info.sex integerValue]==1?NSLocalizedString(@"MyShareVC_5", nil):NSLocalizedString(@"MyShareVC_6", nil);
    self.labName.text = [NSString stringWithFormat:@"%@%@",title,[UserData shareInstance].user.nickname];
    
    if (model.card != nil) {
        self.labCard.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"MyShareVC_7", nil),model.card.card_title];
    }
    else {
        self.labCard.text = NSLocalizedString(@"MyShareVC_8", nil);
    }
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.base_info.avatar]];
    self.labValue_1.text = [NSString stringWithFormat:@"%ld",model.commission_points];
    self.labValue_2.text = [NSString stringWithFormat:@"%ld",model.commission_num_direct];
    self.shareCount.text = [NSString stringWithFormat:@"%ld%@",model.share_times_remain,NSLocalizedString(@"MyShareVC_10", nil)];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return data.share_minterms.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyShareItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadData:data.share_minterms[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (collectionView.frame.size.width-12*3)/2.0;
    CGFloat h = w*(95.0/170.0);
    return  CGSizeMake(w, h);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);//上 左 下 右
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}
// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
