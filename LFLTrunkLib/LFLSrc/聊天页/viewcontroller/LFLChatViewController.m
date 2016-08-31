//
//  LFLChatViewController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController.h"

@interface LFLChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@end

@implementation LFLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *itf = @"cell";
//    UITableViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:itf forIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeight - 64;
}

@end
