//
//  NSFetchedResultsController+LFLExtension.m
//  LFLFetcherLib
//
//  Created by 啸峰 on 16/9/2.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "NSFetchedResultsController+LFLExtension.h"

@implementation NSFetchedResultsController (LFLExtension)

- (NSInteger)numberOfSections {
    NSInteger count = 0;
    count = [[self sections] count];
    return count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if ([[self sections] count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSArray *)allObjectsInSection:(NSInteger)section {
    if ([[self sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self sections] objectAtIndex:section];
        return sectionInfo.objects;
    }
    return nil;
}
@end
