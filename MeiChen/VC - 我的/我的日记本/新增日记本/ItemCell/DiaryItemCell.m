//
//  DiaryItemCell.m
//  meirong
//
//  Created by yangfeng on 2019/2/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "DiaryItemCell.h"
#import "ImageEditCell.h"
#import "PhotosVC.h"
#import "CameraVC.h"
#import "imageBrowser.h"

static NSString *identifier = @"PhototsEditCell";

@interface DiaryItemCell () <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate> {
    NSString *defaultStr;
}
@end

@implementation DiaryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _MaxCount = 6;
    _columns = 4;
    _gap = 12;
    _cell_w = 40;
    defaultStr = NSLocalizedString(@"MyDiaryVC_13", nil);
    
    self.collview.delegate = self;
    self.collview.dataSource = self;
    self.collview.alwaysBounceVertical = YES;
    self.collview.bounces = NO;
    self.collview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.collview registerClass:[ImageEditCell class] forCellWithReuseIdentifier:identifier];
    self.collview.backgroundColor = [UIColor clearColor];
    
    [self ButtDefaultTitle];
    [self MessageDefaultText];
    
    self.message.delegate = self;
    
    _images = [NSMutableArray array];
    
}

- (void)loadDataWith:(DailyDetailItem *)item {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.photo_at integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter  stringFromDate:date];
    [self.timeButt setTitle:str forState:(UIControlStateNormal)];
    
    if (item.brief != nil && item.brief.length > 0) {
        [self MessageText:item.brief];
    }
    else {
        [self MessageDefaultText];
    }
    
    // 设置按钮 删除按钮
    if ([item.status isEqualToString:@"WAIT_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_24", nil) forState:(UIControlStateNormal)];
        [self.butt setTitleColor:kColorRGB(0x999999) forState:(UIControlStateNormal)];
        self.dele.hidden = YES;
        self.message.userInteractionEnabled = NO;
        
    }
    else if ([item.status isEqualToString:@"IS_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_25", nil) forState:(UIControlStateNormal)];
        [self.butt setTitleColor:kColorRGB(0x999999) forState:(UIControlStateNormal)];
        self.dele.hidden = YES;
        self.message.userInteractionEnabled = NO;
        
    }else if ([item.status isEqualToString:@"UN_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_26", nil) forState:(UIControlStateNormal)];
        [self.butt setTitleColor:kColorRGB(0x999999) forState:(UIControlStateNormal)];
        self.dele.hidden = NO;
        self.message.userInteractionEnabled = YES;
    }
    else {
        [self ButtDefaultTitle];
        self.dele.hidden = NO;
        self.message.userInteractionEnabled = YES;
    }
    
}

- (void)ButtDefaultTitle {
    [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_12", nil) forState:(UIControlStateNormal)];
    [self.butt setTitleColor:kColorRGB(0x21C9D9) forState:(UIControlStateNormal)];
}

- (void)ButtTitleWith:(NSString *)status {
    if ([status isEqualToString:@"WAIT_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_24", nil) forState:(UIControlStateNormal)];
    }
    else if ([status isEqualToString:@"IS_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_25", nil) forState:(UIControlStateNormal)];
    }else if ([status isEqualToString:@"UN_PASS"]) {
        [self.butt setTitle:NSLocalizedString(@"MyDiaryVC_26", nil) forState:(UIControlStateNormal)];
    }
    [self.butt setTitleColor:kColorRGB(0x999999) forState:(UIControlStateNormal)];
}

- (void)MessageDefaultText {
    self.message.text = defaultStr;
    self.message.textColor = kColorRGB(0x999999);
    self.message.backgroundColor = [UIColor clearColor];
}
- (void)MessageText:(NSString *)text {
    self.message.text = text;
    self.message.textColor = kColorRGB(0x333333);
    self.message.backgroundColor = [UIColor clearColor];
}

- (NSInteger)arrCount {
    if (_onlyShow) {
        return _images.count;
    }
    if (_images.count >= _MaxCount) {
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
    cell.icon.backgroundColor = kColorRGB(0xf0f0f0);
    
    if ([self arrCount] <= _MaxCount && [self arrCount] - 1 == indexPath.row && self.images.count < _MaxCount) {
        cell.deleteBu.hidden = YES;
    }
    else {
        cell.deleteBu.hidden = NO;
    }
    if (_onlyShow) {
        cell.deleteBu.hidden = YES;
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    cell.deleteBu.tag = indexPath.row;
    [cell.deleteBu addTarget:self action:@selector(DeleteButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell SettingDeleteButtonWidth:(_cell_w * (40.0 / 111.0))];
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
    if (count == _MaxCount) {
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
    return CGSizeMake(_cell_w, _cell_w);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//上 左 下 右
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _gap;
}

// 列间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _gap;
}

// 删除照片
- (void)DeleteButtonMethod:(UIButton *)sender {
    [self.images removeObjectAtIndex:sender.tag];
    [self.collview reloadData];
    if (self.reloadblock) {
        self.reloadblock(self.images, self.tag);
    }
}

- (void)AddImages:(NSArray *)images {
    [_images addObjectsFromArray:images];
    [self.collview reloadData];
    if (self.reloadblock) {
        self.reloadblock(self.images, self.tag);
    }
}

- (void)showAlert:(UIViewController *)vc {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
        vc2.maxCount = _MaxCount - self.images.count;   // 还可再添加多少张图片
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

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:defaultStr]) {
        [self MessageText:@""];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textblock) {
        self.textblock(textView.text, self.tag);
    }
    if (textView.text.length <= 0) {
        [self MessageDefaultText];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
