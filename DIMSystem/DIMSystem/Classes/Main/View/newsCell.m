//
//  newsCell.m
//  DIMSystem
//
//  Created by qingyun on 15/4/8.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "newsCell.h"
#import "newsModel.h"
@implementation newsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellData:(newsModel *)model
{
    self.newsImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.newsicon_url]];
    self.title.text = model.news_title;
    self.title.font = [UIFont boldSystemFontOfSize:15];
    self.time.text = model.news_createtime;
    self.text.text = model.news_description;
    
}
@end
