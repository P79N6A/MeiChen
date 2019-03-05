//
//  AddDiaryView.m
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AddDiaryView.h"
#import "ImageEditCell.h"
#import "PhotosVC.h"
#import "CameraVC.h"
#import "DiaryItemCell.h"
#import "DateView.h"

@interface AddDiaryView () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat item_w;
    CGFloat left;
    CGFloat gap;
    NSInteger columns;
    NSInteger MaxCount;
    CGFloat coll_h;
    CGFloat footer_h;
}
@end

@implementation AddDiaryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddDiaryView" owner:nil options:nil] firstObject];
        self.isfirst = YES;
        left = 12;
        gap = 10;
        columns = 4;
        MaxCount = 6;
        coll_h = 210;
        footer_h = 48;
        item_w = ([UIScreen mainScreen].bounds.size.width-left*2-gap*(columns - 1))/columns;

        self.frame = ({
            CGRect rect = frame;
            rect.size.height = 300+item_w+coll_h+footer_h;
            rect;
        });
        self.heightArr = [NSMutableArray array];
        self.lab_1.text = NSLocalizedString(@"MyDiaryVC_8", nil);
        self.lab_2.text = NSLocalizedString(@"MyDiaryVC_9", nil);
        self.lab_3.text = NSLocalizedString(@"MyDiaryVC_10", nil);
        self.lab_4.text = NSLocalizedString(@"MyDiaryVC_11", nil);

        CGFloat cell_w = 60;
        CGRect frame_1 = ({
            CGRect frame = self.photosView.frame;
            frame.size.width = cell_w;
            frame.origin.x = frame.size.width - cell_w;
            frame.origin.y = 0;
            frame;
        });
        self.view_1 = [[PhotosAddView alloc]initWithFrame:frame_1];
        self.view_1.MaxCount = 3;
        self.view_1.ColumnsCount = 3;
        self.view_1.cell_w = cell_w;
        self.view_1.updateFrame = YES;
        [self.photosView addSubview:self.view_1];
        
        CGRect frame_2 = ({
            CGRect frame = self.iconView.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame;
        });
        self.view_2 = [[PhotosAddView alloc]initWithFrame:frame_2];
        self.view_2.MaxCount = 1;
        [self.iconView addSubview:self.view_2];

        self.tabview.delegate = self;
        self.tabview.dataSource = self;
        self.tabview.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tabview.bounces = NO;
        self.tabview.showsVerticalScrollIndicator = NO;
        self.tabview.showsHorizontalScrollIndicator = NO;
        self.tabview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}

- (NSString *)nowTimeStr:(NSString *)str {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [formatter  stringFromDate:date];
    return string;
}

- (void)setDiaryModel:(DiaryDetailModel *)diaryModel {
    _diaryModel = diaryModel;
    [self updateTabViewFrame];
    [self loadDiaryData:_diaryModel];
}

#pragma mark - 加载日记数据
- (void)loadDiaryData:(DiaryDetailModel *)model {
    
    if (model.fix_at != nil && model.fix_at.length > 0) {
        [self.bu_1 setTitle:[self nowTimeStr:model.fix_at] forState:(UIControlStateNormal)];
    }
    if (model.item != nil) {
        [self LoadButton_2:model.item];
    }
    if (model.pre_imgs != nil) {
        self.view_1.images = [NSMutableArray arrayWithArray:model.pre_imgs];
    }
    if (model.cover_img != nil && model.cover_img.length > 0) {
        self.view_2.images = [NSMutableArray arrayWithArray:@[model.cover_img]];
    }
    
    [self.tabview reloadData];
}

- (void)LoadButton_2:(NSArray *)array {
    NSMutableString *m_str = [NSMutableString string];
    for (int i = 0; i < array.count; i ++) {
        id obj = array[i];
        if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
            ChildMenuModel_3 *model = (ChildMenuModel_3 *)obj;
            [m_str appendString:model.title];
            if (i < array.count - 1) {
                [m_str appendString:@"、"];
            }
        }
        if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *model = (itemModel *)obj;
            [m_str appendString:model.item_name];
            if (i < array.count - 1) {
                [m_str appendString:@"、"];
            }
        }
    }
    if (m_str.length > 0) {
        [self.bu_2 setTitle:m_str forState:(UIControlStateNormal)];
        
    }
}

