//
//  AddImageView.m
//  meirong
//
//  Created by yangfeng on 2019/1/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AddImageView.h"
#import "ImageEditCell.h"
#import "PhotosVC.h"
#import "CameraVC.h"

static NSString *identifier = @"ImageEditCell";
@interface AddImageView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    CGFloat left;
    CGFloat top;
    CGFloat cell_w;
}

@end

@implementation AddImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        left = 12;
        top = 15;
        // 整体
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLab.font = [UIFont boldSystemFontOfSize:18];
        self.titleLab.frame = CGRectMake(left, top, 100, 17);
        [self addSubview:self.titleLab];
        
        // 请上传正面及侧面照
        self.detailLab = [[UILabel alloc]init];
        self.detailLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.detailLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
        self.detailLab.frame = CGRectMake(left, CGRectGetMaxY(self.titleLab.frame) + top, 250, 15);
        [self addSubview:self.detailLab];
        
        // 示例
        CGFloat bu_w = 50;
        CGFloat bu_h = 25;// 示例按钮背景
        self.exampleBu = [[UIButton alloc]init];
        [self.exampleBu setBackgroundImage:[UIImage imageNamed:@"示例按钮背景"] forState:(UIControlStateNormal)];
        [self.exampleBu setTitle:NSLocalizedString(@"UploadImageVC_6", nil) forState:UIControlStateNormal];
        self.exampleBu.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 12];
        [self.exampleBu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.exampleBu.frame = CGRectMake(CGRectGetWidth(frame) - left - bu_w, 42, bu_w, bu_h);
        [self addSubview:self.exampleBu];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 100) collectionViewLayout:layout];
        self.collView.delegate = self;
        self.collView.dataSource = self;
        self.collView.alwaysBounceVertical = YES;
        self.collView.bounces = NO;
        self.collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.collView registerClass:[ImageEditCell class] forCellWithReuseIdentifier:identifier];
        self.collView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collView];
        _images = [NSMutableArray array];
        
        [self reloadLayout];
    }
    return self;
}

- (void)AddImages:(NSArray *)images {
    [_images addObjectsFromArray:images];
    [self reloadLayout];
}

- (NSInteger)arrCount {
    if (_images.count >= 6) {
        return _images.count;
    }
    return _images.count + 1;
}

- (void)reloadLayout {
    if (_images == nil) {
        return;
    }
    
    CGFloat y_1 = CGRectGetMaxY(self.detailLab.frame);
    cell_w = (self.frame.size.width - left * 4) / 3.0;
    NSInteger k = [self arrCount];
    if (k > 6) {
        k = 6;
    }
    
    CGFloat self_h = y_1;
    if ([self arrCount] <= 3) {
        self_h = y_1 + top * 2 + cell_w;
    }
    else {
        self_h = y_1 + top * 3 + cell_w * 2;
    }
    self.frame = ({
        CGRect frame = self.frame;
        frame.size.height = self_h;
        frame;
    });
    self.collView.frame = ({
        CGRect frame = self.collView.frame;
        frame.size.height = self_h;
        frame.origin.y = y_1;
        frame;
    });
    [self.collView reloadData];
    if (_block) {
        _block();
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self arrCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.images.count == indexPath.row) {
        cell.icon.image = [UIImage imageNamed:@"添加照片"];
    }
    else {
        cell.icon.image = _images[indexPath.row];
    }
    
    if ([self arrCount] <= 6 && [self arrCount] - 1 == indexPath.row && self.images.count < 6) {
        cell.deleteBu.hidden = YES;
    }
    else {
        cell.deleteBu.hidden = NO;
    }
    [cell SettingDeleteButtonWidth:(cell_w * (40.0 / 111.0))];
    cell.deleteBu.tag = indexPath.row;
    [cell.deleteBu addTarget:self action:@selector(DeleteButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_blockIndex) {
        _blockIndex(collectionView.tag, indexPath.row);
    }
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cell_w, cell_w);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(top, left, top, left);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return left;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return left;
}





// 删除照片
- (void)DeleteButtonMethod:(UIButton *)sender {
    [self.images removeObjectAtIndex:sender.tag];
    [self.collView reloadData];
    [self reloadLayout];
}

- (void)showAlert:(UIViewController *)vc {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_9", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        CameraVC *vc2 = [[CameraVC alloc]init];
        __weak typeof(self) weakSelf = self;
        vc2.blockimage = ^(UIImage *image) {
            [weakSelf AddImages:@[image]];
        };
        [vc2 checkCameraPermission:vc pushvc:vc2 can:YES];
    }];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_10", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        PhotosVC *vc2 = [[PhotosVC alloc]init];
        vc2.indexNumber = 2;
        vc2.maxCount = 6 - self.images.count;   // 还可再添加多少张图片
        __weak typeof(self) weakSelf = self;
        vc2.blockimage = ^(NSArray *imagesArr) {
            [weakSelf AddImages:imagesArr];
        };
        [vc2 checkPhotoPermission:vc pushvc:vc2 Push:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_11", nil) style:(UIAlertActionStyleCancel) handler:nil];
    
    [controller addAction:action_1];
    [controller addAction:action_2];
    [controller addAction:cancel];
    
    [vc presentViewController:controller animated:YES completion:nil];
}

@end
