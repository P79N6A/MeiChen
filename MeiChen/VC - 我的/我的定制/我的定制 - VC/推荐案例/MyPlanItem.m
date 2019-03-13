//
//  MyPlanItem.m
//  meirong
//
//  Created by yangfeng on 2019/1/25.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "MyPlanItem.h"

@implementation MyPlanItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyPlanItem" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)loadDataWith:(NSIndexPath *)indexPath model:(MyDZSampleModel *)model {
    [self loadIcon:model.cover_img];
    [self loadTitleLabel:model.brief];
}

- (void)loadIcon:(NSString *)url {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)loadTitleLabel:(NSString *)str {
    self.titleLab.text = str;
}

@end
