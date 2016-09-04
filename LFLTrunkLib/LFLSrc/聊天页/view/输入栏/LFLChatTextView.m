//
//  LFLChatTextView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/4.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatTextView.h"

@interface LFLChatTextView()

@property (weak, nonatomic) id<NSObject> inputViewNextResponser;

@end

@implementation LFLChatTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editViewLongPress:)];
    [self addGestureRecognizer:longPressGesture];
}

- (UIResponder *)nextResponder {
    if (_inputViewNextResponser) {
        return _inputViewNextResponser;
    } else {
        return [super nextResponder];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_inputViewNextResponser) {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)editViewLongPress:(id)sender {
    LFLLog(@"123");
}

@end
