//
//  AlreadySelectView.m
//  meirong
//
//  Created by yangfeng on 2019/2/15.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "AlreadySelectView.h"

@implementation AlreadySelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AlreadySelectView" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.lab.text = NSLocalizedString(@"MyDiaryVC_17", nil);
        self.m_arr = [NSMutableArray array];
        
        self.bu_1.hidden = YES;
        self.bu_2.hidden = YES;
        self.bu_3.hidden = YES;
        
        self.bu_1.layer.masksToBounds = YES;
        self.bu_1.layer.cornerRadius = self.bu_1.frame.size.height / 2.0;
        
        self.bu_2.layer.masksToBounds = YES;
        self.bu_2.layer.cornerRadius = self.bu_2.frame.size.height / 2.0;
        
        self.bu_3.layer.masksToBounds = YES;
        self.bu_3.layer.cornerRadius = self.bu_3.frame.size.height / 2.0;
    }
    return self;
}

- (void)UpdateSelectArrayWith:(id)model {
    NSMutableArray *m_name = [NSMutableArray array];
    for (id obj in self.m_arr) {
        if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
            ChildMenuModel_3 *mo = (ChildMenuModel_3 *)obj;
            [m_name addObject:mo.title];
        }
        else if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *mo = (itemModel *)obj;
            [m_name addObject:mo.item_name];
        }
    }
    
    NSString *content;
    if ([model isKindOfClass:[ChildMenuModel_3 class]]) {
        ChildMenuModel_3 *mo = (ChildMenuModel_3 *)model;
        content = mo.title;
    }
    else if ([model isKindOfClass:[itemModel class]]) {
        itemModel *mo = (itemModel *)model;
        content = mo.item_name;
    }
    
    if (![m_name containsObject:content]) {
        if (self.m_arr.count < 3) {
            [self.m_arr addObject:model];
        }
    }
    else {
        [self removeObject:content];
    }
    [self reloadButtonTitle];
}

- (void)removeObject:(NSString *)str {
    for (id obj in self.m_arr) {
        if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
            ChildMenuModel_3 *mo = (ChildMenuModel_3 *)obj;
            if ([str isEqualToString:mo.title]) {
                [self.m_arr removeObject:obj];
            }
        }
        else if ([obj isKindOfClass:[itemModel class]]) {
            itemModel *mo = (itemModel *)obj;
            if ([str isEqualToString:mo.item_name]) {
                [self.m_arr removeObject:obj];
            }
        }
    }
}

- (void)reloadButtonTitle {
    for (int i = 0; i < 3; i ++) {
        NSMutableString *m_str = [NSMutableString string];
        if (i < self.m_arr.count) {
            id obj = self.m_arr[i];
            if ([obj isKindOfClass:[ChildMenuModel_3 class]]) {
                ChildMenuModel_3 *mo = (ChildMenuModel_3 *)obj;
                [m_str appendString:mo.title];
            }
            else if ([obj isKindOfClass:[itemModel class]]) {
                itemModel *mo = (itemModel *)obj;
                [m_str appendString:mo.item_name];
            }
            [m_str appendString:@" X"];
            switch (i) {
                case 0: {
                    [self.bu_1 setTitle:m_str forState:(UIControlStateNormal)];
                    self.bu_1.hidden = NO;
                    break;
                }
                case 1: {
                    [self.bu_2 setTitle:m_str forState:(UIControlStateNormal)];
                    self.bu_2.hidden = NO;
                    break;
                }
                case 2: {
                    [self.bu_3 setTitle:m_str forState:(UIControlStateNormal)];
                    self.bu_3.hidden = NO;
                    break;
                }
                default:
                    break;
            }
        }
        else {
            switch (i) {
                case 0: {
                    self.bu_1.hidden = YES;
                    break;
                }
                case 1: {
                    self.bu_2.hidden = YES;
                    break;
                }
                case 2: {
                    self.bu_3.hidden = YES;
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (IBAction)ButtonMethod_1:(UIButton *)sender {
    if (self.m_arr.count > 0) {
        [self.m_arr removeObjectAtIndex:0];
        [self reloadButtonTitle];
        if (self.blockselect) {
            self.blockselect();
        }
    }
}

- (IBAction)ButtonMethod_2:(UIButton *)sender {
    if (self.m_arr.count > 1) {
        [self.m_arr removeObjectAtIndex:1];
        [self reloadButtonTitle];
        if (self.blockselect) {
            self.blockselect();
        }
    }
}

- (IBAction)ButtonMethod_3:(UIButton *)sender {
    if (self.m_arr.count > 2) {
        [self.m_arr removeObjectAtIndex:2];
        [self reloadButtonTitle];
        if (self.blockselect) {
            self.blockselect();
        }
    }
}

@end
