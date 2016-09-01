//
//  LFLChatViewController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController.h"
#import "LFLChatRightMessageViewCell.h"

@interface LFLChatViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) LFLChatRightMessageViewCell *rightMessageCell;
@end

@implementation LFLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatRightMessageViewCell class] bundle:@"LFLTrunkBundle"];
    self.dataArr = @[@"这是一条测试语句",
                     @"这是一条测是一条测试是一条测试试语句",
                     @"这是一是一条测试是一条测试是一条测试是一条测试是一条测试是一条测试条测试语句",
                     @"这是一条条测试是一条测试是一条测试是一条测试是一测试语句",
                     @"这是一条测试语句",
                     @"这是试语句",
                     @"这是一条测是一条测试是一条测试是一条测试是一条测试是一条测试是一条测试是一条测试试语句",
                     @"这是一条测条测试条测试条测试条测试条测试条测试条测试试语句",
                     @"这是一条测试条测试条测试条测试条测试语句",
                     @"这是一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语句",
                     @"这是一条测试语一条测试语一条测试语一条测试语一条测试语试语句",
                     @"这是一条测一条测一条测一条测一条测试语句",
                     @"这是一条测试语句",
                     @"这是一条测条测试条测试条测试条测试条测试条测试条测试试语句",
                     @"这是一条测试条测试条测试条测试条测试语句",
                     @"这是一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语一条测试语句",
                     @"这是一条测试语一条测试语一条测试语一条测试语一条测试语试语句",
                     @"这是一条测一条测一条测一条测一条测试语句",
                     @"这是一条测试语句"];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFLChatRightMessageViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setMessage:self.dataArr[[indexPath row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.rightMessageCell sizeForText:self.dataArr[[indexPath row]]];
    return  height + 30;
}

#pragma mark getter && setter

- (LFLChatRightMessageViewCell *)rightMessageCell {
    if (_rightMessageCell) {
        _rightMessageCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell"];
    } else {
        _rightMessageCell = [[[LFLTrunkBundle resourceBundle] loadNibNamed:@"LFLChatRightMessageViewCell" owner:self options:nil] firstObject];
    }
    return _rightMessageCell;
}
@end
