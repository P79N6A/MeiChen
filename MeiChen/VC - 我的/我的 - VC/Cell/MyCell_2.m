//
//  MyCell_2.m
//  meirong
//
//  Created by yangfeng on 2019/1/30.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyCell_2.h"

@implementation MyCell_2


+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    MyCell_2 *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell_2" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)loadDataWithImage:(NSString *)imageName name:(NSString *)name {
    self.icon.image = [UIImage imageNamed:imageName];
    self.name.text = name;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
