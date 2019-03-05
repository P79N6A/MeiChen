//
//  PhotosVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosVC.h"
#import <Photos/Photos.h>   // 导入相册框架
#import "PhotosNavView.h"   // 相册导航栏
#import "PhotosCell.h"      // 集合视图cell
#import "PhotoAlbumCell.h"  // 相簿cell
#import "PhotosCellVC.h"
#import "PhotosBrowserVC.h" // 照片查看器

static NSString *identifier = @"PhotosIdentifier";

@interface PhotosVC () <PhotosNavViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PhotosNavView *navview;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) UITableView *tabview;

@end

@implementation PhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.data == nil) {
        self.data = [[PhotosData alloc]init];
    }
    [self.data getAllThumbnailImages];
    switch (self.indexNumber) {
        case 2: {
            [self.data MaxSelectImagesCount:self.maxCount];
            break;
        }
        default:
            break;
    }
    [self BUildUI];
    __weak typeof(self) weakSelf = self;
    self.data.reloadData = ^{
        NSLog(@"reloadData");
        [weakSelf.collView reloadData];
        [weakSelf.tabview reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadPhotoCellButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data numbersOfSections];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    PhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoAlbumCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = [self.data titleOfSection:indexPath.row];
    cell.count.text = [NSString stringWithFormat:@"(%ld)",[self.data numbersOfRowIntSection:indexPath.row]];
    [self.data loadImageWithSection:indexPath.row blackImage:^(UIImage *image) {
        cell.icon.image = image;
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCellVC *vc = [[PhotosCellVC alloc]init];
    vc.data = self.data;
    vc.section = indexPath.row;
    NSLog(@"section = %ld",indexPath.row);
    __weak typeof(self) weakSelf = self;
    vc.blackdata = ^(PhotosData *data) {
        weakSelf.data = data;
        [weakSelf.collView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


// 点击选择照片
- (void)SelectButtonMeyhod:(UIButton *)sender {
    [self.data selectImageWith:sender.selected section:0 row:sender.tag];
    [self reloadPhotoCellButton];
    [self.data deleteIndexPathWith:sender.selected section:0 row:sender.tag];
}

// 更新按钮
- (void)reloadPhotoCellButton {
    NSMutableArray<NSIndexPath *> *m_arr = [NSMutableArray array];
    for (NSIndexPath *indexPath in [self.data indexPathArray]) {
        if (indexPath.section == 0) {
            [m_arr addObject:indexPath];
            PhotosCell *cell = (PhotosCell *)[self.collView cellForItemAtIndexPath:indexPath];
            [self reloadButtonWith:cell row:indexPath.row];
        }
    }
}

- (void)reloadButtonWith:(PhotosCell *)cell row:(NSInteger)row {
    if ([self.data haveAssetInSection:0 row:row]) {
        cell.button.selected = YES;
        [cell.button setTitle:[self.data titleButtonWithSection:0 row:row] forState:UIControlStateSelected];
    }
    else {
        cell.button.selected = NO;
        [cell.button setTitle:nil forState:UIControlStateNormal];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data numbersOfAllImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.button addTarget:self action:@selector(SelectButtonMeyhod:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = indexPath.row;
    [self reloadButtonWith:cell row:indexPath.row];
    [self.data loadImageWithRow:indexPath.row blackImage:^(UIImage *image) {
        cell.icon.image = image;
    }];
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"放大图片 1 row = %ld",indexPath.row);
    PhotosBrowserVC *vc = [[PhotosBrowserVC alloc]init];
    vc.data = self.data;
    vc.row = indexPath.row;
    vc.section = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat view_w = collectionView.frame.size.width;
    CGFloat gap = 5.0;
    CGFloat cell_w = (view_w - gap * 3) / 4.0;
    return CGSizeMake(cell_w, cell_w);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    CGFloat bu_h = 45;
    // 导航栏
    self.navview = [[PhotosNavView alloc]init];
    self.navview.delegate = self;
    [self.navview SetNav_1];
    [self.view addSubview:self.navview];
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat y = statusRect.size.height + 44;
    
    // 集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - bu_h - CGRectGetHeight(self.navview.frame)) collectionViewLayout:layout];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.alwaysBounceVertical = YES;
    self.collView.bounces = NO;
    self.collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collView registerClass:[PhotosCell class] forCellWithReuseIdentifier:identifier];
    self.collView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collView];
    
    // 完成按钮
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - bu_h, CGRectGetWidth(self.view.frame), bu_h)];
    [bu addTarget:self action:@selector(FinishButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [bu setTitle:NSLocalizedString(@"Photos_2", nil) forState:UIControlStateNormal];
    [bu setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bu];
    
    // 表视图
    self.tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y) style:(UITableViewStylePlain)];
    self.tabview.dataSource = self;
    self.tabview.delegate = self;
    self.tabview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabview.bounces = NO;
    self.tabview.hidden = YES;
    [self.view addSubview:self.tabview];
}

#pragma mark - PhotosNavViewDelegate
- (void)PhotosNavView_LeftItem:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)PhotosNavView_TitleItem:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.collView.hidden = sender.selected;
    self.tabview.hidden = !sender.selected;
}

