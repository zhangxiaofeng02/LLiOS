//
//  ThreadedSQLiteMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "SQLiteWithSavingContextMagicalRecordStack.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@interface SQLiteWithSavingContextMagicalRecordStack ()

@property (nonatomic, strong, readwrite) MMSManagedObjectContext *savingContext;

@end


@implementation SQLiteWithSavingContextMagicalRecordStack

@synthesize context = _context;

- (void)dealloc;
{
    [_context MR_stopObservingContextDidSave:_savingContext];
}

- (NSManagedObjectContext *) context;
{
    if (_savingContext == nil)
    {
        _savingContext = (MMSManagedObjectContext *)[MMSManagedObjectContext MR_privateQueueContext];
        [_savingContext setPersistentStoreCoordinator:[self coordinator]];
    }

    if (_context == nil)
    {
        _context = [MMSManagedObjectContext MR_mainQueueContext];
        [_context setPersistentStoreCoordinator:[self coordinator]];

        [_context MR_observeContextDidSave:_savingContext];
    }

    return _context;
}

- (NSManagedObjectContext *) newConfinementContext;
{
    NSManagedObjectContext *context = [super createConfinementContext];
    [context setParentContext:[self savingContext]];
    return context;
}

@end
