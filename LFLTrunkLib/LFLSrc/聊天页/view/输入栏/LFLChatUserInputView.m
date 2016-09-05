//
//  LFLChatUserInputView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatUserInputView.h"

@interface LFLChatUserInputView() <UITextViewDelegate>
@property (weak, nonatomic, readwrite) IBOutlet LFLChatTextView *userEditTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDividLineHeightCons;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *changeVoiceButton;
@property (weak, nonatomic) IBOutlet UIImageView *changeVoiceImageView;
@property (assign, nonatomic) BOOL voiceInput;
@property (weak, nonatomic) IBOutlet UIButton *inputBarMoreActionButton;

@end

@implementation LFLChatUserInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userEditTextField.delegate = self;
    self.userEditTextField.returnKeyType = UIReturnKeySend;
    
    self.userEditTextField.layer.borderWidth = 1;
    self.userEditTextField.layer.borderColor = Color(213, 213, 213, 1).CGColor;
    self.userEditTextField.layer.cornerRadius = 5.0f;
    self.voiceButton.layer.borderWidth = 1;
    self.voiceButton.layer.borderColor = Color(213, 213, 213, 1).CGColor;
    self.voiceButton.layer.cornerRadius = 5.0f;
    [self.voiceButton setHidden:YES];
    
    [self.userEditTextField setFont:[UIFont systemFontOfSize:15]];
    self.topDividLineHeightCons.constant = 1/ScreenScale;
    self.voiceInput = NO;
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

- (IBAction)changeToVoiceOnClick:(id)sender {
    self.voiceInput = !self.voiceInput;
    if (self.voiceInput) {
        [self.voiceButton setHidden:NO];
        [self.changeVoiceImageView setImage:[LFLTrunkBundle imageName:@"voice_input_btn"]];
        [self.userEditTextField resignFirstResponder];
    } else {
        [self.voiceButton setHidden:YES];
        [self.changeVoiceImageView setImage:[LFLTrunkBundle imageName:@"bottombar_left_btn"]];
        [self.userEditTextField becomeFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)setInputViewNextResponser:(id<NSObject>)responser {
    [self.userEditTextField setInputViewNextResponser:responser];
}

- (IBAction)voiceButtonDragOutSide:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonDragOutSide)]) {
        [self.delegate voiceButtonDragOutSide];
    }
}

- (IBAction)voiceButtonTouchUpOutSide:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonTouchUpOutSide)]) {
        [self.delegate voiceButtonTouchUpOutSide];
    }
}

- (IBAction)voiceButtonTouchUpInSide:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonTouchUpInSide)]) {
        [self.delegate voiceButtonTouchUpInSide];
    }
}

- (IBAction)voiceButtonTouchDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonTouchDown)]) {
        [self.delegate voiceButtonTouchDown];
    }
}

- (IBAction)voiceButtonDragInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceButtonDragInside)]) {
        [self.delegate voiceButtonDragInside];
    }
}

- (IBAction)inputBarMoreActionOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputBarMoreActionOnClick)]) {
        [self.delegate inputBarMoreActionOnClick];
    }
}

@end
