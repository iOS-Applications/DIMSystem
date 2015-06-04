//
//  PracMyShiXun.m
//  DIMSystem
//
//  Created by qingyun on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracSymposia.h"
#import "PracProjectsModel.h"
#import "PracSymposiaCell.h"
#import "PracMyBiSheDetail.h"
#import "symposiaHeaderView.h"
#import "symposiaModel.h"
#import "PracSymposiaDetial.h"
#import "symposiaTool.h"

@interface PracSymposia ()<symposiaHeaderViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)UITableViewHeaderFooterView * header;
@property (nonatomic,strong) symposiaHeaderView *headerView;
@end

@implementation PracSymposia

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracSymposiaCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.headerView = (symposiaHeaderView *)[symposiaHeaderView initView];
    self.headerView.headerDelegate = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor colorWithRed:40/255.0 green:178/255.0 blue:255/255.0 alpha:1.0];
    
    self.dataArray = [NSMutableArray array];
    
    [self loadData];
}
- (void)loadData
{
    NSArray *array = [[symposiaTool sharedsymposiaTool] symposiaWithParams:nil];
    NSMutableArray *mutiArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        symposiaModel *model = [[symposiaModel alloc] initPracProjectsWithInfo:dic];
        [mutiArray addObject:model];
    }
    self.dataArray = mutiArray;
    
}

- (void)headView:(symposiaHeaderView *)headerView DidClickButton:(symposiaHeaderButtonType)buttonType
{
    
    if (buttonType == 1) {
        NSDictionary *dic = @{@"semester":headerView.semester.text,@"grade":headerView.grade.text,@"time":headerView.time.text,@"address":headerView.address.text,@"peoples":headerView.peoples.text,@"course":headerView.course.text,@"idea":headerView.idea.text,@"summarize":headerView.summarize.text};
        symposiaModel *model = [[symposiaModel alloc] initPracProjectsWithInfo:dic];
        [self.dataArray addObject:model];
        //
        [[symposiaTool sharedsymposiaTool] saveSymposia:dic];
        
        [self.tableView reloadData];
        [self setheadViewTextNil];
        
    }else{
        
        [self setheadViewTextNil];
    }
}

- (void)setheadViewTextNil
{
    self.headerView.semester.text = nil;
    self.headerView.grade.text = nil;
    self.headerView.time.text = nil;
    self.headerView.address.text = nil;
    self.headerView.peoples.text = nil;
    self.headerView.course.text = nil;
    self.headerView.idea.text = nil;
    self.headerView.summarize.text = nil;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PracSymposiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setCellData:self.dataArray[indexPath.row]];

    cell.backgroundColor = [UIColor colorWithRed:40/255.0 green:178/255.0 blue:255/255.0 alpha:1.0];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       
        symposiaModel *model = self.dataArray[indexPath.row];
         [_dataArray removeObjectAtIndex:indexPath.row];
        NSInteger num = [model.idstr integerValue];
        [[symposiaTool sharedsymposiaTool] deletSymosia:num];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:indexPath, nil];
       
        [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [array removeAllObjects];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PracSymposiaDetial *symposiaDetail = [[PracSymposiaDetial alloc] init];
    
    symposiaDetail.model = self.dataArray[indexPath.row];
    symposiaDetail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:symposiaDetail animated:YES];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self resignFirstResponder];
}
@end
