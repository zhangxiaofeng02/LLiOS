//
//  LFLTools.m
//  LFLToolsLib
//
//  Created by 啸峰 on 16/9/6.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLTools.h"

@implementation LFLTools

+ (NSInteger)voiceCellLength:(NSTimeInterval)timeLength {
    NSInteger time = timeLength / 1;
    if (time <5) {
        return time * 40;
    } else if (time <10) {
        return time * 50;
    } else if (time <20) {
        return time * 55;
    }
    return time * 60;
}
@end
