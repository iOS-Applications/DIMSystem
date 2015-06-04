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
#import "AFNetworking.h"

@interface PracMyBiShe ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIBarButtonItem *rigBtn;
@property (nonatomic,strong) NSMutableArray *deltArray;

@end

@implementation PracMyBiShe

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNoti" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];


    [self.tableView registerNib:[UINib nibWithNibName:@"PracPrjCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.rigBtn = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(edite)];
    
    self.navigationItem.rightBarButtonItem = self.rigBtn;
    
    self.deltArray = [NSMutableArray array];
   
    [self loadData1];

}
- (void)edite
{
    if ([self.rigBtn.title isEqualToString:@"多选"]) {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView setEditing:YES animated:YES];
        [self.rigBtn setTitle:@"删除"];
    }else{
        [self.rigBtn setTitle:@"多选"];
        for (NSIndexPath *index in self.deltArray) {
            [self.dataArray removeObjectAtIndex:index.row];
        }
        [self.tableView deleteRowsAtIndexPaths:self.deltArray withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];

        [self.tableView setEditing:NO animated:YES];
        NSLog(@"点击wancheng");
    }
}

- (void)loadData1
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"teaID":@"40110023"};
    
    [manager GET:@"http://zzti.sinaapp.com/searchProjectWithTeaID" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *newsArray = responseObject;
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:newsArray.count];
        for (int i=0; i<newsArray.count; i++) {
            PracProjectsModel *model = [[PracProjectsModel alloc] initPracProjectsWithInfo:newsArray[i]];
            [modelArray addObject:model];
        }
        
        self.dataArray = modelArray;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"errer:%@",error);
        
    }];
    
    
}

//bendi
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
    cell.pracIcon.image = [UIImage imageNamed:@"pracPrj"];
    
    return cell;
}

// Override to support conditional editing of the table view.
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
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        PracProjectsModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:indexPath, nil];
        //删除数据
        [self deleteData:model];
        [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [array removeAllObjects];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)deleteData:(PracProjectsModel *)model
{
    
    NSDictionary *parameter = @{@"praPrj_id":model.PraPrj_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://zzti.sinaapp.com/deleteProject" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"delete:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

#pragma mark - nextViewController 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([self.rigBtn.title isEqualToString:@"多选"]){
        PracMyBiSheDetail *BiSheDetail = [[PracMyBiSheDetail alloc] init];
        
        BiSheDetail.model = self.dataArray[indexPath.row];
        
        [self presentViewController:BiSheDetail animated:YES completion:nil];
    }else{
         [self.deltArray removeAllObjects];
         [self.deltArray addObject:indexPath];
    }
    
}

@end
