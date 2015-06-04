//
//  symposiaHeaderView.h
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    symposiaHeaderTypeButtonSave,
    symposiaHeaderTypeButtonCancel,
}symposiaHeaderButtonType;

@class symposiaHeaderView;
//自己写一个代理
@protocol symposiaHeaderViewDelegate <NSObject>
@optional
- (void)headView:(symposiaHeaderView *)headerView DidClickButton:(symposiaHeaderButtonType)buttonType;
@end

@interface symposiaHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UITextField *semester;
@property (weak, nonatomic) IBOutlet UITextField *grade;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *peoples;
@property (weak, nonatomic) IBOutlet UITextField *course;

@property (weak, nonatomic) IBOutlet UITextView *idea;
@property (weak, nonatomic) IBOutlet UITextView *summarize;

+ (UITableViewHeaderFooterView *)initView;

@property (nonatomic,weak)id <symposiaHeaderViewDelegate>headerDelegate;

@end
