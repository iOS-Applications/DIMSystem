//
//  PracPrjCell.h
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PracProjectsModel;
@interface PracPrjCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *prjTitle;
@property (strong, nonatomic) IBOutlet UILabel *teacherName;
@property (strong, nonatomic) IBOutlet UILabel *stuNum;
- (void)setDataForCell:(PracProjectsModel *)model;

@end
