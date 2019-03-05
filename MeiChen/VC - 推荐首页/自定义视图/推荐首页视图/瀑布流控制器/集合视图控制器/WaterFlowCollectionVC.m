//
//  WaterFlowCollectionVC.m
//  meirong
//
//  Created by yangfeng on 2018/12/14.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "WaterFlowCollectionVC.h"
#import "WaterFlowLayout.h"
#import "WaterFlowCell.h"
#import "UIImage+ImgSize.h"
#import "MJRefresh.h"
#import "SearchVCData.h"
#import "RecommendHomePageData.h"

@interface WaterFlowCollectionVC () <WaterFlowLayoutDelegate> {
    CGFloat lastContentOffset;  // 开始滑动时的位置
}

@property(nonatomic, copy)NSArray *productArray;

@end


@implementation WaterFlowCollectionVC

static NSString * const reuseIdentifier = @"WaterFlowCollectionCell";
static NSString * const HeaderIdentifier = @"WaterFlowCollectionHeaderCell";

-(instancetype)init{
    WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterFlowCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _productArray = [NSArray array];
}

//头尾视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat w = collectionView.frame.size.width;
    CGFloat h = 44 + statusRect.size.height;
    return CGSizeMake(w, h);
}

//设置页眉
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    
    if(kind == UICollectionElementKindSectionHeader){
        header.backgroundColor = [UIColor redColor];
    }
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 外界提供数据
- (void)reloadWaterFlowCollectionVCData:(NSArray *)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        _productArray = [NSArray arrayWithArray:array];
        [self.collectionView reloadData];
    });
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell loadData:self.productArray[indexPath.row]];
    [cell.zan addTarget:self action:@selector(ZanMethod:) forControlEvents:UIControlEventTouchUpInside];
    cell.zan.tag = indexPath.row;
    return cell;
}

- (void)ZanMethod:(UIButton *)sender {
    if (self.ZanSelect) {
        self.ZanSelect(sender);
    }
}

#pragma mark <WaterfallCollectionViewDelegate>

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    // 获取图片的宽高，根据图片的比例计算Item的高度。
    ListModel *model = self.productArray[index];
    NSString *url = model.cover_img;
    
    CGSize labSize = [Tools sizeWithFont:[UIFont boldSystemFontOfSize:13] maxSize:CGSizeMake(itemWidth - 20, MAXFLOAT) string:model.brief.brief];
//    NSLog(@"labSize = %@, index = %ld",NSStringFromCGSize(labSize), index);
    CGFloat lab_h = labSize.height;
    if (lab_h > 32) {
        lab_h = 32;
    }
//    CGFloat itemHeight;
//    NSInteger yushu = index%3;
//    if (yushu==0) {
//        itemHeight = itemWidth * (221.0/170.0);
//    }
//    else if (yushu==1) {
//        itemHeight = itemWidth * (125.0/170.0);
//    }
//    else {
//        itemHeight = itemWidth * (156.0/170.0);
//    }
    CGFloat itemHeight;
    //获取图片尺寸时先检查是否有缓存(有就不用再获取了)
    if (![[NSUserDefaults standardUserDefaults] objectForKey:url]) {
        //这里拿到每个图片的尺寸，然后计算出每个cell的高度
        CGSize imageSize = [UIImage getImageSizeWithURL:url];
        if (imageSize.width == 0) {
            itemHeight = itemWidth * (221.0/170.0);
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
    return itemHeight + 60 + lab_h;
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
    switch (self.hasHeader) {
        case 1: {
            return UIEdgeInsetsMake(12 + 44, 12, 12, 12);
        }
            break;
        case 2: {
            return UIEdgeInsetsMake(12 + 44, 12, 12, 12);
        }
        default:
            break;
    }
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
    
    //    lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y - lastContentOffset;
//    if (offset < 0) {
//        //向上
//    }
//    else if (offset > 0) {
//        //向下
//    }
    if (_scrollIndex) {
        _scrollIndex(offset);
    }
}


- (void)setHasHeader:(NSInteger)hasHeader {
    _hasHeader = hasHeader;
    [self example21];
}

#pragma mark UICollectionView 上下拉刷新
- (void)example21 {
    switch (self.hasHeader) {
        case 0: {
            // 下拉刷新
            [self addPullRefresh];
            // 上拉加载更多
            [self addPushRefresh];
            break;
        }
        case 1: {
//            // 上拉加载更多
//            [self addPullRefresh];
        }
        default:
            break;
    }
}

// 下拉刷新
- (void)addPullRefresh {
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = KIsiPhoneX?34:0;
    // 下拉刷新
    MJYFGifHeader *header = [MJYFGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
}

// 上拉加载更多
- (void)addPushRefresh {
    // 上拉刷新
    MJYFGifFooter *footer = [MJYFGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    self.collectionView.mj_footer = footer;
}

// 下拉刷新
- (void)pullData {
    switch (self.hasHeader) {
        case 0: {
            if (self.view.tag == 0) {
                [[RecommendHomePageData shareInstance] RequestHotCaseWithPull:^(NSError *error) {
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }];
            }
            else {
                [[RecommendHomePageData shareInstance] RequestTypeCaseWithPullWithType:self.view.tag callback:^(NSError *error) {
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }];
            }
            break;
        }
        case 1: {
            
            break;
        }
        default:
            break;
    }
}

// 上拉加载更多
- (void)pushData {
    switch (self.hasHeader) {
        case 0: {
            if (self.view.tag == 0) {
                [[RecommendHomePageData shareInstance] RequestHotCaseWithPush:^(NSError *error) {
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }];
            }
            else {
                [[RecommendHomePageData shareInstance] RequestTypeCaseWithPushWithType:self.view.tag callback:^(NSError *error) {
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }];
            }
            break;
        }
        case 1: {

            break;
        }
        case 2: {
            
            break;
        }
        default:
            break;
    }
}

@end
