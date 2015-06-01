//
//  RecordInfoCell.m
//  DIMSystem
//
//  Created by 唐亚丽 on 15/6/1.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "RecordInfoCell.h"
#import "DIMRecordInfo.h"
#import "DMStudent.h"
@implementation RecordInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubViewsWithRecordInfo:(DIMRecordInfo *)recordInfo
{
    self.timeLabel.text = recordInfo.rec_time;
    
    NSString *studentsName = nil;
    NSArray *students = recordInfo.rec_students;
    
    for (DMStudent *student in students) {
        
    }
    self.studentsLabel.text = studentsName;
    
    if (recordInfo.rec_type) {
        [self.iconImage setImage:[UIImage imageNamed:@""]];
    }else{
        [self.iconImage setImage:[UIImage imageNamed:@""]];
    }
}
@end
