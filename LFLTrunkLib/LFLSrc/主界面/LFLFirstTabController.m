//
//  LFLFirstTabController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/4/4.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLFirstTabController.h"
#import "LFLChatViewController.h"
#import "LFLTrunkBundle.h"

@implementation LFLFirstTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChatComponentButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChatComponentButton {
    UIButton *chat = [[UIButton alloc] init];
    chat.layer.borderColor = Color(156, 156, 156, 1).CGColor;
    chat.layer.borderWidth = 1 / ScreenScale;
    [chat setTitleColor:Color(156, 156, 156, 1) forState:UIControlStateNormal];
    [self.view addSubview:chat];
    [chat setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chat setTitle:@"进入聊天" forState:UIControlStateNormal];
    NSMutableArray *conts = @[].mutableCopy;
    NSDictionary *dict = NSDictionaryOfVariableBindings(self.view,chat);
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-20-[chat(%f)]",80.0f] options:0 metrics:nil views:dict]];
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-120-[chat(%f)]",40.0f] options:0 metrics:nil views:dict]];
    [self.view addConstraints:conts];
    [chat addTarget:self action:@selector(enterChatComponent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enterChatComponent {
    LFLChatViewController *chat = [[LFLChatViewController alloc] initWithNibName:@"LFLChatViewController" bundle:[LFLTrunkBundle resourceBundle]];
    self.hidesBottomBarWhenPushed = YES;
    [self.tabNavigationController pushViewController:chat animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}
@end
