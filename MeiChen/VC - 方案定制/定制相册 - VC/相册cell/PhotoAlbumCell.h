//
//  PhotoAlbumCellTableViewCell.h
//  meirong
//
//  Created by yangfeng on 2019/1/16.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *count;


@end
