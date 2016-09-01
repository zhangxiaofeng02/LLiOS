//
//  LFLChetBaseViewCell.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChetBaseViewCell.h"

@interface LFLChetBaseViewCell()

@property (weak, nonatomic, readwrite) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic, readwrite) IBOutlet NSLayoutConstraint *contentLabelWidth;
@property (weak, nonatomic, readwrite) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic, readwrite) IBOutlet UIImageView *bubbleImageView;
@end

@implementation LFLChetBaseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.lineSpacing = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)sizeForText:(NSString *)message {
    [self setMessage:message];
    [self layoutIfNeeded];
    [self updateFocusIfNeeded];
    CGSize size = self.contentLabel.frame.size;
    return size.height;
}

- (void)setMessage:(NSString *)message {
    __block CGFloat height = 0;
    __block CGFloat width = 0;
    WeakSelf;
    [self.contentLabel setText:message afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                       withConstraints:CGSizeMake(ScreenWidth-65-60, MAXFLOAT)
                                                limitedToNumberOfLines:0];
        height = size.height;
        width = size.width;
        weakSelf.contentLabelWidth.constant = width;
        weakSelf.contentLabelHeight.constant = height;
        return mutableAttributedString;
    }];
}

@end
