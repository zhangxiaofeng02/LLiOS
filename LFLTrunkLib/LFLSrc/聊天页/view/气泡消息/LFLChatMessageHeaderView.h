//
//  LFLChatMessageHeaderView.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HeaderViewOnClick)();

@interface LFLChatMessageHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) HeaderViewOnClick onClick;
- (void)setTitle:(NSString *)title;
@end
