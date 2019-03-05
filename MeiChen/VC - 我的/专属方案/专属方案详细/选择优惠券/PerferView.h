//
//  YouHuiJuanView.h
//  meirong
//
//  Created by yangfeng on 2019/3/4.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockArray)(NSArray *array);
@interface PerferView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property (weak, nonatomic) IBOutlet UIButton *queue;
@property (nonatomic, strong) NSMutableArray *m_arr;
@property (nonatomic, strong) NSMutableArray *m_select;
@property (copy, nonatomic) blockArray selectArray;

- (void)show;

@end
