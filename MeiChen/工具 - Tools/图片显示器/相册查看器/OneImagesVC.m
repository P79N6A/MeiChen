//
//  OneImagesVC.m
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "OneImagesVC.h"

@interface OneImagesVC () <UIScrollViewDelegate> {
    UIImage *thumbImage;
    UIImage *originalImage;
}
@property(nonatomic,retain)UIImageView *imv;
@property(nonatomic,retain)UIScrollView *scroll;
@property(nonatomic)BOOL zoomOut_In;
@end

@implementation OneImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.delegate = self;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    CGSize newSize = self.view.frame.size;
    [_scroll setContentSize:newSize];//_scrollview可以拖动的范围
    _imv = [[UIImageView alloc] init];
    _imv.contentMode = UIViewContentModeScaleAspectFit;
    [_imv setFrame:self.view.frame];
    [_scroll addSubview:_imv];
    
    self.scroll.delegate = self;
    
    UITapGestureRecognizer* tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];//给imageview添加tap手势
    tap.numberOfTapsRequired = 2;//双击图片执行tapGesAction
    self.imv.userInteractionEnabled=YES;
    [self.imv addGestureRecognizer:tap];
    [self.scroll setMinimumZoomScale:1.0];//设置最小的缩放大小
    self.scroll.maximumZoomScale = 10.0;//设置最大的缩放大小
    _zoomOut_In = YES;//控制点击图片放大或缩小
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self loadThumbnailImages];
    [self loadOriginalImages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scroll setContentSize:self.view.frame.size];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - 手势执行事件
-(void)tapGesAction:(UIGestureRecognizer*)gestureRecognizer//手势执行事件
{
    float newscale=0.0;
    if (_zoomOut_In) {
        newscale = 2*1.5;
        _zoomOut_In = NO;
    }else
    {
        newscale = 1.0;
        _zoomOut_In = YES;
    }
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self.scroll zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
}
//当UIScrollView尝试进行缩放的时候调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imv;
}
//当缩放完毕的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    NSLog(@"结束缩放 - %f", scale);
}
//当正在缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"正在缩放.....");
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [self.scroll frame].size.height / scale;
    zoomRect.size.width = [self.scroll frame].size.width / scale;
    zoomRect.origin.x= center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y= center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

// 获取缩略图
- (void)loadThumbnailImages {
    if (originalImage != nil) {
//        NSLog(@"有原图， 不加载缩略图");
        return;
    }
    if (thumbImage != nil) {
        //NSLog(@"无原图，有缩略图 显示缩略图");
        return;
    }
    //NSLog(@"获取缩略图");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        CGSize size = CGSizeZero;
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result == nil) {
                //NSLog(@"获取不到缩略图");
            }
            else {
                //NSLog(@"获取到缩略图");
                thumbImage = result;
            }
            [self showImage];
        }];
        
    });
}

- (void)showImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (originalImage == nil) {
            //NSLog(@"显示缩略图");
            self.imv.image = thumbImage;
        } else {
           // NSLog(@"显示原图");
            self.imv.image = originalImage;
        }
    });
}

// 获取原图
- (void)loadOriginalImages {
    if (originalImage != nil) {
       // NSLog(@"有原图， 显示原图");
        return;
    }
    //NSLog(@"获取原图");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];//请求选项设置
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        //resizeMode  自定义设置图片的大小 枚举类型*
        //PHImageRequestOptionsResizeMode:*
        //PHImageRequestOptionsResizeModeNone = 0, //保持原size
        //PHImageRequestOptionsResizeModeFast, //高效、但不保证图片的size为自定义size
        //PHImageRequestOptionsResizeModeExact, //严格按照自定义size
        options.synchronous = YES; //YES 一定是同步    NO不一定是异步
        
        options.networkAccessAllowed = YES;//用于开启iClould中下载图片
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        //synchronous：指定请求是否同步执行。
        //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
        //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
        //这个属性只有在 synchronous 为 true 时有效。
        //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
        
        //iClould下载进度的回调
        options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
//            NSLog(@"iClould下载进度的回调 progress = %f",progress);
        };
        
        CGSize size = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result == nil) {
//                NSLog(@"获取不到原图");
                originalImage = nil;
            }
            else {
//                NSLog(@"获取到原图");
                originalImage = result;
            }
            [self showImage];
        }];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_touch) {
        _touch();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
