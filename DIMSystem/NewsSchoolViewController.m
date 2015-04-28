//
//  NewsSchoolViewController.m
//  DIMSystem
//
//  Created by qingyun on 15/4/8.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "NewsSchoolViewController.h"
#import "CustomVIew.h"
#import "commenConst.h"
#import "newsModel.h"
#import "newsCell.h"
#import "NewsDetaileViewController.h"

@interface NewsSchoolViewController ()
@property (nonatomic,strong) CustomVIew *customView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation NewsSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.加载数据
    [self loadData];
    //2. 添加HeaderFooterView
    [self setupHeaderFooterView];
    //3.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"newsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.title = @"校园新闻";
}

- (void)loadData
{
     NSString *jsonStr = [[NSBundle mainBundle] pathForResource:@"newsData.json" ofType:nil];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonStr];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray *newsArray = json[@"data"];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:newsArray.count];
    
    for (int i=0; i<newsArray.count; i++) {
        newsModel *model = [[newsModel alloc] initNewsModel:newsArray[i]];
        [modelArray addObject:model];
    }
    self.dataArray = modelArray;
    [self.tableView reloadData];
    
}

- (void)setupHeaderFooterView
{
    //1.添加headrview
    CustomVIew *customView = [[CustomVIew alloc]init];
    customView.frame = CGRectMake(0, 0, kScreenWidth, 168);
    self.customView = customView;
    NSArray *imageArrays = @[@"img_01.jpg",@"img_02.jpg",@"img_03.jpg",@"img_04.jpg",@"img_05.jpg"];
    
    self.customView.imageArrays = imageArrays;
    [self.customView addScrollTimer];
    
    self.tableView.tableHeaderView = self.customView ;
    
    //2.添加footerView
    self.tableView.tableFooterView = [[UIView alloc]init];
    
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    newsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setCellData:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetaileViewController *newsDetail = [[NewsDetaileViewController alloc] init];
    newsDetail.model = self.dataArray[indexPath.row];
    [newsDetail.navigationItem.backBarButtonItem setTitle:@"back"];
    [self.navigationController pushViewController:newsDetail animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
