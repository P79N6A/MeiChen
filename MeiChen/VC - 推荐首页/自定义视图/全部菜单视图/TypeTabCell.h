//
//  TypeTabCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/2.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)didSelectWithRow:(NSInteger)row tag:(NSInteger)tag;

@end
