//
//  LFLChatViewController.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLBaseViewController.h"
#import "LFLChatUserInputView.h"
#import "LFLChatVoiceView.h"
#import <AVFoundation/AVFoundation.h>
#import "LFLChetBaseViewCell.h"

static CGFloat kInPutBarHeight = 50;

@interface LFLChatViewController : LFLBaseViewController

@property (weak, nonatomic, readonly) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSFetchedResultsController *messageFetcher;
@property (assign, nonatomic) BOOL beginUpdates;
//消息列表约束
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *messageTableViewToBottomLength;
//输入栏
@property (strong, nonatomic) LFLChatUserInputView *userInputView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) LFLChatVoiceView *voiceView;
//录音
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
//正在录音的文件路径
@property (nonatomic, strong) NSString *currentAudioPath;
//正在录音的文件编号
@property (nonatomic, assign) NSInteger currentAudioNo;
@property (nonatomic, strong) NSTimer *checkAudioTimer;
@property (nonatomic, strong) LFLChetBaseViewCell *currentPlayingCell;

- (void)messageTableViewScrollAnimation:(BOOL)animated;
@end
