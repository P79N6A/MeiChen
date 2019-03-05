//
//  SearchDetailVC.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailVC : UIViewController

@property (nonatomic) NSInteger index;

// 从搜索页进入 -> 1
@property (nonatomic, strong) NSString *SearchText;

// 从分类页进入 -> 2
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *titleStr;

// 从详情页进入 -> 3
@property (nonatomic, strong) NSString *searchTitle;

@end
