//
//  PracShiXun.m
//  DIMSystem
//
//  Created by qingyun on 15/4/15.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracShiXun.h"
#import "CollectionViewCell.h"
#import "PracProjectsModel.h"
#import "PracPrjDetail.h"
#import "AFNetworking.h"

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)

@interface PracShiXun ()

@property (strong,nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PracShiXun
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self loadData1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    cell.text.text = [self.dataArray[indexPath.row] PraPrj_title];
    cell.text.font = [UIFont systemFontOfSize:12];
    NSString *teaName = [NSString stringWithFormat:@"——%@ ",[self.dataArray[indexPath.row] PraPrj_teacher]];
    cell.btnLable.text = teaName;
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((fDeviceWidth-30)/3-10, (fDeviceWidth-30)/3+20);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 5, 15);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PracPrjDetail *next = [[PracPrjDetail alloc] init];
    next.model = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:next animated:YES];

}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    [self.collectionView reloadData];
}

@end
