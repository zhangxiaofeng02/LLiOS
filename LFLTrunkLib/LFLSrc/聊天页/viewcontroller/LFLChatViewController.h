//
//  LFLChatViewController.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLBaseViewController.h"
#import "LFLChatUserInputView.h"

static CGFloat kInPutBarHeight = 50;

@interface LFLChatViewController : LFLBaseViewController

@property (weak, nonatomic, readonly) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSFetchedResultsController *messageFetcher;
@property (assign, nonatomic) BOOL beginUpdates;
//消息列表约束
@property (weak, nonatomic,readonly) IBOutlet NSLayoutConstraint *messageTableViewToBottomLength;
//输入栏
@property (strong, nonatomic) LFLChatUserInputView *userInputView;

- (void)messageTableViewScrollAnimation:(BOOL)animated;
@end
