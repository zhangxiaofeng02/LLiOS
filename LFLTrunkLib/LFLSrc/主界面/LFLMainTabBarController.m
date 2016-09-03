//
//  LFLMainTabBarController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/4/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLMainTabBarController.h"
#import "LFLFirstTabController.h"
#import "LFLUserCenterViewController.h"
#import "LFLFetcher.h"
#import "LFLFetcherManager.h"

@interface LFLMainTabBarController ()

@property (nonatomic, strong) LFLFetcher *fetcher;
@end

@implementation LFLMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LFLFetcherManager shareInstance] initCoreData];
    [self initChildControllers];
    self.fetcher = [[LFLFetcherManager shareInstance] fetcherWithObject:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initChildControllers {
    LFLFirstTabController *firstVc = [[LFLFirstTabController alloc] init];
    LFLBaseNavigationController *firstNav = [[LFLBaseNavigationController alloc] initWithRootViewController:firstVc];
    firstVc.tabNavigationController = firstNav;
    [self addChildController:firstVc image:@"dpd_navigation_bottom_tab_shenghuo" selectedImageName:@"dpd_navigation_bottom_tab_shenghuo_select" title:@"精选" nav:firstNav];
    
//    LFLFirstTabController *vc2 = [[LFLFirstTabController alloc] init];
//    [self addChildController:vc2 image:@"dpd_navigation_bottom_tab_tuijian" selectedImageName:@"dpd_navigation_bottom_tab_tuijian_select" title:@"客服" nav:nav];
    
//
//    
//    LFLFirstTabController *vc3 = [[LFLFirstTabController alloc] init];
//    [self addChildController:vc3 image:@"dpd_navigation_bottom_tab_waimai" selectedImageName:@"dpd_navigation_bottom_tab_waimai_select" title:@"发现" nav:nav];
//
//    LFLUserCenterViewController *userCenterViewController = [[LFLUserCenterViewController alloc] init];
//    [self addChildController:userCenterViewController image:@"dpd_navigation_bottom_tab_xiangdao" selectedImageName:@"dpd_navigation_bottom_tab_xiangdao_select" title:@"我" nav:nav];
}

- (void)addChildController:(UIViewController *)vc image:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title nav:(LFLBaseNavigationController *)nav {
    vc.title = title;
    vc.tabBarItem.selectedImage = [LFLTrunkBundle imageName:imageName];
    vc.tabBarItem.image = [LFLTrunkBundle imageName:selectedImageName];
    [self addChildViewController:nav];
}

@end
