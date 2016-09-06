//
//  LFLChatRightMessageViewCell.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatRightMessageViewCell.h"
#import "TTTAttributedLabel.h"

@interface LFLChatRightMessageViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *rightHeaderImageView;


@end

@implementation LFLChatRightMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageType = LFLChatMessageRightType;
    [self.contentLabel setTextColor:[UIColor blackColor]];
    UIImage *bubbleImage = [LFLTrunkBundle imageName:@"user_chat_bubble"];
    bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10, 10, 20)];
    [self.bubbleImageView setImage:bubbleImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(NSString *)message {
    [super setMessage:message];
}

- (CGFloat)sizeForText:(NSString *)message {
    return [super sizeForText:message];
}

@end
