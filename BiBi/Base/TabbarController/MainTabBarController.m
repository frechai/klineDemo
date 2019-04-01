//
//  MainTabBarController.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "MainTabBarController.h"

#import "RootNavigationController.h"
#import "HomeVC.h"
#import "InformationVC.h"
#import "ExchangeVC.h"
#import "OutsideVC.h"
#import "MyVC.h"


@interface MainTabBarController ()

@property (nonatomic, strong) NSMutableArray *VCS;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabBar];
    [self setUpAllChildViewController];
}

#pragma mark 初始化TabBar
- (void)setUpTabBar
{
    //设置Tabbar背景色，去掉底部分割线
    [self.tabBar setBackgroundColor:TabBarBgColor];
    [self.tabBar setBackgroundImage:[UIImage new]];
}

#pragma mark 初始化VC
- (void)setUpAllChildViewController
{
    _VCS = @[].mutableCopy;
    HomeVC *VC0 = [[HomeVC alloc] init];
    [self setupChildViewController:VC0 title:@"行情" imageName:@"hangqing_no" seleceImageName:@"hangqing_yes"];
    
    InformationVC *VC1 = [[InformationVC alloc] init];
    [self setupChildViewController:VC1 title:@"资讯" imageName:@"zixun_no" seleceImageName:@"zixun_yes"];

    
    ExchangeVC *VC2 = [[ExchangeVC alloc] init];
    [self setupChildViewController:VC2 title:@"交易" imageName:@"jiaoyi_no" seleceImageName:@"jiaoyi_yes"];

    OutsideVC *VC3 = [[OutsideVC alloc] init];
    [self setupChildViewController:VC3 title:@"场外" imageName:@"zijin_no" seleceImageName:@"zijin_yes"];

    MyVC *VC4 = [[MyVC alloc] init];
    [self setupChildViewController:VC4 title:@"我的" imageName:@"wode_no" seleceImageName:@"wode_yes"];

}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KWhiteColor,NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SelectedColor,NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
    [self addChildViewController:nav];
    [_VCS addObject:nav];
}




























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
