//
//  PracSymposiaDetial.m
//  DIMSystem
//
//  Created by RenCH on 15/6/2.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracSymposiaDetial.h"

@interface PracSymposiaDetial ()

@property (weak, nonatomic) IBOutlet UILabel *semester;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *peoples;
@property (weak, nonatomic) IBOutlet UILabel *course;
@property (weak, nonatomic) IBOutlet UITextView *idea;
@property (weak, nonatomic) IBOutlet UITextView *summarize;

@end

@implementation PracSymposiaDetial

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:40/255.0 green:178/255.0 blue:255/255.0 alpha:1.0];
    self.semester.text = self.model.semester;
    self.grade.text = self.model.grade;
    self.time.text = self.model.time;
    self.address.text = self.model.address;
    self.peoples.text = self.model.peoples;
    self.course.text = self.model.course;
    self.idea.text = self.model.idea;
    self.summarize.text = self.model.summarize;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
