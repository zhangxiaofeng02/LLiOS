//
//  LFLChatRightVoiceMessageViewCell.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/6.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatRightVoiceMessageViewCell.h"

@interface LFLChatRightVoiceMessageViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLengthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceCellWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *voicePlayStateImageView;

@end

@implementation LFLChatRightVoiceMessageViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.voiceCellWidthCons.constant = 75.0f;
    [self.voicePlayStateImageView setHidden:YES];
    self.playing = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageType = LFLChatVoiceMessageRightType;
    UIImage *bubbleImage = [LFLTrunkBundle imageName:@"user_chat_bubble"];
    bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10, 10, 20)];
    [self.bubbleImageView setImage:bubbleImage];
    self.playing = NO;
    self.voicePlayStateImageView.animationImages = @[[LFLTrunkBundle imageName:@"voice_state_3.png"],[LFLTrunkBundle imageName:@"voice_state_2.png"],[LFLTrunkBundle imageName:@"voice_state_1.png"]];
    [self.voicePlayStateImageView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)voiceButtonOnClick:(id)sender {    
    [super voiceButtonOnClick:sender];
}

- (void)setVoiceCellWidth:(NSInteger)width animation:(Boolean)animation {
    if (width == 0) {
        [self.timeLengthLabel setText:@""];
        [self.voicePlayStateImageView setHidden:YES];
    } else {
        [self.voicePlayStateImageView setHidden:NO];
        self.voiceCellWidthCons.constant = [LFLTools voiceCellLength:width];
        [self.timeLengthLabel setText:[NSString stringWithFormat:@"%@''",@(width)]];
    }
}

- (void)stopPlaying {
    [self.voicePlayStateImageView stopAnimating];
    self.playing = NO;
}

- (void)startVoiceAnimation {
    if (self.playing) {
        [self.voicePlayStateImageView stopAnimating];
    } else {
        self.voicePlayStateImageView.animationDuration = 1.5;
        [self.voicePlayStateImageView startAnimating];
    }
    self.playing = !self.playing;
}
@end
