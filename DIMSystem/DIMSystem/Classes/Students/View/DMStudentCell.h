//
//  DMStudentCell.h
//  DIMSystem
//
//  Created by qingyun on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMStudent;

@interface DMStudentCell : UITableViewCell
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  专业及班级
 */
@property (weak, nonatomic) IBOutlet UILabel *classInfoLabel;

/**
 *  职务
 */
@property (weak, nonatomic) IBOutlet UILabel *postLabel;

/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

/**
 *  为控件赋值
 */
- (void)setValuesWithStudnet:(DMStudent *)studnet;

@end
