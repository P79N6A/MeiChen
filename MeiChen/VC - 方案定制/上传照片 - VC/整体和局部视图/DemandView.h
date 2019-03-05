//
//  DemandView.h
//  meirong
//
//  Created by yangfeng on 2019/1/19.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (NSString *)defaultString;

@end
