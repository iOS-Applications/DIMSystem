//
//  RecordInfoCell.h
//  DIMSystem
//
//  Created by 唐亚丽 on 15/6/1.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DIMRecordInfo;

@interface RecordInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

- (void)setSubViewsWithRecordInfo:(DIMRecordInfo *)recordInfo;
@end
