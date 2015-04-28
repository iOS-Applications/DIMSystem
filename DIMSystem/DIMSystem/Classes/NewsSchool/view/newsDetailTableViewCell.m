//
//  newsDetailTableViewCell.m
//  DIMSystem
//
//  Created by qingyun on 15/4/12.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "newsDetailTableViewCell.h"
#import "newsModel.h"
#import "DIMTextHeight.h"

@implementation newsDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextData:(newsModel *)model
{
    self.text.text = model.news_description;
    
}

+ (CGFloat)cellHeight:(newsModel *)model
{
    CGFloat cellHeight = 0;
    NSString *content = model.news_description;
    cellHeight += [DIMTextHeight textHeightWith:content FontSize:17 inWidth:0];
    return cellHeight;
}

@end
