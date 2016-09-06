//
//  LFLFileManager.m
//  LFLToolsLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLFileManager.h"

@implementation LFLFileManager

+ (NSString *)documentPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+ (NSString *)cachePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+ (NSString *)libraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [paths objectAtIndex:0];
    return libraryPath;
}

+ (NSString *)soundFilesPath {
    NSString *path = [[LFLFileManager libraryPath] stringByAppendingPathComponent:@"LFLChatVoice"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
    } else {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        debugAssert(!error);
    }
    return path;
}

+ (BOOL)voicFileExists:(NSString *)voiceName {
    NSString *path = [[LFLFileManager libraryPath] stringByAppendingPathComponent:@"LFLChatVoice"];
    NSString *filePath = [path stringByAppendingPathComponent:voiceName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}
@end
