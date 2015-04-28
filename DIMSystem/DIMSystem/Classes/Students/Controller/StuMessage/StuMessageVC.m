//
//  StuMessageVC.m
//  DIMSystem
//
//  Created by qingyun on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuMessageVC.h"

@interface StuMessageVC ()

@end

@implementation StuMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //设置主题view切换消息和通话
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"消息",@"电话" ,nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segment.frame = CGRectMake(0, 0, 80, 30);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    
    //添加left按钮返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_press"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.leftBarButtonItem = leftItem;

    
}

#pragma mark //返回按钮点击事件
- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark //segment 切换tableView的datasource
- (void)changeDataSource:(UISegmentedControl *)segment
{
    NSLog(@"haha");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
@end
