//
//  SettingCell.h
//  meirong
//
//  Created by yangfeng on 2019/2/21.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIButton *quit;


- (void)loadImvUrl:(NSString *)url;

@end
