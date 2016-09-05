//
//  LFLChatVoiceView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatVoiceView.h"
@interface LFLChatVoiceView()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voiceStateImageView;

@end

@implementation LFLChatVoiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipsLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    self.tipsLabel.layer.borderWidth = 1/ ScreenScale;
    self.tipsLabel.layer.cornerRadius = 3.0f;
    self.tipsLabel.layer.masksToBounds = YES;
    [self.voiceStateImageView setImage:[LFLTrunkBundle imageName:@"voice_speaking_img"]];
}

- (void)showCancleText {
    [self.voiceStateImageView setImage:[LFLTrunkBundle imageName:@"voice_cancle_img"]];
    [self.tipsLabel setBackgroundColor:Color(118, 23, 26, 0.6)];
    [self.tipsLabel setText:@"松开手指，取消发送"];
}

- (void)showNormalText {
    [self.voiceStateImageView setImage:[LFLTrunkBundle imageName:@"voice_speaking_img"]];
    [self.tipsLabel setBackgroundColor:[UIColor clearColor]];
    [self.tipsLabel setText:@"手指上滑，取消发送"];
}
@end
