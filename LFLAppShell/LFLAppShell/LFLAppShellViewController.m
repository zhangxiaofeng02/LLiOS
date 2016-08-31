//
//  LFLAppShellViewController.m
//  LFLAppShell
//
//  Created by 啸峰 on 16/4/4.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLAppShellViewController.h"
#import "LFLToolsLib.h"
#import "LFLTrunkLib.h"

@interface LFLAppShellViewController()<UINavigationControllerDelegate>

@property (nonatomic, strong) LFLBaseNavigationController *navigationController;
@end

@implementation LFLAppShellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LFLMainTabBarController *root = [[LFLMainTabBarController alloc] init];
    [self addChildViewController:root];
    [self.view addSubview:root.view];
}
@end
