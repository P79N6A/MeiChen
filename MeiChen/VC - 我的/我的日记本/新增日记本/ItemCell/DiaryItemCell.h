//
//  DiaryItemCell.h
//  meirong
//
//  Created by yangfeng on 2019/2/18.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadBlock)(NSArray *array, NSInteger row);
typedef void(^TextBlock)(NSString *text, NSInteger row);
@interface DiaryItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *timeButt;

@property (weak, nonatomic) IBOutlet UIButton *butt;

@property (weak, nonatomic) IBOutlet UIButton *dele;

@property (weak, nonatomic) IBOutlet UITextView *message;

@property (weak, nonatomic) IBOutlet UICollectionView *collview;



@property (nonatomic, copy) ReloadBlock reloadblock;
@property (nonatomic, copy) TextBlock textblock;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) NSInteger MaxCount;
@property (nonatomic) CGFloat cell_w;
@property (nonatomic) CGFloat gap;
@property (nonatomic) NSInteger columns;
@property (nonatomic) BOOL onlyShow;
- (void)loadDataWith:(DailyDetailItem *)item;

@end
