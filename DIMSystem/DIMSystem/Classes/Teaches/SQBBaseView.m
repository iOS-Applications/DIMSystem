//
//  SQBBaseView.m
//  Shanqianbao
//
//  Created by wecash on 15/1/23.
//  Copyright (c) 2015年 shanqb. All rights reserved.
//

#import "SQBBaseView.h"
//#import "MacroDefinition.h"
#import "EmotionView.h"
//#import "SVProgressHUD.h"

@implementation SQBBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.tapViewCompletionBlk != NULL) {
        self.tapViewCompletionBlk(_emotionView);
    }
}

- (void)showEmotionViewWithEmotion:(NSString *)emotion title:(NSString *)title
{
    if (_emotionView == nil) {
        _emotionView = [[EmotionView alloc] init];
        [self addSubview:_emotionView];
    }
    _emotionView.hidden = NO;
    _emotionView.emotionStr = emotion;
    _emotionView.title = title;
    
    _emotionView.center = CGPointMake(self.frame.size.width/2.0f, (self.frame.size.height - _emotionView.frame.size.height)/2.0f);
}

- (void)showFailureEmotionView
{
    [self showEmotionViewWithEmotion:@"⊙︿⊙" title:@"没加载出来，点击屏幕重新加载"];
}

- (void)showNotReachableEmotionView
{
    [self showEmotionViewWithEmotion:@"⊙﹏⊙" title:@"网络不给力，点击屏幕重新加载"];
}

- (void)dissmissEmotionView
{
    _emotionView.hidden = YES;
    [_emotionView removeFromSuperview];
    _emotionView = nil;
}

- (void)showIndicator:(BOOL)show
{
    if (show == YES) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//        [SVProgressHUD setForegroundColor:[UIColor orangeColor]];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        [SVProgressHUD show];
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [SVProgressHUD dismiss];
    }
}

@end
