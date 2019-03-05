//
//  ByronXib.h
//  ByronMethodKit
//
//  Created by 杨峰 on 2018/11/1.
//  Copyright © 2018年 杨峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByronXib : NSObject

// 如果在`xib`中有一个控件, 已经明确设置尺寸了,输出的`frame`也是对的, 但是显示出来的效果不一样(比如尺寸变大了), 如果是这种情况一般就是`autoresizingMask`自动伸缩属性在搞鬼! 解决办法如下:
//  在awakeFromNib中设置 self.autoresizingMask = UIViewAutoresizingNone;





@end
