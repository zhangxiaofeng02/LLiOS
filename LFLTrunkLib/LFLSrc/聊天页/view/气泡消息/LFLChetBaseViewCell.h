//
//  LFLChetBaseViewCell.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFLChetBaseViewCell;

@protocol LFLChetBaseViewCellDelegate <NSObject>

- (void)cellLongPress:(LFLChetBaseViewCell *)cell recognizer:(UIGestureRecognizer *)recognizer;
- (void)deleteMessage:(LFLChetBaseViewCell *)cell;
- (void)cellTapAction:(LFLChetBaseViewCell *)cell;
@end

@interface LFLChetBaseViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelWidth;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic, readonly) IBOutlet UIButton *voicePlayButton;
@property (assign, nonatomic) LFLChatMessageType *messageType;
@property (assign, nonatomic) BOOL playing;
@property (weak, nonatomic) id<LFLChetBaseViewCellDelegate> delegate;

- (void)setMessage:(NSString *)message;

- (CGFloat)sizeForText:(NSString *)message;

- (void)showMenuView:(UIView *)parentView;

- (IBAction)voiceButtonOnClick:(id)sender;

- (void)setVoiceCellWidth:(NSInteger)width animation:(Boolean)animation;

- (void)stopPlaying;

- (void)startVoiceAnimation;
@end
