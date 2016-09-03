//
//  NSFetchedResultsController+LFLExtension.h
//  LFLFetcherLib
//
//  Created by 啸峰 on 16/9/2.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (LFLExtension)

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSArray *)allObjectsInSection:(NSInteger)section;
@end
