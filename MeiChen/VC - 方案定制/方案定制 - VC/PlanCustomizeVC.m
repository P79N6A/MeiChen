//
//  PlanCustomizeVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PlanCustomizeVC.h"
#import "PhotosData.h"      // 相册数据
#import "PhotosVC.h"         // 相册控制器
#import "TypeSegmentCVC.h"      // 分类选择集合视图控制器
#import "PlanCustomizeVCData.h"     // 方案定制数据
#import "PlanCustomizeCell.h"
#import "ImageCVC.h"
#import "TabContentView.h"
#import "PhotosCell.h"
#import "UpLoadImageVC.h"   // 上传照片
#import "imageBrowser.h"

static NSString *identifier = @"PlanCustomizeIdentifier";
@interface PlanCustomizeVC () <CustomNavViewDelegate, PlanCustomizeVCDataDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    CGRect oldFrame;
    CGRect newFrame;
    CGFloat cellItem_w;
    CGRect oldTabFrame;
    CGRect newTabFrame;
}
@property (nonatomic, strong) PhotosData *photosdata;
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) TypeSegmentCVC *typeSegCVC;
@property (nonatomic, strong) UIButton *TypeButton;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic,strong) ImageCVC *imagecvc;
@property (nonatomic, strong) PlanCustomizeVCData *data;
@property (nonatomic, strong) UIButton *NextButton;

@end

@implementation PlanCustomizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photosdata = [[PhotosData alloc]init];
    self.data = [[PlanCustomizeVCData alloc]init];
    self.data.delegate = self;
    
    // 下载 风格/部位 数据
    [SVProgressHUD show];
    [self.data requestStyleTopCatData];
    
    [self CreateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger k = [self.photosdata numbersOfSelect];
    [self.navview RightItemIsUpload:k];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat type_h = 44;
    CGFloat bu_h = 45;
    // 1
    self.typeSegCVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navview.frame), width - type_h / 1.5, type_h);
    
    // 2
    self.TypeButton.frame = CGRectMake(width - type_h, self.typeSegCVC.view.frame.origin.y, type_h, type_h);
    oldFrame = CGRectMake(0, CGRectGetMaxY(self.TypeButton.frame), width, 0.1);
    newFrame = CGRectMake(0, CGRectGetMaxY(self.TypeButton.frame), self.view.frame.size.width, cellItem_w * 2.0 + 10);
    self.collView.frame = oldFrame;
    
    // 3
    CGFloat tab_y = CGRectGetMaxY(self.typeSegCVC.view.frame);
    self.imagecvc.view.frame = CGRectMake(0, tab_y, width, height - tab_y - bu_h);
    
    // 4
    self.NextButton.frame = CGRectMake(0, height - bu_h, width, bu_h);
    
    oldTabFrame = CGRectMake(0,tab_y, width, height - tab_y - bu_h);
    newTabFrame = CGRectMake(0, tab_y + CGRectGetHeight(newFrame), width, oldTabFrame.size.height - CGRectGetHeight(newFrame));
}

