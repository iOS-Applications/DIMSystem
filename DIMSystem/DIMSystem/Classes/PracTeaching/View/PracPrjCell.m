//
//  PracPrjCell.m
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracPrjCell.h"
#import "PracProjectsModel.h"
@implementation PracPrjCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataForCell:(PracProjectsModel *)model
{
    self.prjTitle.text = model.PraPrj_title;
    self.teacherName.text = model.PraPrj_teacher;
    self.stuNum.text = model.PraPrj_stuNum;
}
@end
