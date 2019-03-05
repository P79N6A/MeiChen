//
//  MyCell_2.h
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell_2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *line;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)loadDataWithImage:(NSString *)imageName name:(NSString *)name;

@end
