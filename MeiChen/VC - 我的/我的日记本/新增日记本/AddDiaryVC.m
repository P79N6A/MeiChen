//
//  AddDiaryVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AddDiaryVC.h"
#import "AddDiaryView.h"
#import "NSString+RandomString.h"
#import "SelectProjectVC.h"
#import "PhotosVC.h"
#import "CameraVC.h"
#import "DiaryItemCell.h"

@interface AddDiaryVC () <CustomNavViewDelegate, AddDiaryViewDelegate, UIScrollViewDelegate> {
    CGFloat baseHeight;
    CGFloat cellHeight;
    NetWork *net;
    NSMutableArray *itemArray;
    CGPoint oldPoint;
    BOOL needsetPoint;
}
@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) AddDiaryView *headerview;
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation AddDiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    itemArray = [NSMutableArray array];
    [self initDiaryModel];
    [self BUildUI];
    
    // 添加了一个 键盘即将显示时的监听，如果接收到通知，将调用 keyboardWillApprear：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillApprear:) name:UIKeyboardWillShowNotification object:nil];
    // 添加监听， 键盘即将隐藏的时候，调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initDiaryModel {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (self.isfirst) {
        // 1、手术时间
        self.diaryModel.fix_at = [NSString stringWithFormat:@"%.0f",nowTime];;
        
        // 2、默认一篇空日记
        DailyDetailItem *item = [[DailyDetailItem alloc]init];
        item.photo_at = [NSString stringWithFormat:@"%.0f",nowTime];
        self.diaryModel.daily = @[item];
        
    }
    else {
        // 下载日记详情
        [self requestDiaryDetail];
    }
}

#pragma mark - AddDiaryViewDelegate
// 新增
- (void)AddDiaryView_AddDiaryButton:(UIButton *)button {
    CGPoint point = CGPointMake(0, self.scroll.contentSize.height);
    NSLog(@"point = %@",NSStringFromCGPoint(point));
    [self.scroll setContentOffset:point];
}
// 点击手术项目
- (void)AddDiaryView_DidSelectProjectButton:(UIButton *)button {
    SelectProjectVC *vc = [[SelectProjectVC alloc]init];
    vc.SelectArray = [NSMutableArray arrayWithArray:itemArray];
    __weak typeof(self) weakSelf = self;
    vc.blockArray = ^(NSArray *array) {
        itemArray = [NSMutableArray arrayWithArray:array];
        [weakSelf.headerview LoadButton_2:array];
    };
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
// 更新高度
- (void)AddDiaryView_TableViewFrame:(CGFloat)height {
    [self updateContentSize];
    [self RightItemColor:NO];
}
// 删除日记
- (void)AddDiaryView_DeleteOneDiaryWith:(DailyDetailItem *)item {
    if (item.daily_id != nil) {
        [self deleteDiaryWith:item.daily_id];
    }
}


#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = kColorRGB(0xf0f0f0);
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;
    CGFloat height = self.view.frame.size.height;
    baseHeight = 328;
    cellHeight = 283;
    NSString *titleStr;
    if (self.isfirst) {
        titleStr = NSLocalizedString(@"MyDiaryVC_7", nil);
    }
    else {
        titleStr = NSLocalizedString(@"MyDiaryVC_21", nil);
    }
    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    [self.navview RightItemIsRelease];
    self.navview.delegate = self;
    self.navview.titleLab.text = titleStr;
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, width, height - y)];
    self.scroll.backgroundColor = kColorRGB(0xf0f0f0);
    self.scroll.bounces = NO;
    self.scroll.delegate = self;
    self.scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scroll];
    
    self.headerview = [[AddDiaryView alloc]initWithFrame:CGRectMake(0, 0, width, baseHeight + cellHeight)];
    self.headerview.delegate = self;
    self.headerview.isfirst = self.isfirst;
    self.headerview.diaryModel = self.diaryModel;
    self.headerview.DiaryStatus = self.mydiary.status;
    if ([self.mydiary.status isEqualToString:WAITPASS] ||
        [self.mydiary.status isEqualToString:ISPASS]) {
        self.headerview.view_1.onlyShow = YES;
        self.headerview.view_2.onlyShow = YES;
    }else {
        self.headerview.view_1.onlyShow = NO;
        self.headerview.view_2.onlyShow = NO;
    }
    [self.scroll addSubview:self.headerview];

    [self updateContentSize];
}

