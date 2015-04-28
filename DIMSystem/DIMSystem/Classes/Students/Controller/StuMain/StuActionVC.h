//
//  StuActionVC.h
//  DIMSystem
//
//  Created by QQ on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMStudent;
@interface StuActionVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong)DMStudent *studnet;
@end
