//
//  LFLChatUserInputView.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LFLChatUserInputViewDelegate <NSObject>

- (void)sendMessage:(NSString *)message;
@end

@interface LFLChatUserInputView : LFLBaseView

@property (nonatomic, weak) id<LFLChatUserInputViewDelegate> delegate;
@property (weak, nonatomic, readonly) IBOutlet UITextView *userEditTextField;
@end