- (void)updateContentSize {
    self.scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(self.headerview.frame));
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CustomNavView_RightItem:(UIButton *)sender {
    if ([self RightItemColor:YES]) {
        if (!self.isfirst) {
            [self UpdateDiary];
            return;
        }
        // 上传图片
        [self uploadImages];
    }
    else {
        NSLog(@"内容不完整");
    }
}

- (BOOL)RightItemColor:(BOOL)showAlert {
    NSArray *itemArr = [NSArray arrayWithArray:[self ItemArray:itemArray]];
    BOOL is_1;
    BOOL is_2;
    BOOL is_3;
    if (self.isfirst) {
        is_1 = itemArr.count <= 0?YES:NO;
        is_2 = self.headerview.view_1.images.count <= 0?YES:NO;
        is_3 = self.headerview.view_2.images.count <= 0?YES:NO;
        if (is_1 && showAlert) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"MyDiaryVC_27", nil)];
        }
        if (is_2 && showAlert) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"MyDiaryVC_28", nil)];
        }
        if (is_3 && showAlert) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"MyDiaryVC_29", nil)];
        }
    }
    else {
        is_1 = NO;
        is_2 = NO;
        is_3 = NO;
    }
    
    BOOL is_4 = NO;
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        DailyDetailItem *item = self.diaryModel.daily[i];
        if (item.status == nil || [item.status isEqualToString:@"UN_PASS"]) {
            if (item.brief == nil || item.brief.length <= 0) {
                is_4 = YES;
                if (showAlert) {
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"MyDiaryVC_30", nil)];
                }
                break;
            }
            if (item.photos == nil || item.photos.count <= 0) {
                is_4 = YES;
                if (showAlert) {
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"MyDiaryVC_31", nil)];
                }
                break;
            }
        }
    }
    
    
    if (is_1 || is_2 || is_3 || is_4) {
        [self.navview.rightItem setTitleColor:kColorRGB(0x666666) forState:(UIControlStateNormal)];
        return NO;
    }
    [self.navview.rightItem setTitleColor:kColorRGB(0x21C9D9) forState:(UIControlStateNormal)];
    return YES;
}

- (NSArray *)ItemArray:(NSArray *)array {
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        id obj = array[i];
        if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
            ChildMenuModel_3 *mo = (ChildMenuModel_3 *)obj;
            [m_arr addObject:mo.val];
        }
        if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *mo = (itemModel *)obj;
            [m_arr addObject:mo.item_name];
        }
    }
    return m_arr;
}

#pragma mark - 更新日记 - 下载日记详情
- (void)requestDiaryDetail {
    [SVProgressHUD show];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"sample_id"] = self.mydiary.sample_id;
    
    [net requestWithUrl:@"sample/my-detail" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"下载日记详情 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                DiaryDetailModel *model = [MTLJSONAdapter modelOfClass:[DiaryDetailModel class] fromJSONDictionary:responseObject[@"data"] error:nil];
                if (model != nil) {
                    if (model.daily == nil || model.daily.count == 0) {
                        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                        DailyDetailItem *item = [[DailyDetailItem alloc]init];
                        item.photo_at = [NSString stringWithFormat:@"%.0f",nowTime];
                        model.daily = @[item];
                    }
                    itemArray = [NSMutableArray arrayWithArray:model.item];
                    self.diaryModel = model;
                    self.headerview.diaryModel = self.diaryModel;
                }
                [SVProgressHUD dismiss];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}


