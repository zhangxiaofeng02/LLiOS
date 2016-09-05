//
//  LFLChatViewController+CoreData.h
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController.h"

@interface LFLChatViewController (CoreData)

- (Class)provideClass;

- (void)saveMessageToCoreData:(NSString *)message;
@end
