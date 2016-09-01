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
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *rightMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMessageLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMessageLabelHeight;

@end

@implementation LFLChatRightMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightMessageLabel.font = [UIFont systemFontOfSize:14];
    self.rightMessageLabel.lineSpacing = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(NSString *)message {
    __block CGFloat height = 0;
    __block CGFloat width = 0;
    WeakSelf;
    [self.rightMessageLabel setText:message afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                  withConstraints:CGSizeMake(ScreenWidth-65-60, MAXFLOAT)
                                           limitedToNumberOfLines:0];
        height = size.height;
        width = size.width;
        weakSelf.rightMessageLabelWidth.constant = width;
        weakSelf.rightMessageLabelHeight.constant = height;
         return mutableAttributedString;
    }];
}

- (CGFloat)sizeForText:(NSString *)message {
    [self setMessage:message];
    [self layoutIfNeeded];
    [self updateFocusIfNeeded];
    CGSize size = self.rightMessageLabel.frame.size;
    return size.height;
}
@end
