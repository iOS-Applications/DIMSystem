//
//  EmotionView.m
//  Shanqianbao
//
//  Created by wecash on 15/1/28.
//  Copyright (c) 2015年 shanqb. All rights reserved.
//

#import "EmotionView.h"

@interface EmotionView()
{
    UILabel *emotionLabel;
    UILabel *titleLabel;
}
@end

@implementation EmotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        emotionLabel = [[UILabel alloc] init];
        emotionLabel.font = [UIFont systemFontOfSize:38];
        emotionLabel.textColor = [UIColor grayColor];
        [self addSubview:emotionLabel];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat width = self.frame.size.width;
    CGRect originFrame = emotionLabel.frame;
    originFrame.origin = CGPointMake((width - originFrame.size.width)/2.0f, 0);
    emotionLabel.frame = originFrame;
    
    originFrame = titleLabel.frame;
    originFrame.origin = CGPointMake((width - originFrame.size.width)/2.0f, CGRectGetMaxY(emotionLabel.frame) + 27);
    titleLabel.frame = originFrame;
}

- (void)setEmotionStr:(NSString *)emotionStr
{
    _emotionStr = emotionStr;
    emotionLabel.text = emotionStr;
    [emotionLabel sizeToFit];
    
    [self resetViewFrame];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    [self resetViewFrame];
}

- (void)resetViewFrame
{
    //求取self宽度
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (_emotionStr != nil && (![_emotionStr isKindOfClass:[NSNull class]])) {
        emotionLabel.text = _emotionStr;
        [emotionLabel sizeToFit];
        height = emotionLabel.frame.size.height;
        
        if (emotionLabel.frame.size.width > titleLabel.frame.size.width) {
            width = emotionLabel.frame.size.width;
        } else {
            width = titleLabel.frame.size.width;
        }
    }
    
    if (_title != nil && (![_title isKindOfClass:[NSNull class]])) {
        titleLabel.text = _title;
        [titleLabel sizeToFit];
        if (_emotionStr == nil) {
            height += titleLabel.frame.size.height;
        } else {
            height += (titleLabel.frame.size.height + 27);
        }
    }
    self.frame = CGRectMake(0,0,width,height);
}

@end
