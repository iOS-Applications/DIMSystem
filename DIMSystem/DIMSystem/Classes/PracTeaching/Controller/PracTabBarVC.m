//
//  StuTabBarVC.m
//  DIMSystem
//
//  Created by qingyun on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracTabBarVC.h"
#import "PracProjectsOfItem.h"
#import "pracScientific.h"
#import "PracShiXun.h"


@interface PracTabBarVC ()

@end

@implementation PracTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载三个模块视图
    [self setupAllChildViewControllers];
}

#pragma mark //初始化所有自控制器
- (void)setupAllChildViewControllers
{
    //1.消息
    PracProjectsOfItem *prjBiShe = [[PracProjectsOfItem alloc] init];
    [self setupChildViewController:prjBiShe title:@"毕业设计" imageName:@"bishe.png" selectedImageName:nil];
    
    //2.项目
    PracShiXun *projectVC = [[PracShiXun alloc] init];
    [self setupChildViewController:projectVC title:@"实训项目" imageName:@"shixun.png" selectedImageName:nil];
    
    //3.学生信息查询
    pracScientific *infoCheckVC = [[pracScientific alloc] init];
    [self setupChildViewController:infoCheckVC title:@"科研竞赛" imageName:@"keyan.png" selectedImageName:nil];
    
}

/**
 *  初始化一个子控制器
 *
 *  @param childVC           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    //1.设置控制器的属性
    childVC.title = title;
    
    //2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    [nav.navigationBar setBarTintColor:[UIColor colorWithRed:11/255.0 green:81/255.0 blue:144/255.0 alpha:1.0]];
    UIImage *selectImage = [UIImage imageNamed:imageName];
    [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:selectImage selectedImage:selectImage];

    [self addChildViewController:nav];
}

@end
