//
//  ServersView.m
//  meirong
//
//  Created by yangfeng on 2019/3/6.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServersView.h"
#import "ServersItem.h"

static NSString *identifier = @"CellItem";

@interface ServersView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat item_w;
    CGFloat gap;
}
@end

@implementation ServersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ServersView" owner:nil options:nil] firstObject];
        self.frame = frame;
        gap = 12;
        item_w = (frame.size.width-gap*3.0)/2.5;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proView.backgroundColor = [UIColor clearColor];
    self.headeLab.text = NSLocalizedString(@"ServersVC_4", nil);
    
    self.ALab_1.text = NSLocalizedString(@"ServersVC_5", nil);
    self.ALab_2.text = NSLocalizedString(@"ServersVC_6", nil);
    [self.Abutt setTitle:NSLocalizedString(@"ServersVC_7", nil) forState:(UIControlStateNormal)];
    [self.Abutt setTitle:NSLocalizedString(@"ServersVC_10", nil) forState:(UIControlStateSelected)];
    self.Abutt.layer.masksToBounds = YES;
    self.Abutt.layer.cornerRadius = self.Abutt.frame.size.height/2.0;
    
    self.BLab_1.text = NSLocalizedString(@"ServersVC_8", nil);
    self.BLab_2.text = NSLocalizedString(@"ServersVC_9", nil);
    [self.Bbutt setTitle:NSLocalizedString(@"ServersVC_7", nil) forState:(UIControlStateNormal)];
    [self.Bbutt setTitle:NSLocalizedString(@"ServersVC_10", nil) forState:(UIControlStateSelected)];
    self.Bbutt.layer.masksToBounds = YES;
    self.Bbutt.layer.cornerRadius = self.Bbutt.frame.size.height/2.0;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collview.collectionViewLayout = layout;
    self.collview.delegate = self;
    self.collview.dataSource = self;
    self.collview.alwaysBounceVertical = YES;
    self.collview.bounces = NO;
    self.collview.showsVerticalScrollIndicator = NO;
    self.collview.showsHorizontalScrollIndicator = NO;
    self.collview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collview registerClass:[ServersItem class] forCellWithReuseIdentifier:identifier];
    self.collview.backgroundColor = [UIColor clearColor];
}

- (void)loadDataWith:(SurgeryModel *)model {
    self.name.text = model.board.brief;
    if ([model.is_book integerValue] == 0) {
        self.proView.hidden = YES;
    }
    else {
        self.proView.hidden = NO;
    }
    
    NSMutableString *m_detail = [NSMutableString string];
    [m_detail appendString:NSLocalizedString(@"ServersVC_14", nil)];
    [m_detail appendString:model.seq];
    [m_detail appendString:@": "];
    for (int i = 0; i < model.items.count; i ++) {
        itemModel *item = model.items[i];
        [m_detail appendString:item.item_name];
        if (i < model.items.count - 1) {
            [m_detail appendString:@"、"];
        }
    }
    self.detial.text = m_detail;
    
    self.m_array = [NSMutableArray arrayWithArray:model.fiche];
    
}


- (void)setM_array:(NSMutableArray *)m_array {
    _m_array = [NSMutableArray arrayWithArray:m_array];
    [self.collview reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.m_array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ServersItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadData:self.m_array[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionDelegate 集合试图协议
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(item_w, collectionView.frame.size.height);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, gap, 0, gap);//上 左 下 右
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return gap;
}
// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return gap;
}

@end
