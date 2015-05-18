//
//  StuTabBarVC.m
//  DIMSystem
//
//  Created by qingyun on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuTabBarVC.h"
#import "StuMessageVC.h"
#import "StuProjectVC.h"
#import "StuInfoCheckVC.h"

@interface StuTabBarVC ()

@end

@implementation StuTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载三个模块视图
    [self setupAllChildViewControllers];
}

//#pragma mark - tabBarController.tabBar重现方法
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%d",self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count > 1) {
        self.parentViewController.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark //初始化所有自控制器
- (void)setupAllChildViewControllers
{
    //1.消息
    StuMessageVC *messageVC = [[StuMessageVC alloc] init];
    [self setupChildViewController:messageVC title:@"消息" imageName:@"message" selectedImageName:@"message_press"];
    
    //2.项目
    StuProjectVC *projectVC = [[StuProjectVC alloc] init];
    [self setupChildViewController:projectVC title:@"项目" imageName:@"project" selectedImageName:@"project_press"];
    
    //3.学生信息查询
    StuInfoCheckVC *infoCheckVC = [[StuInfoCheckVC alloc] init];
    [self setupChildViewController:infoCheckVC title:@"查询" imageName:@"infoCheck" selectedImageName:@"infoCheck_press"];
    
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
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

@end
