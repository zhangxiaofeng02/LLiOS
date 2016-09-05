//
//  NSDate+LFLExtension.h
//  LFLToolsLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LFLExtension)

- (NSTimeInterval)LFLDateToTimeInerval;
- (BOOL)messageNeedToGroupCompareTime:(NSDate *)compareDate;
+ (NSDateFormatter *)formatMessageGroupDate:(NSDate *)date;
+ (NSDate *)DPDLocalDateFromDate:(NSDate *)date;
@end
