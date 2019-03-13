//
//  ExchangeJiFenView.m
//  meirong
//
//  Created by yangfeng on 2019/3/13.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "ExchangeJiFenView.h"

@implementation ExchangeJiFenView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeJiFenView" owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadNaneLab:0];
    
    self.lab_1.text = NSLocalizedString(@"ExchangeJiFenVC_4", nil);
    self.lab_2.text = NSLocalizedString(@"ExchangeJiFenVC_6", nil);
    self.lab_3.text = NSLocalizedString(@"ExchangeJiFenVC_7", nil);
    self.lab_4.text = NSLocalizedString(@"ExchangeJiFenVC_8", nil);
    self.lab_5.text = NSLocalizedString(@"ExchangeJiFenVC_9", nil);
    [self.all setTitle:NSLocalizedString(@"ExchangeJiFenVC_5", nil) forState:(UIControlStateNormal)];
    [self.submit setTitle:NSLocalizedString(@"ExchangeJiFenVC_10", nil) forState:(UIControlStateNormal)];
    
    self.tf_price.placeholder = NSLocalizedString(@"ExchangeJiFenVC_15", nil);
//    [self.tf_number addTarget:self action:@selector(TextFieldEditingChange:) forControlEvents:(UIControlEventEditingChanged)];
    self.tf_number.delegate = self;
}

// 可兑换积分
- (void)loadNaneLab:(NSInteger)count {
    NSString *countStr = [NSString stringWithFormat:@"%ld",count];
    NSMutableString *m_str = [NSMutableString string];
    [m_str appendString:NSLocalizedString(@"ExchangeJiFenVC_3", nil)];
    [m_str appendString:@": "];
    [m_str appendString:countStr];
    [m_str appendString:@" "];

    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:m_str];
    NSRange range = [m_str rangeOfString:countStr];
    
    // 修改富文本中的不同文字的样式
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x333333) range:NSMakeRange(0, m_str.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, m_str.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:kColorRGB(0x418DD9) range:range];
    [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    self.nane.attributedText = attribut;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL returnValue = YES;
    NSMutableString *newText = [NSMutableString stringWithCapacity:0];
    [newText appendString:textField.text];// 拿到原有text,根据下面判断可能给它添加" "(空格);
    NSString * noBlankStr = [textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    NSInteger textLength = [noBlankStr length];
    if (string.length) {
        if (textLength < 20) {//这个25是控制实际字符串长度,比如银行卡号长度
            if (textLength > 0 && textLength %4 == 0) {
                newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [newText appendString:@" "];
                [newText appendString:string];
                textField.text = newText;
                returnValue = NO;//为什么return NO?因为textField.text = newText;text已经被我们替换好了,那么就不需要系统帮我们添加了,如果你ruturnYES的话,你会发现会多出一个字符串
            }
            else {
                [newText appendString:string];
            }
        }
        else {  // 比25长的话 return NO这样输入就无效了
            returnValue = NO;
        }
    }
    else {  // 如果输入为空,该怎么地怎么地
        [newText replaceCharactersInRange:range withString:string];
    }
    return returnValue;
}

@end