#pragma mark - 上传照片
- (void)uploadImages {
    // 浏览图片 https://mecen.oss-cn-shenzhen.aliyuncs.com/def
    // 上传图片到oss
    // 设置上传的文件位置
    NSMutableString *m_file = [NSMutableString string];
    [m_file appendString:@"sample"];

    NSDateFormatter *formatter_1 = [[NSDateFormatter alloc]init];
    [formatter_1 setDateFormat:@"yyyy-MM"];
    NSString *time_1 = [formatter_1 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_1];
    
    NSDateFormatter *formatter_2 = [[NSDateFormatter alloc]init];
    [formatter_2 setDateFormat:@"dd"];
    NSString *time_2 = [formatter_2 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_2];
    
    [SVProgressHUD show];
    dispatch_group_t group =  dispatch_group_create();
    
    // 术前照片地址
    NSArray *images_1 = [self uploadImages:m_file array:self.headerview.view_1.images group:group];
    
    // 主页展示照片
    NSArray *images_2 = [self uploadImages:m_file array:self.headerview.view_2.images group:group];
    
    // 日记照片
    NSArray *images_3 = [self uploadDiaryImagesWith:m_file group:group];
    
    // 全部上传图片完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"图片上传完成");
        // 日记本图片上传完成
        [self requestToCreateDiary:images_1 arr_2:images_2 arr_3:images_3];
    });
}

- (NSArray *)uploadImages:(NSString *)m_file array:(NSArray *)array group:(dispatch_group_t)group {
    NSMutableArray *nameArr = [NSMutableArray array];
    for (int j = 0; j < array.count; j ++) {
        id obj = array[j];
        AddUpdateModel *model = [[AddUpdateModel alloc]init];
        if ([obj isKindOfClass:[UIImage class]]) {
            NSString *ima = [NSString stringWithFormat:@"ios_%@.png",[NSString randomString:32]];
            // 生成图片名称
            NSString *imageName = [NSString stringWithFormat:@"%@/%@",m_file,ima];
            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",[[AliyunOSSUpload shareOSSClientObj] dowmLoadURL], imageName];
            model.status = 0;
            model.str = imageUrl;
            [nameArr addObject:model];
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = (UIImage *)array[j];
                NSData *data = [image compressQualityWithMaxLength:(5*1024*1024)];
                [[AliyunOSSUpload shareOSSClientObj] updateToALi:data imageName:imageName];
            });
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            model.status = 1;
            model.str = (NSString *)obj;
            [nameArr addObject:model];
        }
    }
    return nameArr;
}

// 上传日记照片
- (NSArray *)uploadDiaryImagesWith:(NSString *)m_file group:(dispatch_group_t)group {
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        DailyDetailItem *item = self.diaryModel.daily[i];
        NSArray *arr = [self uploadImages:m_file array:item.photos group:group];
        [m_arr addObject:arr];
    }
    return m_arr;
}

