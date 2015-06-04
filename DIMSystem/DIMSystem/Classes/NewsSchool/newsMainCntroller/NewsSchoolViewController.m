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
#import "MJRefresh.h"
#import "AFNetworking.h"

@interface NewsSchoolViewController ()
@property (nonatomic,strong) CustomVIew *customView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation NewsSchoolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.加载数据
    [self loadData1];
    //2. 添加HeaderFooterView
    [self setupHeaderFooterView];
    //3.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"newsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.title = @"校园新闻";
    [self example02];
    [self example12];
}

- (void)loadData1
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://zzti.sinaapp.com/news" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"news%@",operation.responseString);
        NSArray *newsArray = responseObject;
        
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:newsArray.count];
        
        for (int i=0; i<newsArray.count; i++) {
            newsModel *model = [[newsModel alloc] initNewsModel:newsArray[i]];
            [modelArray addObject:model];
        }
        self.dataArray = modelArray;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"news error:%@",error);
    }];
    
    
    
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
- (void)example02
{
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [self.tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    // 在这个例子中，即将刷新 和 正在刷新 用的是一样的动画图片
    
    // 马上进入刷新状态
    [self.tableView.gifHeader beginRefreshing];
    
    // 此时self.tableView.header == self.tableView.gifHeader
}

#pragma mark UITableView + 上拉刷新 动画图片
- (void)example12
{
    // 添加动画图片的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    self.tableView.gifFooter.refreshingImages = refreshingImages;
    
    // 此时self.tableView.footer == self.tableView.gifFooter
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
    
//
}
- (void)loadNewData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        [self loadData1];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData1];
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    });
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
