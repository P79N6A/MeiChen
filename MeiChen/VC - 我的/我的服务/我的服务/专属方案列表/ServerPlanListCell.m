//
//  ServerPlanListCell.m
//  meirong
//
//  Created by yangfeng on 2019/3/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ServerPlanListCell.h"

@implementation ServerPlanListCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *identifier = @"Cell";
    ServerPlanListCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServerPlanListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadData:(SideBarSurgeryModel *)model {
    self.name.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"ServersVC_14", nil),model.seq];
    self.detail.text = model.process;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
