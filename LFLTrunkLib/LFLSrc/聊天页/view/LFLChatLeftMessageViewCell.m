//
//  LFLChatLeftMessageViewCell.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatLeftMessageViewCell.h"

@interface LFLChatLeftMessageViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftUserHeadImageView;

@end

@implementation LFLChatLeftMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    UIImage *bubbleImage = [LFLTrunkBundle imageName:@"left_head_icon"];
    bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 15, 5, 5)];
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
