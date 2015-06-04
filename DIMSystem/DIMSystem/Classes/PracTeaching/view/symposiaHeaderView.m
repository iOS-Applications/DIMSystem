//
//  symposiaHeaderView.m
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "symposiaHeaderView.h"
#import "symposiaModel.h"

@implementation symposiaHeaderView


+(UITableViewHeaderFooterView *)initView
{
    UITableViewHeaderFooterView *header = [[[NSBundle mainBundle] loadNibNamed:@"symposiaHeaderView" owner:nil options:nil] lastObject];
    
    return header;
                                           
}
- (IBAction)headerButtonClick:(UIButton *)sender {
    if ([self.headerDelegate respondsToSelector:@selector(headView:DidClickButton:)]) {
        [self.headerDelegate headView:self DidClickButton:(symposiaHeaderButtonType)sender.tag];
    }

}

@end