- (BOOL)isOnlyShow:(NSString *)status {
    if ([status isEqualToString:WAITPASS] ||
        [status isEqualToString:ISPASS]) {
        return YES;
    }
    else {
        return NO;
    }
}
         
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.diaryModel.daily.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierTab = @"cell";
    DiaryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTab];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiaryItemCell" owner:nil options:nil] firstObject];
    }
    DailyDetailItem *item = self.diaryModel.daily[indexPath.row];
    
    if ([self isOnlyShow:item.status]) {
        cell.onlyShow = YES;
    }
    else {
        cell.onlyShow = NO;
    }
    cell.message.tag = indexPath.row;
    cell.tag = indexPath.row;
    cell.MaxCount = 6;
    cell.cell_w = item_w;
    cell.gap = gap;
    cell.columns = columns;
    cell.images = [NSMutableArray arrayWithArray:item.photos];
    [cell loadDataWith:item];
    cell.dele.tag = indexPath.row;
    [cell.dele addTarget:self action:@selector(DeleteDiaryItemMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.reloadblock = ^(NSArray *array, NSInteger row) {
        NSMutableArray *m_ar = [NSMutableArray arrayWithArray:weakSelf.diaryModel.daily];
        DailyDetailItem *item_1 = m_ar[row];
        item_1.photos = [NSArray arrayWithArray:array];
        [m_ar replaceObjectAtIndex:row withObject:item_1];
        weakSelf.diaryModel.daily = [NSArray arrayWithArray:m_ar];
        [weakSelf.tabview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        [weakSelf updateTabViewFrame];
    };
    cell.textblock = ^(NSString *text, NSInteger row) {
        NSMutableArray *m_ar = [NSMutableArray arrayWithArray:weakSelf.diaryModel.daily];
        DailyDetailItem *item_1 = m_ar[row];
        item_1.brief = text;
        [m_ar replaceObjectAtIndex:row withObject:item_1];
        weakSelf.diaryModel.daily = [NSArray arrayWithArray:m_ar];
        [weakSelf.tabview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        [weakSelf updateTabViewFrame];
    };
    cell.timeButt.tag = indexPath.row;
    [cell.timeButt addTarget:self action:@selector(ChangeTimeButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.butt.tag = indexPath.row;
    [cell.butt addTarget:self action:@selector(ChangeTimeButtonMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self CollHeight:indexPath.row];
    CGFloat cell_h = coll_h + height;
    return cell_h;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, footer_h)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, footer.frame.size.height)];
    [bu setTitle:NSLocalizedString(@"MyDiaryVC_14", nil) forState:(UIControlStateNormal)];
    [bu setTitleColor:kColorRGB(0x21C9D9) forState:(UIControlStateNormal)];
    bu.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
    [bu addTarget:self action:@selector(AddNewDiaryMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [footer addSubview:bu];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
    line.backgroundColor = kColorRGB(0xe6e6e6);
    [footer addSubview:line];
    
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footer_h;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 删除日记
- (void)DeleteDiaryItemMethod:(UIButton *)sender {
    if (self.isfirst) {
        NSLog(@"删除日记");
        [self deleOneDiary:sender.tag];
    }
    else {
        NSLog(@"删除一篇日记");
        DailyDetailItem *item = self.diaryModel.daily[sender.tag];
        if ([item.status isEqualToString:UNPASS]) {
            // 请求删除一篇日记
            if (self.delegate && [self.delegate respondsToSelector:@selector(AddDiaryView_DeleteOneDiaryWith:)]) {
                [self.delegate AddDiaryView_DeleteOneDiaryWith:item];
            }
        }
 else {
            [self deleOneDiary:sender.tag];
        }
    }
}
- (void)deleOneDiary:(NSInteger)row {
    NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.diaryModel.daily];
    if (m_arr.count > 1 && row < m_arr.count) {
        [m_arr removeObjectAtIndex:row];
        self.diaryModel.daily = [NSArray arrayWithArray:m_arr];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tabview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tabview reloadData];
        });
        [self updateTabViewFrame];
    }
}
#pragma mark - 新增一篇日记
- (void)AddNewDiaryMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddDiaryView_AddDiaryButton:)]) {
        [self.delegate AddDiaryView_AddDiaryButton:sender];
    }
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    DailyDetailItem *item = [[DailyDetailItem alloc]init];
    item.photo_at = [NSString stringWithFormat:@"%.0f",nowTime];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.diaryModel.daily.count inSection:0];
    NSMutableArray *m_arr = [NSMutableArray arrayWithArray:self.diaryModel.daily];
    [m_arr addObject:item];
    self.diaryModel.daily = [NSArray arrayWithArray:m_arr];
    [self.tabview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self updateTabViewFrame];
}

