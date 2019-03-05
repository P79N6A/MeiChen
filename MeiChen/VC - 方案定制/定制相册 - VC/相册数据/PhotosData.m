//
//  PhotosData.m
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "PhotosData.h"

@interface PhotosData () {
    NSInteger maxSelect;
}

@property (nonatomic, strong) NSMutableArray *m_select;     // 选择的图片

@property (nonatomic, strong) NSMutableArray *photos_;   // 所有照片的缩略图 （对外）
@property (nonatomic, strong) NSMutableArray *photosName_;   // 所有照片的缩略图 （对外）

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *images;

@property (nonatomic, strong) NSMutableArray *photosArray;   // 所有照片的缩略图 （对内）
@property (nonatomic, strong) NSMutableArray *photosNameArray;   // 所有照片的缩略图 （对内）

@end

@implementation PhotosData

- (instancetype)init {
    if (self = [super init]) {
        _m_select = [NSMutableArray array];
        
        _photos_ = [NSMutableArray array];
        _photosName_ = [NSMutableArray array];
        _images = [NSMutableArray array];
        
        _photosArray = [NSMutableArray array];
        _photosNameArray = [NSMutableArray array];
        
        maxSelect = 9;
    }
    return self;
}

#pragma mark - 某个相册的数据
- (NSInteger)numbersOfSections {
    return _photos_.count;
}
- (NSInteger)numbersOfRowIntSection:(NSInteger)section {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:_photos_[section]];
    return arr.count;
}
- (NSString *)titleOfSection:(NSInteger)section {
    return _photosName_[section];
}
- (PHAsset *)numberOfAssetWithSection:(NSInteger)section row:(NSInteger)row {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:_photos_[section]];
    if (arr.count > row) {
        return arr[row];
    }
    return nil;
}
- (void)loadImageWithSection:(NSInteger)section blackImage:(void(^)(UIImage *image))blackImage {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:_photos_[section]];
    PHAsset *asset = [arr lastObject];
    [self loadImageWithAsset:asset original:YES blackImage:^(UIImage *image) {
        blackImage(image);
    }];
}
- (void)loadImageWithSection:(NSInteger)section row:(NSInteger)row blackImage:(void(^)(UIImage *image))blackImage {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:_photos_[section]];
    PHAsset *asset = arr[row];
    [self loadImageWithAsset:asset original:YES blackImage:^(UIImage *image) {
        blackImage(image);
    }];
}

#pragma mark - 获取所有照片的数据
- (NSInteger)numbersOfAllImages {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:[_photos_ firstObject]];
    return arr.count;
}
- (PHAsset *)numberOfAssetWithRow:(NSInteger)row {
    NSArray<PHAsset *> *arr = [NSArray arrayWithArray:[_photos_ firstObject]];
    if (arr.count > row) {
        return arr[row];
    }
    return nil;
}
- (void)loadImageWithRow:(NSInteger)row blackImage:(void(^)(UIImage *image))blackImage {
    PHAsset *asset = [self numberOfAssetWithRow:row];
    [self loadImageWithAsset:asset original:NO blackImage:^(UIImage *image) {
        blackImage(image);
    }];
}


#pragma mark - 已经选择的相片
- (NSInteger)numbersOfSelect {
    return self.m_select.count;
}
- (void)selectImageWith:(BOOL)select section:(NSInteger)section row:(NSInteger)row {
    // 最多选9张
    if (_m_select.count >= maxSelect && !select) {
        return;
    }
    
    PHAsset *asset = [self numberOfAssetWithSection:section row:row];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    if (!select) {
        if (![self.m_select containsObject:asset]) {
            [self.m_select addObject:asset];
        }
        if (![_images containsObject:indexpath]) {
            [_images addObject:indexpath];
        }
    }
    else {
        if ([self.m_select containsObject:asset]) {
            [self.m_select removeObject:asset];
        }
    }
}
- (BOOL)haveAssetInSection:(NSInteger)section row:(NSInteger)row {
    PHAsset *asset = [self numberOfAssetWithSection:section row:row];
    if ([self.m_select containsObject:asset]) {
        return YES;
    }
    return NO;
}
- (NSString *)titleButtonWithSection:(NSInteger)section row:(NSInteger)row {
    PHAsset *asset = [self numberOfAssetWithSection:section row:row];
    if ([self.m_select containsObject:asset]) {
        NSInteger k = [self.m_select indexOfObject:asset];
        return [NSString stringWithFormat:@"%ld",k + 1];
    }
    return nil;
}
- (NSArray<NSIndexPath *> *)indexPathArray {
    return _images;
}
- (void)deleteIndexPathWith:(BOOL)select section:(NSInteger)section row:(NSInteger)row {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    if (!select && [_images containsObject:indexpath]) {
        [_images removeObject:indexpath];
    }
}

