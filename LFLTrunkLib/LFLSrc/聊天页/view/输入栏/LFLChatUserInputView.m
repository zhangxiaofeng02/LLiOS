//
//  LFLChatUserInputView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatUserInputView.h"

@interface LFLChatUserInputView() <UITextViewDelegate>
@property (weak, nonatomic, readwrite) IBOutlet UITextView *userEditTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDividLineHeightCons;

@end

@implementation LFLChatUserInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userEditTextField.delegate = self;
    self.userEditTextField.returnKeyType = UIReturnKeySend;
    self.userEditTextField.layer.borderWidth = 2;
    self.userEditTextField.layer.borderColor = Color(213, 213, 213, 1).CGColor;
    self.userEditTextField.layer.cornerRadius = 5.0f;
    [self.userEditTextField setFont:[UIFont systemFontOfSize:15]];
    self.topDividLineHeightCons.constant = 1/ScreenScale;
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
- (void)textViewDidChange:(UITextView *)textView {
    
}
@end
