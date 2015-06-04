//
//  PracSymposiaCell.h
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class symposiaModel;
@interface PracSymposiaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cource;
@property (weak, nonatomic) IBOutlet UILabel *grate;
@property (weak, nonatomic) IBOutlet UILabel *time;

- (void)setCellData:(symposiaModel *)model;

@end
