//
//  PhotosData.h
//  meirong
//
//  Created by yangfeng on 2019/1/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>   // 导入相册框架

typedef void (^Reload)(void);
@interface PhotosData : NSObject

@property (nonatomic, copy) Reload reloadData;  //声明一个block属性

#pragma mark - 某个相册的数据
- (NSInteger)numbersOfSections;
- (NSInteger)numbersOfRowIntSection:(NSInteger)section;
- (NSString *)titleOfSection:(NSInteger)section;
- (PHAsset *)numberOfAssetWithSection:(NSInteger)section row:(NSInteger)row;
- (void)loadImageWithSection:(NSInteger)section blackImage:(void(^)(UIImage *image))blackImage;
- (void)loadImageWithSection:(NSInteger)section row:(NSInteger)row blackImage:(void(^)(UIImage *image))blackImage;

#pragma mark - 获取所有照片的数据
- (NSInteger)numbersOfAllImages;
- (PHAsset *)numberOfAssetWithRow:(NSInteger)row;
- (void)loadImageWithRow:(NSInteger)row blackImage:(void(^)(UIImage *image))blackImage;

#pragma mark - 已经选择的相片
- (NSInteger)numbersOfSelect;
- (void)selectImageWith:(BOOL)select section:(NSInteger)section row:(NSInteger)row;
- (BOOL)haveAssetInSection:(NSInteger)section row:(NSInteger)row;
- (NSString *)titleButtonWithSection:(NSInteger)section row:(NSInteger)row;
- (NSArray<NSIndexPath *> *)indexPathArray;
- (void)deleteIndexPathWith:(BOOL)select section:(NSInteger)section row:(NSInteger)row;
// 加载已经选择的图片
- (void)LoadSelectImagesArray:(void(^)(NSArray<UIImage *> *array))blackImage;

#pragma mark - 加载图片
- (void)loadImageWithAsset:(PHAsset *)asset original:(BOOL)original blackImage:(void(^)(UIImage *image))blackImage;

#pragma mark - 设置最大选择数
- (void)MaxSelectImagesCount:(NSInteger)index;

// 2.获得相簿中全部缩略图
- (void)getAllThumbnailImages;

@end