#pragma mark - 完成按钮
- (void)FinishButtonMethod:(UIButton *)sender {
    switch (self.indexNumber) {
        case 2: {
            if ([[self.data indexPathArray] count] == 0) {
                [self PhotosNavView_LeftItem:nil];
            }
            else {
                // 下载图片
                [SVProgressHUD show];
                [self.data LoadSelectImagesArray:^(NSArray<UIImage *> *array) {
                    [SVProgressHUD dismiss];
                    self.blockimage(array);
                    [self PhotosNavView_LeftItem:nil];
                }];
            }
            break;
        }
        default: {
            if (self.blackdata) {
                self.blackdata(self.data);
            }
            [self PhotosNavView_LeftItem:nil];
            break;
        }
    }
}

#pragma mark - 检测相册权限
- (void)checkPhotoPermission:(UIViewController *)viewController pushvc:(UIViewController *)pushvc Push:(BOOL)push {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    switch (authStatus) {
        case PHAuthorizationStatusNotDetermined: {
            // 0 不确定权限，请求用户授权
            [self NotDetermined:viewController pushvc:pushvc can:push];
            break;
        }
        case PHAuthorizationStatusRestricted: {
            // 1 访问受限制
            
            break;
        }
        case PHAuthorizationStatusDenied: {
            // 2 用户没有授权,提示用户授权
            if (push) {
                [self Denied:viewController];
            }
            break;
        }
            
        case PHAuthorizationStatusAuthorized: {
            // 3 已经授权
            if (push) {
                [self pushFrom:viewController pushvc:pushvc];
            }
            break;
        }
        default:
            break;
    }
}

// 用户没有授权相册，提示用户授权
- (void)Denied:(UIViewController *)viewController {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"camcer_5", nil) message:NSLocalizedString(@"camcer_6", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"camcer_3", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"camcer_4", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:action];
    [controller addAction:cancel];
    
    [viewController presentViewController:controller animated:YES completion:nil];
}

// 请求用户授权
- (void)NotDetermined:(UIViewController *)viewController pushvc:(UIViewController *)pushvc can:(BOOL)can {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined: {
                // 0 不确定权限，请求用户授权
                break;
            }
            case PHAuthorizationStatusRestricted: {
                // 1 访问受限制
                
                break;
            }
            case PHAuthorizationStatusDenied: {
                // 2 用户没有授权,提示用户授权
                
                break;
            }
            case PHAuthorizationStatusAuthorized: {
                // 3 已经授权
                if (can) {
                    [self pushFrom:viewController pushvc:pushvc];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (void)pushFrom:(UIViewController *)vc pushvc:(UIViewController *)pushvc {
    NSLog(@"push");
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc.navigationController pushViewController:pushvc animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
