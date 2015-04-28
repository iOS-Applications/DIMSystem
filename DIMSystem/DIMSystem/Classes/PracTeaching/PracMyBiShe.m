//
//  PracMyBiShe.m
//  DIMSystem
//
//  Created by qingyun on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracMyBiShe.h"
#import "PracProjectsModel.h"
#import "PracPrjCell.h"
#import "PracMyBiSheDetail.h"
@interface PracMyBiShe ()
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation PracMyBiShe

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracPrjCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self loadData];

}


- (void)loadData
{
    NSString *jsonStr = [[NSBundle mainBundle] pathForResource:@"pracProjects.json" ofType:nil];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonStr];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray *newsArray = json[@"data"];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:newsArray.count];
    
    for (int i=0; i<newsArray.count; i++) {
        PracProjectsModel *model = [[PracProjectsModel alloc] initPracProjectsWithInfo:newsArray[i]];
        [modelArray addObject:model];
    }

    self.dataArray = modelArray;
    [self.tableView reloadData];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PracPrjCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setDataForCell:self.dataArray[indexPath.row]];
    return cell;
}
#pragma mark - nextViewController 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PracMyBiSheDetail *BiSheDetail = [[PracMyBiSheDetail alloc] init];
    
    [self presentViewController:BiSheDetail animated:YES completion:nil];
}

@end
