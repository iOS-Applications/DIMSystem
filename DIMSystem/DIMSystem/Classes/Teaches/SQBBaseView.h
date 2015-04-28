//
//  SQBBaseView.h
//  Shanqianbao
//
//  Created by wecash on 15/1/23.
//  Copyright (c) 2015年 shanqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmotionView;

@interface SQBBaseView : UIView

@property (nonatomic,strong) EmotionView *emotionView;
@property (nonatomic,copy) void (^tapViewCompletionBlk)(UIView *emotionView);

- (void)showFailureEmotionView;         //加载失败
- (void)showNotReachableEmotionView;    //网络不可用

- (void)showEmotionViewWithEmotion:(NSString *)emotion title:(NSString *)title;
- (void)dissmissEmotionView;

- (void)showIndicator:(BOOL)show;   //显示等待指示器

@end
