//
//  ImageCVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/17.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ImageCVC.h"
#import "WaterFlowLayout.h"
#import "PhotosCell.h"
#import "UIImage+ImgSize.h"


@interface ImageCVC () <WaterFlowLayoutDelegate> {
    CGFloat lastContentOffset;  // 开始滑动时的位置
    NSInteger typeIndex;
}

@property(nonatomic, copy)NSArray *productArray;
@property(nonatomic, copy)NSArray *selectArray;

@end


@implementation ImageCVC

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init{
    WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotosCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _productArray = [NSArray array];
    
    // 下拉刷新
    [self addPullRefresh];
    // 上拉加载更多
    [self addPushRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 外界提供数据
- (void)reloadWaterFlowCollectionVCData:(NSArray *)array selectArray:(NSArray *)selectArray type:(NSInteger)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        typeIndex = type;
        _productArray = [NSArray arrayWithArray:array];
        _selectArray = [NSArray arrayWithArray:selectArray];
        [self.collectionView reloadData];
    });
}
- (void)updateSelectArray:(NSArray *)selectArray {
    _selectArray = [NSArray arrayWithArray:selectArray];
}

#pragma mark - 选择照片
- (void)SelectButtonMethod:(UIButton *)sender {
    if (_selectButton) {
        self.selectButton(sender);
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ImageModel *model = _productArray[indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.img]];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(SelectButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_selectArray containsObject:model]) {
        cell.button.selected = YES;
        NSInteger k = [_selectArray indexOfObject:model];
        [cell.button setTitle:[NSString stringWithFormat:@"%ld",k + 1] forState:UIControlStateSelected];
    }
    else {
        cell.button.selected = NO;
        [cell.button setTitle:nil forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark <WaterfallCollectionViewDelegate>
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    // 获取图片的宽高，根据图片的比例计算Item的高度。
    ImageModel *model = _productArray[index];
    NSString *url = model.img;

    CGFloat itemHeight;
    //获取图片尺寸时先检查是否有缓存(有就不用再获取了)
    if (![[NSUserDefaults standardUserDefaults] objectForKey:url]) {
        //这里拿到每个图片的尺寸，然后计算出每个cell的高度
        CGSize imageSize = [UIImage getImageSizeWithURL:url];
        if (imageSize.width == 0) {
            itemHeight = 100;
        }
        else {
            itemHeight = imageSize.height * itemWidth / imageSize.width;
        }
        //将最终的自适应的高度 本地化处理
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:itemHeight] forKey:url];
    }
    else {
        itemHeight = [[[NSUserDefaults standardUserDefaults] objectForKey:url] floatValue];
    }
    return itemHeight;
}

- (NSInteger)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout{
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout{
    return 12;
}

- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout{
    return 12;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout{
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSLog(@"选择图片");
    
}

//实现scrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //全局变量记录滑动前的contentOffset
    lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y - lastContentOffset;
    if (_scrollIndex) {
        _scrollIndex(offset);
    }
}

// 下拉刷新
- (void)addPullRefresh {
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = KIsiPhoneX?34:0;
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullData)];
}

// 上拉加载更多
- (void)addPushRefresh {
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushData)];
}

// 下拉刷新
- (void)pullData {
    [self.data requestModelListData:YES];
}

// 上拉加载更多
- (void)pushData {
    [self.data requestModelListData:NO];
}




@end
