//
//  timecutdownView.m
//  meirong
//
//  Created by yangfeng on 2019/1/23.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import "timecutdownView.h"

#define kDegreesToRadians(x) (M_PI*(x)/180.0)                 //把角度转换成PI的方式

@interface timecutdownView () {
    CGFloat view_w;
    CGFloat view_h;
    CGFloat linewidth;
    CGFloat radius;
    CGFloat imv_w;
    
    NSInteger start_Time;
    NSInteger gap_Time;
}

@property (nonatomic, strong) CAShapeLayer *backShapeLayer;
@property (nonatomic, strong) CAShapeLayer *proShapeLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CAShapeLayer *circleLayer;    // 小圆点
@end

@implementation timecutdownView

- (instancetype)init {
    if (self = [super init]) {
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        linewidth = 10;
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark - 圆环进度
- (void)circleProgressView {
    view_w = self.frame.size.width;
    view_h = self.frame.size.height;
    radius = view_w / 2.0 - linewidth / 2.0;
    imv_w = 2*linewidth;
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(view_w/2.0, view_h/2.0) radius:radius startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(360) clockwise:YES];
    
    self.backShapeLayer = [CAShapeLayer layer];
    self.backShapeLayer.frame = self.frame;
    self.backShapeLayer.lineWidth = linewidth;
    self.backShapeLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    self.backShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.backShapeLayer.position = self.center;
    self.backShapeLayer.path = circle.CGPath;
    self.backShapeLayer.strokeStart = 0.0f;
    self.backShapeLayer.strokeEnd = 1.0f;
    [self.layer addSublayer:self.backShapeLayer];
    
    self.proShapeLayer = [CAShapeLayer layer];
    self.proShapeLayer.frame = self.frame;
    self.proShapeLayer.lineWidth = linewidth;
    self.proShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.proShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.proShapeLayer.position = self.center;
    self.proShapeLayer.path = circle.CGPath;
    self.proShapeLayer.strokeStart = 0.0f;
    self.proShapeLayer.strokeEnd = 0.0f;
    self.proShapeLayer.lineCap = kCALineCapRound;
    self.proShapeLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.proShapeLayer];
    
    CGFloat linewidth2 = imv_w/2.0*0.4;
    CGFloat radius2 = imv_w / 2.0 - linewidth2 / 2.0;
    UIBezierPath *circle_2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imv_w/2.0, imv_w/2.0) radius:radius2 startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(360) clockwise:YES];
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.lineWidth = linewidth2;
    self.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.circleLayer.fillColor = kColorRGB(0x21C9D9).CGColor;
    self.circleLayer.path = circle_2.CGPath;
    self.circleLayer.strokeStart = 0.0f;
    self.circleLayer.strokeEnd = 1.0f;
    [self.layer addSublayer:self.circleLayer];
}

- (void)SettingLabStr:(NSString *)str {
    self.label.text = str;
}

- (void)SettingProgress:(CGFloat)pro {
    self.proShapeLayer.strokeEnd = pro;
    self.circleLayer.frame = [self getEndPointFrameWithProgress:pro];
}

- (void)settingLineWidth:(CGFloat)linew {
    linewidth = linew;
}

#pragma mark - 设置进度,自动转圈圈
- (void)AutoCircleWithStartTime:(NSInteger)startTime gapTime:(NSInteger)gapTime {
    start_Time = startTime;
    gap_Time = gapTime;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if (nowTime < startTime) {
        self.label.font = [UIFont boldSystemFontOfSize:50];
        self.label.text = @"00:00";
        self.circleLayer.frame = [self getEndPointFrameWithProgress:0];
    }
    else if (nowTime <= gapTime * 3600 + startTime) {
        CGFloat k = (nowTime - start_Time ) / 1.0 / (gap_Time * 3600);
        self.proShapeLayer.strokeEnd = k;
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    else {
        self.label.font = [UIFont boldSystemFontOfSize:50];
        self.proShapeLayer.strokeEnd = 1.0f;
        self.circleLayer.frame = [self getEndPointFrameWithProgress:0];
        self.label.text = @"00:00";
    }
}

- (void)timeMethod {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSInteger gap = nowTime - start_Time;
    CGFloat k = gap / 1.0 / (gap_Time * 3600);
    if (k > 1) {
        [self.timer setFireDate:[NSDate distantFuture]];
        return;
    }
    self.proShapeLayer.strokeEnd = k;
    self.circleLayer.frame = [self getEndPointFrameWithProgress:k];
    self.label.text = [self getTimeStr:(gap_Time * 3600) - gap];
}

- (NSString *)getTimeStr:(NSInteger)time {
    if (time >= 3600) {
        NSInteger hour = time / 3600;
        NSInteger min = (time % 3600) / 60;
        NSInteger sec = (time % 3600) % 60;
        self.label.font = [UIFont boldSystemFontOfSize:40];
        return [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,min,sec];
    }
    else {
        NSInteger min = time / 60;
        NSInteger sec = time % 60;
        self.label.font = [UIFont boldSystemFontOfSize:50];
        return [NSString stringWithFormat:@"%.2ld:%.2ld",min,sec];
    }
}

//更新小点的位置
-(CGRect)getEndPointFrameWithProgress:(float)progress {
    CGFloat angle = M_PI*2.0*progress;//将进度转换成弧度
    float radius = (self.bounds.size.width-linewidth)/2.0;//半径
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
        default:
            break;
    }
    //为了让圆圈的中心和圆环的中心重合
    x -= (imv_w/2.0f - linewidth/2.0f);
    y -= (imv_w/2.0f - linewidth/2.0f);
    //更新圆环的frame
    CGRect rect = CGRectMake(0, 0, imv_w, imv_w);
    rect.origin.x = x;
    rect.origin.y = y;
    return  rect;
}



- (void)dealloc {
    if (self.timer != nil) {
        [self.timer invalidate];
    }
}

@end