- (void)requestToCreateDiary:(NSArray *)arr_1 arr_2:(NSArray *)arr_2 arr_3:(NSArray *)arr_3 {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"fix_at"] = self.headerview.bu_1.titleLabel.text;
    m_dic[@"item"] = [NSArray arrayWithArray:[self ItemArray:itemArray]];
    // 术前照片
    NSMutableArray *m_arr_1 = [NSMutableArray array];
    for (int i = 0; i < arr_1.count; i ++) {
        AddUpdateModel *model = arr_1[i];
        [m_arr_1 addObject:model.str];
    }
    m_dic[@"pre_img"] = m_arr_1;
    // 封面
    AddUpdateModel *model_2 = [arr_2 firstObject];
    m_dic[@"cover_img"] = model_2.str;
    // 日记图片
    NSMutableArray *arr_photos = [NSMutableArray array];
    for (int i = 0; i < arr_3.count; i ++) {
        NSString *str = [self SettingURLStrArray:arr_3[i]];
        [arr_photos addObject:str];
    }
    m_dic[@"photos"] = arr_photos;
    // 日记拍摄时间和介绍
    NSMutableArray *m_ar_1 = [NSMutableArray array];
    NSMutableArray *m_ar_2 = [NSMutableArray array];
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        DailyDetailItem *item = self.diaryModel.daily[i];
        [m_ar_1 addObject:[self TimeToDateStr:item.photo_at]];
        [m_ar_2 addObject:item.brief];
    }
    m_dic[@"photo_at"] = m_ar_1;
    m_dic[@"brief"] = m_ar_2;
    
    NSLog(@"m_dic = %@",m_dic);
    [net requestWithUrl:@"sample/my-publish" Parames:(NSMutableDictionary *)m_dic Success:^(id responseObject) {
        NSLog(@"写日记 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"MyDiaryVC_23", nil)];
                [self CustomNavView_LeftItem:nil];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

- (NSString *)TimeToDateStr:(NSString *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter  stringFromDate:date];
}

- (void)deleteDiaryWith:(NSString *)daily_id {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"daily_id"] = daily_id;
    [SVProgressHUD show];
    [net requestWithUrl:@"sample/my-del-daily" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"删除日记 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                // 下载日记详情
                [self requestDiaryDetail];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}
// 新增一篇日记
- (void)UpdateDiary {
    [SVProgressHUD show];
    dispatch_group_t group =  dispatch_group_create();
    
    // 浏览图片 https://mecen.oss-cn-shenzhen.aliyuncs.com/def
    // 上传图片到oss
    // 设置上传的文件位置
    NSMutableString *m_file = [NSMutableString string];
    [m_file appendString:@"sample"];
    
    NSDateFormatter *formatter_1 = [[NSDateFormatter alloc]init];
    [formatter_1 setDateFormat:@"yyyy-MM"];
    NSString *time_1 = [formatter_1 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_1];
    
    NSDateFormatter *formatter_2 = [[NSDateFormatter alloc]init];
    [formatter_2 setDateFormat:@"dd"];
    NSString *time_2 = [formatter_2 stringFromDate:[NSDate date]];
    [m_file appendString:@"/"];
    [m_file appendString:time_2];
    
    // 术前照片地址
    NSArray *images_1 = [self uploadImages:m_file array:self.headerview.view_1.images group:group];
    
    // 主页展示照片
    NSArray *images_2 = [self uploadImages:m_file array:self.headerview.view_2.images group:group];

    // 日记照片
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        DailyDetailItem *item = self.diaryModel.daily[i];
        if (item.status == nil ||
            [item.status isEqualToString:UNPASS]) {
            NSArray *arr = [self uploadImages:m_file array:item.photos group:group];
            [m_arr addObject:arr];
        }
        else {
            [m_arr addObject:@[]];
        }
    }
    
    // 全部上传图片完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 日记本图片上传完成
        [self requestUpdateDiary:images_1 arr_2:images_2 arr_3:m_arr];
    });
}

- (NSString *)SettingURLStrArray:(NSArray *)array {
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:@"["];
    for (int i = 0; i < array.count; i ++) {
        AddUpdateModel *model = array[i];
        NSString *str = [NSString stringWithFormat:@"\"%@\"",model.str];
        [m_str appendString:str];
        if (i < array.count-1) {
            [m_str appendString:@","];
        }
    }
    [m_str appendString:@"]"];
    NSLog(@"m_str = %@",m_str);
    return m_str;
}

