//
//  LFLChatUserInputView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatUserInputView.h"

@interface LFLChatUserInputView() <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *userEditTextField;

@end

@implementation LFLChatUserInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userEditTextField.delegate = self;
    self.userEditTextField.returnKeyType = UIReturnKeySend;
}

#pragma mark UITextFieldDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *input = self.userEditTextField.text;
    if ([text isEqualToString:@"\n"]){
        if (([input length] == 1 && [input isEqualToString:@"\n"]) || ([input length] == 0)) {
            self.userEditTextField.text = @"";
            return  YES;
        }
        if ([self.delegate respondsToSelector:@selector(sendMessage:)]) {
            [self.delegate sendMessage:input];
            self.userEditTextField.text = @"";
        }
        return NO;
    }
    return YES;
}
@end
