//
//  DMStudentCell.m
//  DIMSystem
//
//  Created by qingyun on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "DMStudentCell.h"
#import "DMStudent.h"

@implementation DMStudentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

#pragma mark //设置信息
- (void)setValuesWithStudnet:(DMStudent *)studnet
{
    self.nameLabel.text = studnet.stu_name;
    
    NSString *classInfoStr = [NSString stringWithFormat:@"%@ %@班",studnet.stu_major,studnet.stu_class];
    self.classInfoLabel.text = classInfoStr;
    
    self.postLabel.text = studnet.stu_post;
    
    self.phoneNumLabel.text = studnet.stu_phone;
}

@end