- (void)requestUpdateDiary:(NSArray *)arr_1 arr_2:(NSArray *)arr_2 arr_3:(NSArray *)arr_3 {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"sample_id"] = self.mydiary.sample_id;
    m_dic[@"fix_at"] = self.headerview.bu_1.titleLabel.text;
    m_dic[@"item"] = [NSArray arrayWithArray:[self ItemArray:itemArray]];;
    
    NSMutableArray *m_arr_1 = [NSMutableArray array];
    for (int i = 0; i < arr_1.count; i ++) {
        AddUpdateModel *model = arr_1[i];
        [m_arr_1 addObject:model.str];
    }
    m_dic[@"pre_img"] = m_arr_1;
    
    AddUpdateModel *model_2 = [arr_2 firstObject];
    m_dic[@"cover_img"] = model_2.str;
    
    // 图片
    NSMutableArray *new_photo = [NSMutableArray array];
    NSMutableArray *update_photo = [NSMutableArray array];
    // 内容
    NSMutableArray *new_brief = [NSMutableArray array];
    NSMutableArray *update_brief = [NSMutableArray array];
    // 时间
    NSMutableArray *new_photo_at = [NSMutableArray array];
    NSMutableArray *update_photo_at = [NSMutableArray array];
    // id
    NSMutableArray *update_daily_id = [NSMutableArray array];
    
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        DailyDetailItem *item = self.diaryModel.daily[i];
        // 新增
        if (item.status == nil) {
            NSArray *newArr = arr_3[i];
            [new_photo addObject:[self SettingURLStrArray:newArr]];
            [new_photo_at addObject:[self TimeToDateStr:item.photo_at]];
            [new_brief addObject:item.brief];
        }
        // 更新
        else if ([item.status isEqualToString:UNPASS]) {
            NSArray *newArr = arr_3[i];
            [update_photo addObject:[self SettingURLStrArray:newArr]];
            [update_photo_at addObject:[self TimeToDateStr:item.photo_at]];
            [update_brief addObject:item.brief];
            [update_daily_id addObject:item.daily_id];
        }
    }
    
    m_dic[@"new_photos"] = new_photo;
    m_dic[@"update_photos"] = update_photo;
    
    m_dic[@"new_brief"] = new_brief;
    m_dic[@"update_brief"] = update_brief;
    
    m_dic[@"new_photo_at"] = new_photo_at;
    m_dic[@"update_photo_at"] = update_photo_at;
    
    m_dic[@"update_daily_id"] = update_daily_id;
    
    NSLog(@"更新一篇日记 m_dic = %@",m_dic);
    
    [SVProgressHUD show];
    [net requestWithUrl:@"sample/my-publish-update" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"更新一篇日记 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"MyDiaryVC_23", nil)];
                [self CustomNavView_LeftItem:nil];
                return;
                break;
            }
            default:
                break;
        }
        NSString *mess = NSLocalizedString(@"svp_2", nil);
        if ([[responseObject allKeys] containsObject:@"message"]) {
            mess = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        }
        NSError *error = [NSError errorWithDomain:@"" code:-101 userInfo:@{NSLocalizedDescriptionKey:mess}];
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

#pragma mark - 滚动视图协议
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    needsetPoint = NO;
}

#pragma mark - 键盘即将显示的时候调用
- (void)keyboardWillApprear:(NSNotification *)noti {
    // 取出通知中的信息
    NSDictionary *dict = noti.userInfo;
    // 间隔时间
    NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyboardRect = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    // 键盘高度
    CGFloat keyBoardH =  keyboardRect.size.height;
//    NSLog(@"键盘高度 = %f",keyBoardH);
    needsetPoint = NO;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    id firstResponder = [keywindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextView class]]) {
        UITextView *textview = (UITextView *)firstResponder;
        DiaryItemCell *cell = [self.headerview.tabview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textview.tag inSection:0]];
        CGRect rect=[self.headerview.tabview convertRect:cell.frame toView:self.view];
        CGFloat cell_maxy = rect.origin.y + cell.frame.size.height;
        CGFloat key_y = keywindow.frame.size.height - keyBoardH;
        if (cell_maxy > key_y) {
            oldPoint = self.scroll.contentOffset;
            CGPoint bottomOffset = CGPointMake(0, self.scroll.contentOffset.y + (cell_maxy - key_y));
            needsetPoint = YES;
            [UIView animateWithDuration:interval animations:^{
                [self.scroll setContentOffset:bottomOffset animated:YES];
            }];
        }
    }
}


#pragma mark -  键盘即将隐藏的时候调用
- (void)keyboardWillDisAppear:(NSNotification *)noti {
    if (needsetPoint) {
        // 取出通知中的信息
        NSDictionary *dict = noti.userInfo;
        NSTimeInterval interval = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        
        [UIView animateWithDuration:interval animations:^{
            [self.scroll setContentOffset:oldPoint animated:YES];
        }];
    }
}


- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
