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
    NSInteger width = 0;
    switch (time) {
        case 0:
            width = 75;
            break;
        case 1:
            width = 75;
            break;
        case 2:
            width = 80;
            break;
        case 3:
            width = 88;
            break;
        case 4:
            width = 94;
            break;
        case 5:
            width = 106;
            break;
        case 6:
            width = 112;
            break;
        case 7:
            width = 120;
            break;
        case 8:
            width = 128;
            break;
        case 9:
            width = 136;
            break;
        case 10:
            width = 144;
            break;
        default:
            width = 156;
            break;
    }
    return width;
}
@end
