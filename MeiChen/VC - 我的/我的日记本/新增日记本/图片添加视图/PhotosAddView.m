//
//  PhotosAddView.m
//  meirong
//
//  Created by yangfeng on 2019/2/16.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosAddView.h"
#import "ImageEditCell.h"
#import "PhotosVC.h"
#import "CameraVC.h"
#import "imageBrowser.h"

static NSString *identifier = @"PhototsEditCell";

@interface PhotosAddView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    CGRect oldFrame;
}
@end

@implementation PhotosAddView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PhotosAddView" owner:nil options:nil] firstObject];
        self.frame = frame;
        _left = 12;
        _top = 12;
        _cell_w = 60;
        _MaxCount = 1;
        _ColumnsCount = 1;
        _updateFrame = NO;
        _isleft = NO;
        
        self.collview.delegate = self;
        self.collview.dataSource = self;
        self.collview.alwaysBounceVertical = YES;
        self.collview.bounces = NO;
        self.collview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.collview registerClass:[ImageEditCell class] forCellWithReuseIdentifier:identifier];
        
        oldFrame = frame;
        _images = [NSMutableArray array];
        
        self.collview.frame = ({
            CGRect frame = self.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame;
        });
    }
    return self;
}

- (void)updateViewFrame {
    if (_updateFrame) {
        NSInteger count = [self arrCount];
        CGFloat maxWidth = _cell_w*_ColumnsCount+_left*(_ColumnsCount-1);
        CGFloat width = count>_ColumnsCount?(maxWidth):(_cell_w*count+_left*(count-1));
        NSInteger shang = count/_ColumnsCount;
        NSInteger yushu = count%_ColumnsCount;
        CGFloat height;
        if (yushu == 0) {
            height = _cell_w*(shang)+_top*2+_left*(shang-1);
        }
        else {
            height = _cell_w*(shang+1)+_top*2+_left*shang;
        }
        self.frame = ({
            CGRect frame = self.frame;
            frame.size.width = width;
            frame.origin.x = _isleft?(0):(maxWidth - width);
            frame.size.height = height;
            frame;
        });
        if (self.framblock) {
            self.framblock(self.frame);
        }
    }
}
- (void)setUpdateFrame:(BOOL)updateFrame {
    _updateFrame = updateFrame;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (void)setTop:(CGFloat)top {
    _top = top;
    [self.collview reloadData];
}
- (void)setLeft:(CGFloat)left {
    _left = left;
    [self.collview reloadData];
}
- (void)setCell_w:(CGFloat)cell_w {
    _cell_w = cell_w;
    [self.collview reloadData];
}
- (void)setMaxCount:(NSInteger)MaxCount {
    _MaxCount = MaxCount;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (void)setColumnsCount:(NSInteger)ColumnsCount {
    _ColumnsCount = ColumnsCount;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (void)setIsleft:(BOOL)isleft {
    _isleft = isleft;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (void)setOnlyShow:(BOOL)onlyShow {
    _onlyShow = onlyShow;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (void)setImages:(NSMutableArray *)images {
    _images = images;
    [self updateViewFrame];
    [self.collview reloadData];
}
- (NSInteger)arrCount {
    if (_onlyShow) {
        return _images.count;
    }
    if (_images.count >= self.MaxCount) {
        return _images.count;
    }
    return _images.count + 1;
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
    if (_onlyShow) {
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.row]]];
    }
    else {
        if (self.images.count == indexPath.row) {
            cell.icon.image = [UIImage imageNamed:@"添加照片"];
        }
        else {
            id obj = _images[indexPath.row];
            if ([obj isKindOfClass:[UIImage class]]) {
                cell.icon.image = _images[indexPath.row];
            }
            else if ([obj isKindOfClass:[NSString class]]) {
                [cell.icon sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.row]]];
            }
        }
    }
    
    if ([self arrCount] <= self.MaxCount && [self arrCount] - 1 == indexPath.row && self.images.count < self.MaxCount) {
        cell.deleteBu.hidden = YES;
    }
    else {
        cell.deleteBu.hidden = NO;
    }
    if (_onlyShow) {
        cell.deleteBu.hidden = YES;
    }
    cell.icon.backgroundColor = kColorRGB(0xf0f0f0);
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    cell.deleteBu.tag = indexPath.row;
    [cell.deleteBu addTarget:self action:@selector(DeleteButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell SettingDeleteButtonWidth:(self.cell_w * (40.0 / 111.0))];
    
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [self getCurrentViewController];
    
    if (_onlyShow) {
        [[imageBrowser shareInstance] showImagesWith:self.images index:indexPath.row];
        return;
    }

    NSInteger count = self.images.count;
    if (count == self.MaxCount) {
        [[imageBrowser shareInstance] showImagesWith:self.images index:indexPath.row];
    }
    else if ([self arrCount] == indexPath.row + 1) {
        [self showAlert:vc];
    }
    else {
        [[imageBrowser shareInstance] showImagesWith:self.images index:indexPath.row];
    }
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cell_w, self.cell_w);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.top, 0, self.top, 0);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.left;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.left;
}

// 删除照片
- (void)DeleteButtonMethod:(UIButton *)sender {
    [self.images removeObjectAtIndex:sender.tag];
    [self updateViewFrame];
    [self.collview reloadData];
}

- (void)AddImages:(NSArray *)images {
    [_images addObjectsFromArray:images];
    [self updateViewFrame];
    [self.collview reloadData];
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
        vc2.maxCount = self.MaxCount - self.images.count;   // 还可再添加多少张图片
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

- (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){//1、tabBarController
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){//2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}



@end
