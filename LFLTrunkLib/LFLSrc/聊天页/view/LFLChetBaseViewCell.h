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
@end

@interface LFLChetBaseViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelWidth;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *bubbleImageView;

@property (weak, nonatomic) id<LFLChetBaseViewCellDelegate> delegate;

- (void)setMessage:(NSString *)message;

- (CGFloat)sizeForText:(NSString *)message;

- (void)showMenuView:(UIView *)parentView;
@end
