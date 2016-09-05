//
//  LFLChatViewController+UserInput.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController+UserInput.h"
#import "LFLChatViewController+CoreData.h"

@implementation LFLChatViewController (UserInput)

#pragma mark LFLChatUserInputViewDelegate

- (void)sendMessage:(NSString *)message {
    [self saveMessageToCoreData:message];
    if (self.messageTableView.contentSize.height > ScreenHeight - 64 - self.messageTableViewToBottomLength.constant) {
        [self messageTableViewScrollAnimation:YES];
    }
}

#pragma mark - 底部输入栏
- (void)addUserInputView {
    //毛玻璃效果 后期维护
//    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
//    [self.view addSubview:effe];
//    [effe setTranslatesAutoresizingMaskIntoConstraints:NO];
//    NSMutableArray *blurConts = @[].mutableCopy;
//    NSDictionary *blurViews = NSDictionaryOfVariableBindings(self.view,effe);
//    [blurConts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[effe]-0-|"] options:0 metrics:nil views:blurViews]];
//    [blurConts addObject:[NSLayoutConstraint constraintWithItem:effe attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageTableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
//    [blurConts addObject:[NSLayoutConstraint constraintWithItem:effe attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kInPutBarHeight]];
//    [self.view addConstraints:blurConts];
    
    LFLChatUserInputView *inputView = [LFLChatUserInputView defaultView];
    self.userInputView = inputView;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [inputView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *conts = @[].mutableCopy;
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,inputView);
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[inputView]-0-|"] options:0 metrics:nil views:views]];
    [conts addObject:[NSLayoutConstraint constraintWithItem:inputView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageTableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [conts addObject:[NSLayoutConstraint constraintWithItem:inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kInPutBarHeight]];
    [self.view addConstraints:conts];
}

@end
