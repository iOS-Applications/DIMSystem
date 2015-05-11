//
//  ZFQProgressView.m
//  DIMSystem
//
//  Created by wecash on 15/5/10.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQProgressView.h"
#define ZFQ_progressView_margin 4

@implementation ZFQProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 4;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - ZFQ_progressView_margin;
    
    // 背景圆
    [[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1] set];  //SDColorMaker(240, 240, 240, 1)
    CGFloat w = radius * 2 + _lineWidth * 2;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    // 进程圆
    [[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:0.8] set]; //SDColorMaker(150, 150, 150, 0.8)
    //先画个竖线
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    _currProgress = (_currProgress >= 1) ? 0.999 : _currProgress;
    CGFloat to = - M_PI * 0.5 + _currProgress * M_PI * 2 + 0.001; // 初始值
    //再画弧线
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}


- (void)setCurrProgress:(CGFloat)currProgress
{
    _currProgress = currProgress;
    [self setNeedsDisplay];
}
@end
