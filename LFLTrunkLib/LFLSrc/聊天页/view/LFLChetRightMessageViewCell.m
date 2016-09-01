//
//  LFLChetRightMessageViewCell.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChetRightMessageViewCell.h"

@interface LFLChetRightMessageViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *rightHeadIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet YYLabel *textLabel;
@end

@implementation LFLChetRightMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bubbleImage = [LFLTrunkBundle imageName:@"user_chat_bubble"];
    bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10, 10, 20)];
    [self.bubbleImageView setImage:bubbleImage];
    [self.textLabel setText:@"123"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessageText:(NSString *)text {
    
}
@end
