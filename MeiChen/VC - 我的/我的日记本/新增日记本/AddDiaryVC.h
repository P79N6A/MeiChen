//
//  AddDiaryVC.h
//  meirong
//
//  Created by yangfeng on 2019/2/14.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDiaryVC : UIViewController

@property (nonatomic, strong) DiaryDetailModel *diaryModel;
@property (nonatomic) BOOL isfirst;

@property (nonatomic, strong) MyDiaryModel *mydiary;

@end