#pragma mark - PlanCustomizeVCDataDelegate
// 风格/部位 数据 下载成功
- (void)request_StyleTopCat_success {
    [self.typeSegCVC reloadTypeSegmentCVCData:self.data.styleArray];
    // 下载默认模特数据
    [self.data requestModelListData:YES];
    self.typeSegCVC.selectIndex = self.data.currentStyleIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.typeSegCVC.collectionView reloadData];
        [self.typeSegCVC.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.data.currentStyleIndex inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    });
    [self.collView reloadData];
}
// 风格/部位 数据 下载失败
- (void)request_StyleTopCat_fail:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:nil];
    [self CustomNavView_LeftItem:nil];
}
// 模特数据下载成功
- (void)request_ModelList_success {
    [SVProgressHUD dismiss];
    [self.imagecvc.collectionView.mj_footer endRefreshing];
    [self.imagecvc.collectionView.mj_header endRefreshing];
    [self.imagecvc reloadWaterFlowCollectionVCData:[self.data readImageModelData] selectArray:self.data.selectModels type:self.typeSegCVC.selectIndex];
    [self.imagecvc.collectionView reloadData];
}
// 模特数据下载失败
- (void)request_ModelList_fail:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:nil];
    [self.imagecvc.collectionView.mj_footer endRefreshing];
    [self.imagecvc.collectionView.mj_header endRefreshing];
    [self.imagecvc.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.topcatArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlanCustomizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PlanStyleModel *model = self.data.topcatArray[indexPath.row];
    cell.name.text = model.tag_name;
    [cell imvColorWith:indexPath.row];
    if (self.data.currentTopCatIndex == indexPath.row) {
        cell.name.transform = CGAffineTransformMakeScale(1.25,1.25);
        cell.name.textColor = [UIColor colorWithRed:82/255.0 green:184/255.0 blue:204/255.0 alpha:1.0];
    }
    else {
        cell.name.transform = CGAffineTransformIdentity;
        cell.name.textColor = kColorRGB(0x666666);
    }
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (collectionView.tag) {
        case 1: {
            NSLog(@"点击");
            if (indexPath.row != self.data.currentTopCatIndex) {
                if (self.data.selectModels.count != 0) {
                    [self ShowAlert:indexPath.row];
                }
                else {
                    [self selectTopCat:indexPath.row];
                }
            }
            break;
        }
        case 2: {
            // 点击模特图片
            ImageModel *model = [self.data readImageModel:indexPath.row];
            [[imageBrowser shareInstance] showImagesWith:@[model.img] index:indexPath.row];
            break;
        }
        default:
            break;
    }
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellItem_w, cellItem_w);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

