//
//  LFLChatUserInputView.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFLChatTextView.h"

@protocol LFLChatUserInputViewDelegate <NSObject>

- (void)sendMessage:(NSString *)message;
- (void)voiceButtonDragOutSide;
- (void)voiceButtonTouchUpOutSide;
- (void)voiceButtonTouchUpInSide;
- (void)voiceButtonTouchDown;
- (void)voiceButtonDragInside;
- (void)inputBarMoreActionOnClick;
@end

@interface LFLChatUserInputView : LFLBaseView

@property (nonatomic, weak) id<LFLChatUserInputViewDelegate> delegate;
@property (weak, nonatomic, readonly) IBOutlet LFLChatTextView *userEditTextField;

- (void)setInputViewNextResponser:(id<NSObject>)responser;
@end
