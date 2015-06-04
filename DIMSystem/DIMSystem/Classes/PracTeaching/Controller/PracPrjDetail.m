//
//  PracPrjDetail.m
//  DIMSystem
//
//  Created by qingyun on 15/4/15.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracPrjDetail.h"

@interface PracPrjDetail ()

@property (strong, nonatomic) IBOutlet UILabel *prj_title;
@property (strong, nonatomic) IBOutlet UILabel *prj_source;
@property (strong, nonatomic) IBOutlet UILabel *prj_type;
@property (strong, nonatomic) IBOutlet UILabel *prj_stuNum;
@property (strong, nonatomic) IBOutlet UILabel *prj_teaName;
@property (strong, nonatomic) IBOutlet UILabel *prj_teaJob;
@property (strong, nonatomic) IBOutlet UILabel *prj_description1;
@property (strong, nonatomic) IBOutlet UILabel *prj_description2;

@end

@implementation PracPrjDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:40/255.0 green:178/255.0 blue:255/255.0 alpha:1.0];
    [self setData:self.model];
}

- (void)setData:(PracProjectsModel *)model
{
    self.prj_title.text = model.PraPrj_title;
    self.prj_source.text = model.PraPrj_source;
    self.prj_type.text = model.PraPrj_type;
    self.prj_stuNum.text = model.PraPrj_stuNum;
    self.prj_teaName.text = model.PraPrj_teacher;
    self.prj_teaJob.text = model.PraPrj_job;
    self.prj_description1.text = model.PraPrj_descript1;
    self.prj_description2.text = model.PraPrj_descript2;
    
}

@end
