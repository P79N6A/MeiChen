//
//  ReviewCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/7.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *card;

@property (weak, nonatomic) IBOutlet UIButton *message;

@property (weak, nonatomic) IBOutlet UIView *line1;


@property (weak, nonatomic) IBOutlet UIImageView *triangle;

@property (weak, nonatomic) IBOutlet UILabel *review;

@property (weak, nonatomic) IBOutlet UIView *backview;

@property (weak, nonatomic) IBOutlet UILabel *revert;

@property (weak, nonatomic) IBOutlet UIView *line2;



- (void)loadDataWith:(reviewModel *)model louzhuid:(NSString *)louzhuid;

@end
