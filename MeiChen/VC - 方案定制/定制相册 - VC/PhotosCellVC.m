//
//  PhotosCellVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/16.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosCellVC.h"
#import "PhotosNavView.h"   // 相册导航栏
#import "PhotosCell.h"      // 集合视图cell
#import "PhotosBrowserVC.h"   // 相册查看器

static NSString *identifier = @"PhotosCellVCIdentifier";
@interface PhotosCellVC () <PhotosNavViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PhotosNavView *navview;
@property (nonatomic, strong) UICollectionView *collView;

@end

@implementation PhotosCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self BUildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadPhotoCellButton];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.blackdata) {
        self.blackdata(self.data);
    }
}

// 点击选择照片
- (void)SelectButtonMeyhod:(UIButton *)sender {
    [self.data selectImageWith:sender.selected section:self.section row:sender.tag];
    [self reloadPhotoCellButton];
    [self.data deleteIndexPathWith:sender.selected section:self.section row:sender.tag];
}

// 更新按钮
- (void)reloadPhotoCellButton {
    NSMutableArray<NSIndexPath *> *m_arr = [NSMutableArray array];
    for (NSIndexPath *indexPath in [self.data indexPathArray]) {
        if (indexPath.section == self.section) {
            [m_arr addObject:indexPath];
            PhotosCell *cell = (PhotosCell *)[self.collView cellForItemAtIndexPath:indexPath];
            [self reloadButtonWith:cell row:indexPath.row];
        }
    }
}

- (void)reloadButtonWith:(PhotosCell *)cell row:(NSInteger)row {
    if ([self.data haveAssetInSection:self.section row:row]) {
        cell.button.selected = YES;
        [cell.button setTitle:[self.data titleButtonWithSection:self.section row:row] forState:UIControlStateSelected];
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
    return [self.data numbersOfRowIntSection:self.section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.button addTarget:self action:@selector(SelectButtonMeyhod:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = indexPath.row;
    [self reloadButtonWith:cell row:indexPath.row];
    [self.data loadImageWithSection:self.section row:indexPath.row blackImage:^(UIImage *image) {
        cell.icon.image = image;
    }];
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosBrowserVC *vc = [[PhotosBrowserVC alloc]init];
    vc.data = self.data;
    vc.row = indexPath.row;
    vc.section = self.section;
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
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏
    self.navview = [[PhotosNavView alloc]init];
    self.navview.delegate = self;
    [self.navview SetNav_2:[self.data titleOfSection:self.section]];
    [self.view addSubview:self.navview];
    
    // 集合视图
    CGFloat y = statusRect.size.height + 44;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y) collectionViewLayout:layout];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.alwaysBounceVertical = YES;
    self.collView.bounces = NO;
    self.collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collView registerClass:[PhotosCell class] forCellWithReuseIdentifier:identifier];
    self.collView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collView];
}

#pragma mark - PhotosNavViewDelegate
- (void)PhotosNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
