//
//  LFLChatViewController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController.h"
#import "LFLChatRightMessageViewCell.h"
#import "LFLChatLeftMessageViewCell.h"

@interface LFLChatViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) LFLChatRightMessageViewCell *rightMessageCell;
@property (strong, nonatomic) LFLChatLeftMessageViewCell *leftMessageCell;
@property (strong, nonatomic) NSMutableArray *heightArr;
@end

@implementation LFLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatRightMessageViewCell class] bundle:@"LFLTrunkBundle"];
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatLeftMessageViewCell class] bundle:@"LFLTrunkBundle"];
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
    self.messageTableView.separatorStyle = NO;
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
//    LFLChatRightMessageViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell" forIndexPath:indexPath];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setMessage:self.dataArr[[indexPath row]]];
//    return cell;
    LFLChatLeftMessageViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatLeftMessageViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setMessage:self.dataArr[[indexPath row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = [indexPath row];
//    NSString *message = self.dataArr[row];
//    if (!self.heightArr) {
//        self.heightArr = @[].mutableCopy;
//    }
//    CGFloat height = 0;
//    if (self.heightArr.count > row +1) {
//        height = [self.heightArr[row] floatValue];
//        if (height > 0) {
//            return height + 60;
//        }
//    }
//    height = [self.rightMessageCell sizeForText:message];
//    [self.heightArr addObject:@(height)];
//    return  height + 60;
    NSInteger row = [indexPath row];
    NSString *message = self.dataArr[row];
    if (!self.heightArr) {
        self.heightArr = @[].mutableCopy;
    }
    CGFloat height = 0;
    if (self.heightArr.count > row +1) {
        height = [self.heightArr[row] floatValue];
        if (height > 0) {
            return height + 60;
        }
    }
    height = [self.leftMessageCell sizeForText:message];
    [self.heightArr addObject:@(height)];
    return  height + 60;
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

- (LFLChatLeftMessageViewCell *)leftMessageCell {
    if (_leftMessageCell) {
        _leftMessageCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"LFLChatLeftMessageViewCell"];
    } else {
        _leftMessageCell = [[[LFLTrunkBundle resourceBundle] loadNibNamed:@"LFLChatLeftMessageViewCell" owner:self options:nil] firstObject];
    }
    return _leftMessageCell;
}
@end
