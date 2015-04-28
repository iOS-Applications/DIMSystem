//
//  StuDetailVC.h
//  DIMSystem
//
//  Created by QQ on 15/4/17.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMStudent.h"

@interface StuDetailVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) DMStudent *studnet;
@end
