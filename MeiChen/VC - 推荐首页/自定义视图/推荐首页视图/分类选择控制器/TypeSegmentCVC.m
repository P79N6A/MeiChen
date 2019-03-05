//
//  SegmentController.m
//  meirong
//
//  Created by yangfeng on 2018/12/17.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "TypeSegmentCVC.h"
#import "SegmentCell.h"

@interface TypeSegmentCVC ()
@property(nonatomic,strong) UIFont *titleFont;
@property(nonatomic,copy) NSArray *productArray;
@end

@implementation TypeSegmentCVC

static NSString * const reuseIdentifier = @"SegmentCell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.productArray = [NSArray array];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SegmentCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - 提供外界集合视图的数据
- (void)reloadTypeSegmentCVCData:(NSArray *)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"菜单 主线程---- %@， count = %lu",[NSThread mainThread], array.count);
        self.productArray = [NSArray arrayWithArray:array];
        [self.collectionView reloadData];
    });
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont boldSystemFontOfSize:16];
    }
    return _titleFont;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    id obj = self.productArray[indexPath.row];
    if ([obj isKindOfClass:[PlanStyleModel class]]) {
        PlanStyleModel *model = (PlanStyleModel *)obj;
        cell.titleLab.text = model.tag_name;
    }
    else {
        MenuModel *model = (MenuModel *)obj;
        cell.titleLab.text = model.name;
    }
    
    cell.titleLab.font = self.titleFont;
    if (indexPath.row == self.selectIndex) {
        cell.titleLab.transform = CGAffineTransformMakeScale(1.25,1.25);
        cell.titleLab.textColor = [UIColor colorWithRed:82/255.0 green:184/255.0 blue:204/255.0 alpha:1.0];
    }
    else {
        //取消形变
        cell.titleLab.transform = CGAffineTransformIdentity;
        cell.titleLab.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.productArray[indexPath.row];
    CGSize size;
    if ([obj isKindOfClass:[PlanStyleModel class]]) {
        PlanStyleModel *model = (PlanStyleModel *)obj;
        size = [model.tag_name sizeWithAttributes:@{NSFontAttributeName: self.titleFont}];
    }
    else {
        MenuModel *model = (MenuModel *)obj;
        size = [model.name sizeWithAttributes:@{NSFontAttributeName: self.titleFont}];
    }
    return  CGSizeMake(size.width + 24, collectionView.frame.size.height);
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// 在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [collectionView reloadData];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    _block(indexPath.row);
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}




@end
