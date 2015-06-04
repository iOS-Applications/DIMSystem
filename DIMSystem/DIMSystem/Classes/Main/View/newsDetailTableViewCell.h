//
//  newsDetailTableViewCell.h
//  DIMSystem
//
//  Created by qingyun on 15/4/12.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class newsModel;

@interface newsDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *text;

- (void)setTextData:(newsModel *)model;

+ (CGFloat)cellHeight:(newsModel *)model;
@end
