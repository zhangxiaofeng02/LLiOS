//
//  LFLChetBaseViewCell.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFLChetBaseViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelWidth;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *bubbleImageView;

- (void)setMessage:(NSString *)message;
- (CGFloat)sizeForText:(NSString *)message;
@end
