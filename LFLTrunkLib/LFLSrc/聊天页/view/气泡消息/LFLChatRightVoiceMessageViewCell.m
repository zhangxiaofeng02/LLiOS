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

@end

@implementation LFLChatRightVoiceMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageType = LFLChatVoiceMessageRightType;
    UIImage *bubbleImage = [LFLTrunkBundle imageName:@"user_chat_bubble"];
    bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10, 10, 20)];
    [self.bubbleImageView setImage:bubbleImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)voiceButtonOnClick:(id)sender {
    [super voiceButtonOnClick:sender];
}

- (void)setVoiceCellWidth:(NSInteger)width {
    if (width <5) {
        self.voiceCellWidthCons.constant = width * 40;
    } else if (width <10) {
        self.voiceCellWidthCons.constant = width * 50;
    } else if (width <20) {
        self.voiceCellWidthCons.constant = width * 55;
    }
    [self.timeLengthLabel setText:[NSString stringWithFormat:@"%@''",@(width)]];
}
@end
