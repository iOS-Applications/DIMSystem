//
//  pracScientific.m
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "pracScientific.h"
#import "PracPrjCell.h"
#import "PracProjectsModel.h"
#import "PracPrjDetail.h"
#import "AFNetworking.h"

@interface pracScientific ()
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation pracScientific

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracPrjCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self loadData1];
}
- (void)loadData1
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://zzti.sinaapp.com/allProject" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"all%@",operation.responseString);
        NSArray *newsArray = responseObject;
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:newsArray.count];
        
        for (int i=0; i<newsArray.count; i++) {
            PracProjectsModel *model = [[PracProjectsModel alloc] initPracProjectsWithInfo:newsArray[i]];
            [modelArray addObject:model];
            
        }
        self.dataArray = modelArray;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PracPrjDetail *prjDetail = [[PracPrjDetail alloc] init];
    prjDetail.model = self.dataArray[indexPath.row];
    prjDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:prjDetail animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PracPrjCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setDataForCell:self.dataArray[indexPath.row]];
    cell.pracIcon.image = [UIImage imageNamed:@"17-jingsai"];
    
    return cell;
    
}



@end