- (NSInteger)arrCount:(NSInteger)row {
    DailyDetailItem *item = self.diaryModel.daily[row];
    if ([item.status isEqualToString:WAITPASS] ||
        [item.status isEqualToString:ISPASS]) {
        return item.photos.count;
    }
    if (item.photos.count >= 6) {
        return item.photos.count;
    }
    return item.photos.count + 1;
}

- (NSInteger)CollHeight:(NSInteger)row {
    NSInteger count = [self arrCount:row];
    NSInteger shang = count/columns;
    NSInteger yushu = count%columns;
    CGFloat h;
    if (count <= columns) {
        h = item_w;
    }
    else if (yushu == 0) {
        h = item_w * (shang) + gap * (shang - 1);
    }
    else {
        h = item_w * (shang + 1) + gap * (shang - 1);
    }
    return h;
}

#pragma mark - 修改日记item时间
- (void)ChangeTimeButtonMethod:(UIButton *)button {
    DailyDetailItem *item = self.diaryModel.daily[button.tag];
    if ([self isOnlyShow:item.status]) {
        return;
    }
    
    DiaryItemCell *cell = [self.tabview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    DateView *date = [[DateView alloc]init];
    [date SettingDefaultTime:cell.timeButt.titleLabel.text];
    __weak typeof(self) weakSelf = self;
    date.blockStr = ^(NSString *dateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:dateStr];
        NSTimeInterval time = [date timeIntervalSince1970];
        NSMutableArray *m_ar = [NSMutableArray arrayWithArray:weakSelf.diaryModel.daily];
        DailyDetailItem *item_1 = m_ar[button.tag];
        item_1.photo_at = [NSString stringWithFormat:@"%.0f",time];
        [m_ar replaceObjectAtIndex:button.tag withObject:item_1];
        weakSelf.diaryModel.daily = [NSArray arrayWithArray:m_ar];
        [weakSelf.tabview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    };
    [date show];
}

// 手术时间
- (IBAction)TimeMethod:(UIButton *)sender {
    if (_isfirst || ![self isOnlyShow:self.DiaryStatus]) {
        DateView *date = [[DateView alloc]init];
        [date SettingDefaultTime:sender.titleLabel.text];
        __weak typeof(self) weakSelf = self;
        date.blockStr = ^(NSString *dateStr) {
            [weakSelf.bu_1 setTitle:dateStr forState:(UIControlStateNormal)];
        };
        [date show];
    }
}
// 手术项目
- (IBAction)ProjectNameMethod:(UIButton *)sender {
    if (_isfirst || ![self isOnlyShow:self.DiaryStatus]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AddDiaryView_DidSelectProjectButton:)]) {
            [self.delegate AddDiaryView_DidSelectProjectButton:sender];
        }
    }
}

- (void)updateTabViewFrame {
    CGFloat height = 0;
    for (int i = 0; i < self.diaryModel.daily.count; i ++) {
        CGFloat h_1 = [self CollHeight:i];
        CGFloat cell_h = coll_h + h_1;
        height += cell_h;
    }
    height += footer_h;
    self.frame = ({
        CGRect rect = self.frame;
        rect.size.height = 300 + height;
        rect;
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddDiaryView_TableViewFrame:)]) {
        [self.delegate AddDiaryView_TableViewFrame:height];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
