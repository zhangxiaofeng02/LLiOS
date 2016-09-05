//
//  LFLChatViewController+UserInput.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//
#import "LFLChatViewController.h"
#import "LFLChatViewController+UserInput.h"
#import "LFLChatViewController+CoreData.h"
#import "LFLChatVoiceView.h"
#define kRecordAudioFile @"myRecord.caf"

@implementation LFLChatViewController (UserInput)

#pragma mark LFLChatUserInputViewDelegate

- (void)sendMessage:(NSString *)message {
    [self saveMessageToCoreData:message];
    if (self.messageTableView.contentSize.height > ScreenHeight - 64 - self.messageTableViewToBottomLength.constant) {
        [self messageTableViewScrollAnimation:YES];
    }
}

- (void)voiceButtonDragOutSide {
    [self.voiceView showCancleText];
    [self pauseRecordVoice];
}

- (void)voiceButtonTouchUpOutSide {
    [self.voiceView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self stopRecordVoice];
}

- (void)voiceButtonTouchUpInSide {
    [self.voiceView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self stopRecordVoice];
}

- (void)voiceButtonTouchDown {
    [self addVoiceAnimationView];
    [self startRecordVoice];
}

- (void)voiceButtonDragInside {
    [self.voiceView showNormalText];
    [self recorverRecordVoice];
}

- (void)inputBarMoreActionOnClick {
    [self playRadio];
}

#pragma mark - 底部输入栏

- (void)addUserInputView {
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

- (void)addVoiceAnimationView {
    UIView *maskView = [[UIView alloc] init];
    self.maskView = maskView;
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [maskView setBackgroundColor:[UIColor clearColor]];
    [window addSubview:maskView];
    [maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *conts = @[].mutableCopy;
    NSDictionary *views = NSDictionaryOfVariableBindings(window,maskView);
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[maskView]-0-|"]
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[maskView]-0-|"]
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [window addConstraints:conts];
    
    LFLChatVoiceView *voiceView = [LFLChatVoiceView defaultView];
    self.voiceView = voiceView;
    [window addSubview:voiceView];
    [voiceView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *voiceConts = @[].mutableCopy;
    [voiceConts addObject:[NSLayoutConstraint constraintWithItem:voiceView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [voiceConts addObject:[NSLayoutConstraint constraintWithItem:voiceView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:5.0]];
    
    [voiceConts addObject:[NSLayoutConstraint constraintWithItem:voiceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0]];
    [voiceConts addObject:[NSLayoutConstraint constraintWithItem:voiceView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0]];
    
    [window addConstraints:voiceConts];
}

#pragma mark 录音具体操作

- (void)setAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)startRecordVoice {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
    }
}

- (void)pauseRecordVoice {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
    }
}

- (void)recorverRecordVoice {
    
}

- (void)stopRecordVoice {
    [self.audioRecorder stop];
}

- (void)playRadio {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

- (NSURL *)getSavePath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

@end
