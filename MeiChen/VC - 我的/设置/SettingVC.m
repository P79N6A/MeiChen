//
//  SettingVC.m
//  meirong
//
//  Created by yangfeng on 2019/2/21.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "SettingVC.h"
#import "SettingCell.h"
#import "CameraVC.h"
#import "PhotosVC.h"
#import "NSString+RandomString.h"
#import "ChangeNameVC.h"
#import "ChangePhoneVC.h"
#import "ShareView.h"

@interface SettingVC () <CustomNavViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NetWork *net;
}

@property (nonatomic, strong) CustomNavView *navview;
@property (nonatomic, strong) UITableView *tabview;

@property (nonatomic, strong) NSMutableArray *m_arr;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    net = [[NetWork alloc]init];
    [self BUildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabview reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.m_arr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.m_arr[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.m_arr[indexPath.section];
    cell.name.text = arr[indexPath.row];
    [self LoadDataWithIndexPath:indexPath cell:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    header.backgroundColor = kColorRGB(0xf0f0f0);
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [self showAlert:self];
                    break;
                }
                case 1: {
                    ChangeNameVC *vc = [[ChangeNameVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 2: {
                    ChangePhoneVC *vc = [[ChangePhoneVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    NSLog(@"用户协议");
                    break;
                }
                case 1: {
                    NSLog(@"联系我们");
                    break;
                }
                case 2: {
                    ShareView *view = [[ShareView alloc]init];
                    view.index = ^(NSInteger index) {
                        NSLog(@"分享 = %ld",index);
                    };
                    [view show];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - UI
- (void)BUildUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat width = statusRect.size.width;
    CGFloat y = statusRect.size.height + 44;

    self.navview = [[CustomNavView alloc]init];
    [self.navview LeftItemIsBack];
    self.navview.delegate = self;
    self.navview.titleLab.text = NSLocalizedString(@"SettingVC_1", nil);
    self.navview.line.hidden = NO;
    [self.view addSubview:self.navview];
    
    self.tabview = [[UITableView alloc]initWithFrame:(CGRect){0,y,width,self.view.frame.size.height - y} style:(UITableViewStylePlain)];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    self.tabview.bounces = NO;
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.backgroundColor = kColorRGB(0xf0f0f0);
    [self.view addSubview:self.tabview];
    
    self.m_arr = [NSMutableArray array];
    NSMutableArray *m_arr_1 = [NSMutableArray array];
    [m_arr_1 addObject:NSLocalizedString(@"SettingVC_10", nil)];
    [m_arr_1 addObject:NSLocalizedString(@"SettingVC_2", nil)];
    [m_arr_1 addObject:NSLocalizedString(@"SettingVC_3", nil)];
    NSMutableArray *m_arr_2 = [NSMutableArray array];
    [m_arr_2 addObject:NSLocalizedString(@"SettingVC_6", nil)];
    [m_arr_2 addObject:NSLocalizedString(@"SettingVC_7", nil)];
    [m_arr_2 addObject:NSLocalizedString(@"SettingVC_8", nil)];
    NSMutableArray *m_arr_3 = [NSMutableArray array];
    [m_arr_3 addObject:NSLocalizedString(@"SettingVC_9", nil)];
    
    [self.m_arr addObject:m_arr_1];
    [self.m_arr addObject:m_arr_2];
    [self.m_arr addObject:m_arr_3];
}

#pragma mark - 导航栏方法
- (void)CustomNavView_LeftItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)LoadDataWithIndexPath:(NSIndexPath *)indexPath cell:(SettingCell *)cell {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell.icon.hidden = NO;
                    cell.message.hidden = YES;
                    NSString *str = [UserData shareInstance].user.avatar;
                    [cell loadImvUrl:str];
                    [cell.icon sd_setImageWithURL:[NSURL URLWithString:str]];
                    break;
                }
                case 1: {
                    cell.message.text = [UserData shareInstance].user.nickname;
                    break;
                }
                case 2: {
                    NSString *mobile = [UserData shareInstance].user.mobile;
                    if (mobile.length > 7) {
                        mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }
                    cell.message.text = mobile;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    break;
                }
                case 1: {
                    break;
                }
                case 2: {
                    cell.message.backgroundColor = [UIColor redColor];
                    cell.message.layer.masksToBounds = YES;
                    cell.message.text = [NSString stringWithFormat:@"   %@   ",NSLocalizedString(@"SettingVC_11", nil)];
                    cell.message.layer.cornerRadius = 10;
                    cell.message.textColor = [UIColor whiteColor];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            cell.quit.hidden = NO;
            NSArray *arr = self.m_arr[indexPath.section];
            [cell.quit setTitle:arr[indexPath.row] forState:(UIControlStateNormal)];
            break;
        }
        default:
            break;
    }
}

- (void)showAlert:(UIViewController *)vc {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_9", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        CameraVC *vc2 = [[CameraVC alloc]init];
        __weak typeof(self) weakSelf = self;
        vc2.blockimage = ^(UIImage *image) {
            [weakSelf updateIcon:image];
        };
        [vc2 checkCameraPermission:vc pushvc:vc2 can:YES];
    }];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_10", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        PhotosVC *vc2 = [[PhotosVC alloc]init];
        vc2.indexNumber = 2;
        vc2.maxCount = 1;   // 还可再添加多少张图片
        __weak typeof(self) weakSelf = self;
        vc2.blockimage = ^(NSArray *imagesArr) {
            [weakSelf updateIcon:[imagesArr firstObject]];
        };
        [vc2 checkPhotoPermission:vc pushvc:vc2 Push:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"UploadImageVC_11", nil) style:(UIAlertActionStyleCancel) handler:nil];
    
    [controller addAction:action_1];
    [controller addAction:action_2];
    [controller addAction:cancel];
    
    [vc presentViewController:controller animated:YES completion:nil];
}

- (void)updateIcon:(UIImage *)image {
    // 上传图片到oss
    // 设置上传的文件位置
    NSMutableString *m_file = [NSMutableString string];
    [m_file appendString:@"avatar"];
    
    NSString *ima = [NSString stringWithFormat:@"ios_%@_%@.png",[NSString randomString:32],[UserData shareInstance].user.member_id];
    // 生成图片名称
    NSString *imageName = [NSString stringWithFormat:@"%@/%@",m_file,ima];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",[[AliyunOSSUpload shareOSSClientObj] dowmLoadURL], imageName];
    
    [SVProgressHUD show];
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [image compressQualityWithMaxLength:(5*1024*1024)];
        [[AliyunOSSUpload shareOSSClientObj] updateToALi:data imageName:imageName];
    });
    // 全部上传图片完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"头像上传完成");
        [self requestUserDataWith:imageUrl nickname:[UserData shareInstance].user.nickname motto:[UserData shareInstance].user.motto];
    });
}

- (void)requestUserDataWith:(NSString *)avatar nickname:(NSString *)nickname motto:(NSString *)motto {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
    m_dic[@"access_token"] = [[UserDefaults shareInstance] ReadAccessToken];
    m_dic[@"avatar"] = avatar;
    m_dic[@"nickname"] = nickname;
    m_dic[@"motto"] = motto;
    NSLog(@"更新用户信息 m_dic = %@",m_dic);
    [net requestWithUrl:@"member/update" Parames:m_dic Success:^(id responseObject) {
        NSLog(@"更新用户信息 = %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        switch (code) {
            case 0: {
                [SVProgressHUD dismiss];
                [Tools JumpToLoginVC:responseObject];
                break;
            }
            case 1: {
                [[UserData shareInstance] requestUserData:^(NSError *error) {
                    NSLog(@"error = %@",error);
                    if (error == nil) {
                        [SVProgressHUD dismiss];
                        [self.tabview reloadData];
                    }
                    else {
                        [SVProgressHUD showInfoWithStatus:error.description];
                    }
                }];
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
        [SVProgressHUD showInfoWithStatus:error.description];
        
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.description];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
