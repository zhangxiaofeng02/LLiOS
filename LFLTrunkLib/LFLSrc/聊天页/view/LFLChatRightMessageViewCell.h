//
//  LFLChatRightMessageViewCell.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFLChetBaseViewCell.h"

@interface LFLChatRightMessageViewCell : LFLChetBaseViewCell

- (void)setMessage:(NSString *)message;
- (CGFloat)sizeForText:(NSString *)message;
@end
