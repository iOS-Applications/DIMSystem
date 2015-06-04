//
//  PracSymposiaCell.m
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracSymposiaCell.h"
#import "symposiaModel.h"

@implementation PracSymposiaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellData:(symposiaModel *)model
{
    self.cource.text = model.course;
    self.grate.text = model.grade;
    self.time.text = model.time;
    
}
@end
