//
//  projectsOfItem.m
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracProjectsOfItem.h"
#import "PracProjectsModel.h"
#import "PracPrjCell.h"
#import "UIBarButtonItem+DIM.h"
#import "PracPrjDetail.h"
#import "PracMyBiShe.h"
#import "PracSymposia.h"
#import "teachingPlan.h"
#import "AFNetworking.h"

@interface PracProjectsOfItem ()

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,assign) BOOL btnStatus;
@property (nonatomic,strong) UIView *addView;

@end

@implementation PracProjectsOfItem

NSInteger btnx;
NSInteger btny;
NSInteger space;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracPrjCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"back3" HighegIcon:@"back3" Target:self action:@selector(modalDismiss)];
    

     self.navigationController.navigationBar.hidden = NO;
    [self addRightBarButten];
    [self loadData1];
    
}

- (UIBarButtonItem *)itemWithIcon:(NSString *)icon HighegIcon:(NSString *)highIcon Target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 22);
    
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PracPrjDetail *prjDetail = [[PracPrjDetail alloc] init];
    prjDetail.model = self.dataArray[indexPath.row];
    prjDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:prjDetail animated:YES];
}

//右侧按钮
- (void)addRightBarButten
{
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"内页-菜单键-press"] forState:UIControlStateNormal];
    self.btnStatus = YES;
    [self.btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn =  [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

#pragma mark - action

- (void)modalDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)click
{
    
    if (self.btnStatus == YES) {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"内页-菜单键"] forState:UIControlStateNormal];
        self.addView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.addView.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:0.92];
        
        UIView *sunView = [[UIView alloc] initWithFrame:CGRectMake(0, 71, [UIScreen mainScreen].bounds.size.width, 1)];
        sunView.backgroundColor = [UIColor colorWithRed:29/255.0 green:210/255.0 blue:116/255.0 alpha:1.0];
        self.navigationItem.hidesBackButton = YES;
        [self.addView addSubview:sunView];
        
        [self addMenu];
        [self addLable];
        [self.parentViewController.view addSubview:self.addView];
        
    }
    else{
        [self.btn setBackgroundImage:[UIImage imageNamed:@"内页-菜单键-press"] forState:UIControlStateNormal];
        [self.addView removeFromSuperview];
        self.navigationItem.hidesBackButton = NO;
    }
    self.btnStatus = !self.btnStatus;
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
- (void)addMenu
{
    btnx = btny = 32;
    space = ([UIScreen mainScreen].bounds.size.width - btny*3)/4;
    UIButton *mesBtn = [[UIButton alloc] initWithFrame:CGRectMake(space, 20, btnx, btny)];
    
    [mesBtn setBackgroundImage:[UIImage imageNamed:@"bishe2.png"] forState:UIControlStateNormal];
    
    [mesBtn addTarget:self action:@selector(myPrjBiShe) forControlEvents:UIControlEventTouchDown];
    [self.addView addSubview:mesBtn];
    
    UIButton *deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*2+btnx, 20, btnx, btny)];
    
    
    [deleBtn setImage:[UIImage imageNamed:@"shixun2.png"] forState:UIControlStateNormal];
    
    [deleBtn addTarget:self action:@selector(myPrjShiXun) forControlEvents:UIControlEventTouchDown];
    
    [self.addView addSubview:deleBtn];
    
    UIButton *signBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*3+btny*2, 20, btnx, btny)];
    [signBtn setBackgroundImage:[UIImage imageNamed:@"Word-Mac.png"] forState:UIControlStateNormal];

    [signBtn addTarget:self action:@selector(myPrjKeYan) forControlEvents:UIControlEventTouchDown];
    [self.addView addSubview:signBtn];
}

//添加小标题
- (void)addLable
{
    btnx = btny = 50;
    space = ([UIScreen mainScreen].bounds.size.width - btny*3)/4;
    UILabel *messaLable = [[UILabel alloc] initWithFrame:CGRectMake(space+10, 38, 40, btny)];
    
    [self addSubVieWith:messaLable and:@"我的项目"];
    
    UILabel *deleLab = [[UILabel alloc] initWithFrame:CGRectMake(space*2+btnx+6, 38, 40, btny)];
    [self addSubVieWith:deleLab and:@"教学座谈"];
    
    UILabel *signBtn = [[UILabel alloc] initWithFrame:CGRectMake(space*3+2*btnx, 38, 40, btny)];
    [self addSubVieWith:signBtn and:@"培养计划"];
}
- (void)addSubVieWith:(UILabel *)lable and:(NSString *)text
{
    lable.text = text;
    lable.font = [UIFont systemFontOfSize:10];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.addView addSubview:lable];
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

#pragma nextViewController

- (void)myPrjBiShe
{
    [self.addView removeFromSuperview];
     self.btnStatus = YES;
    [self.btn setBackgroundImage:[UIImage imageNamed:@"内页-菜单键-press"] forState:UIControlStateNormal];
     PracMyBiShe *nextVC = [[PracMyBiShe alloc] init];
    
     nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}
- (void)myPrjShiXun
{
    PracSymposia *nextVC = [[PracSymposia alloc] init];
    [self.addView removeFromSuperview];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (void)myPrjKeYan
{
    
    teachingPlan *nextVC = [[teachingPlan alloc] init];
    [self.addView removeFromSuperview];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

@end