#pragma mark - 加载图片
- (void)loadImageWithAsset:(PHAsset *)asset original:(BOOL)original blackImage:(void(^)(UIImage *image))blackImage  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (asset != nil) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            
            CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
            
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result == nil) {
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                blackImage(result);
                            });
                        }
                    }];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        blackImage(result);
                    });
                }
            }];
        }
    });
}


// 加载已经选择的图片
- (void)LoadSelectImagesArray:(void(^)(NSArray<UIImage *> *array))blackImage {
    NSMutableArray<UIImage *> *m_arr = [NSMutableArray array];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;

    dispatch_group_t group =  dispatch_group_create();
    
    for (int i = 0; i < _m_select.count; i ++) {
        PHAsset *asset = _m_select[i];
        if (asset != nil) {
            [m_arr addObject:[UIImage new]];
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self ImageWith:asset options:options original:YES blackImage:^(UIImage *image) {
                    if (image != nil) {
                        [m_arr replaceObjectAtIndex:i withObject:image];
                    }
                }];
            });
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        blackImage(m_arr);
    });
}

// 获取图片
- (void)ImageWith:(PHAsset *)asset options:(PHImageRequestOptions *)options original:(BOOL)original blackImage:(void(^)(UIImage *image))blackImage  {
    CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result == nil) {
            CGSize size = !original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                blackImage(result);
            }];
        }
        else {
            blackImage(result);
        }
    }];
}

#pragma mark - 设置最大选择数
- (void)MaxSelectImagesCount:(NSInteger)index {
    maxSelect = index;
}

#pragma mark - 获取所有相机的缩略图
- (void)getAllThumbnailImages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        // 1、获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self k:assetCollection];
        }
        
        // 2、所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *smartCollection in smartAlbums) {
            [self k:smartCollection];
        }
        
        // 3、获得相机胶卷
//        NSLog(@"获得相机胶卷 - 1");
//        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//        [self k:cameraRoll];
//        NSLog(@"获得相机胶卷 - 2");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"所有照片";
            if ([_photosNameArray containsObject:title]) {
                NSInteger k = [_photosNameArray indexOfObject:title];
                if (k != 0) {
                    [_photosNameArray exchangeObjectAtIndex:k withObjectAtIndex:0];
                    [_photosArray exchangeObjectAtIndex:k withObjectAtIndex:0];
                }
            }
            _photos_ = [NSMutableArray arrayWithArray:_photosArray];
            _photosName_ = [NSMutableArray arrayWithArray:_photosNameArray];
            if (_reloadData) {
                _reloadData();
            }
        });
//        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"获取所有照片的缩略图 时间 = %f",time2 - time1);
    });
}
- (void)k:(PHAssetCollection *)assetCollection {
    if (assetCollection.localizedTitle == nil) {
        return;
    }
    if ([assetCollection.localizedTitle isEqualToString:@"最近删除"]) {
        return;
    }
    if ([assetCollection.localizedTitle isEqualToString:@"已隐藏"]) {
        return;
    }

    NSArray<PHAsset *> *arr = [self getAssetsInAssetCollection:assetCollection];
    if (arr.count == 0) {
        return;
    }
//    NSLog(@"相簿名 = %@",assetCollection.localizedTitle);
//
    NSString *name = assetCollection.localizedTitle;
    if ([_photosNameArray containsObject:name]) {
        NSInteger k = [_photosNameArray indexOfObject:name];
//        NSMutableArray *m_arr = [NSMutableArray arrayWithArray:_photosArray[k]];
//        [m_arr addObjectsFromArray:arr];
//        [_photosArray replaceObjectAtIndex:k withObject:arr];
        [_photosArray replaceObjectAtIndex:k withObject:arr];
    }
    else {
        [_photosNameArray addObject:name];
        [_photosArray addObject:arr];
    }
}
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arr addObject:asset];
    }];
    return arr;
}

// 3.遍历相册
/*
*  遍历相簿中的全部图片
*  @param assetCollection 相簿
*  @param original        是否要原图
*/
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;

    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
//        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"%@", result);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_reloadData) {
                _reloadData();
            }
        });
    }
}



@end