#pragma mark - 创建UI
- (void)CreateUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsUpload:0];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"PlanCustomizeVC_2", nil);
    [self.view addSubview:self.navview];
    
    // 分类选择视图
    self.typeSegCVC = [[TypeSegmentCVC alloc]init];
    self.typeSegCVC.view.backgroundColor = [UIColor whiteColor];
    self.typeSegCVC.selectIndex = 0;
    [self addChildViewController:self.typeSegCVC];
    [self.view addSubview:self.typeSegCVC.view];
    __weak typeof(self) weakSelf = self;
    self.typeSegCVC.block = ^(NSInteger row) {
        NSLog(@"选择 item = %ld",row);
        // 切换风格
        [weakSelf.data switchoverStyle:row];
        // 判断是否需要下载新风格的模特数据
        if ([weakSelf.data isNeedToDowmloadStyleData:row]) {
            // 下载新风格的模特数据
            [SVProgressHUD show];
            [weakSelf.data requestModelListData:YES];
        }
        else {
            [weakSelf.imagecvc reloadWaterFlowCollectionVCData:[weakSelf.data readImageModelData] selectArray:weakSelf.data.selectModels type:weakSelf.typeSegCVC.selectIndex];
            [weakSelf.imagecvc.collectionView reloadData];
        }
    };
    
    // 分类按钮
    self.TypeButton = [[UIButton alloc]init];
    [self.TypeButton setImage:[UIImage imageNamed:@"分类"] forState:(UIControlStateNormal)];
    [self.TypeButton setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateSelected];
    [self.TypeButton addTarget:self action:@selector(TypeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.TypeButton];
    
    // 分类类别集合视图
    cellItem_w = (self.view.frame.size.width - 12 * 2 - 10 * 4) / 5.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 44, CGRectGetMaxY(self.navview.frame) + 44, CGRectGetWidth(self.view.frame), 0.1) collectionViewLayout:layout];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.alwaysBounceVertical = YES;
    self.collView.bounces = NO;
    self.collView.tag = 1;
    self.collView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collView registerClass:[PlanCustomizeCell class] forCellWithReuseIdentifier:identifier];
    self.collView.backgroundColor = [UIColor whiteColor];
    
    // 模特列表
    self.imagecvc = [[ImageCVC alloc]init];
    self.imagecvc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    self.imagecvc.view.backgroundColor = kColorRGB(0xf0f0f0);
    self.imagecvc.collectionView.tag = 2;
    self.imagecvc.collectionView.delegate = self;
    self.imagecvc.data = self.data;
    [self addChildViewController:self.imagecvc];
    
    self.imagecvc.selectButton = ^(UIButton *sender) {
        if (!sender.selected) {
            if (weakSelf.data.selectModels.count >= 6) {
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"PlanCustomizeVC_4", nil)];
            }
            else {
                [weakSelf.data SelectImageModel:sender.tag];
                NSArray *indexPathArray = [weakSelf.data selectImageModelIndexPath:weakSelf.data.selectModels];
                [weakSelf.imagecvc updateSelectArray:weakSelf.data.selectModels];
                [UIView performWithoutAnimation:^{
                    [weakSelf.imagecvc.collectionView reloadItemsAtIndexPaths:indexPathArray];
                }];
            }
        }
        else {
            NSArray *arr = [weakSelf.data.selectModels copy];
            [weakSelf.data DeleteImageModel:sender.tag];
            NSArray *indexPathArray = [weakSelf.data selectImageModelIndexPath:arr];
            [weakSelf.imagecvc updateSelectArray:weakSelf.data.selectModels];
            [UIView performWithoutAnimation:^{
                [weakSelf.imagecvc.collectionView reloadItemsAtIndexPaths:indexPathArray];
            }];
        }
    };
    
    // 下一步
    self.NextButton = [[UIButton alloc]init];
    [self.NextButton addTarget:self action:@selector(NextButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.NextButton setTitle:NSLocalizedString(@"PlanCustomizeVC_3", nil) forState:UIControlStateNormal];
    [self.NextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景"] forState:UIControlStateNormal];
    [self.NextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.imagecvc.view];
    [self.view addSubview:self.collView];
    [self.view addSubview:self.NextButton];
}


#pragma Mark - 按钮方法
// 分类按钮方法
- (void)TypeButtonMethod:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.collView.frame = newFrame;
            self.imagecvc.view.frame =  newTabFrame;
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.collView.frame = oldFrame;
            self.imagecvc.view.frame = oldTabFrame;
        }];
    }
}
// 下一步按钮方法
- (void)NextButtonMethod:(UIButton *)sender {
    [SVProgressHUD show];
    [self.photosdata LoadSelectImagesArray:^(NSArray<UIImage *> *array) {
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            UpLoadImageVC *vc = [[UpLoadImageVC alloc]init];
            vc.uploadImagesArray = array;
            vc.serverImagesArray = self.data.selectModels;
            vc.topcatModel = self.data.topcatArray[self.data.currentTopCatIndex];
            vc.styleModel = self.data.styleArray[self.data.currentStyleIndex];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
}


#pragma mark - CustomNavViewDelegate
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionReveal;         //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromBottom; //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    PhotosVC *vc2 = [[PhotosVC alloc]init];
    vc2.data = self.photosdata;
    __weak typeof(self) weakSelf = self;
    vc2.blackdata = ^(PhotosData *data) {
        weakSelf.photosdata = data;
    };
    [vc2 checkPhotoPermission:self pushvc:vc2 Push:YES];
}

#pragma mark - 切换部位弹框
- (void)ShowAlert:(NSInteger)row {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alert_4", nil) message:NSLocalizedString(@"alert_3", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_5", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectTopCat:row];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_6", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:action];
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)selectTopCat:(NSInteger)row {
    // 清除数据
    [self.data CleanData];
    // 切换部位
    [self.data switchoverTopCat:row];
    [self.collView reloadData];
    // 清空模特控制器显示的数据
    [self.imagecvc reloadWaterFlowCollectionVCData:[self.data readImageModelData] selectArray:self.data.selectModels type:self.typeSegCVC.selectIndex];
    [self.imagecvc.collectionView reloadData];
    // 重新下载部位的风格数据
    [SVProgressHUD show];
    [self.data requestModelListData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
