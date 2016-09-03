//
//  LFLFetcherManager.m
//  LFLFetcherLib
//
//  Created by 啸峰 on 16/4/10.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLFetcherManager.h"
#import "LFLFetcher.h"

static LFLFetcherManager *fetcherMgr = nil;
static NSString *kTrunkBundleName = @"LFLTrunkBundle";
@interface LFLFetcherManager()

@property (nonatomic, strong) NSMutableDictionary *fetcherMap;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *coordinator;
@end

@implementation LFLFetcherManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MagicalRecord cleanUp];
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fetcherMgr = [[LFLFetcherManager alloc] init];
    });
    return fetcherMgr;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)initCoreData {
    if (LFL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        //数据版本升级
    }
    [[LFLFetcherManager shareInstance] coreDataStepUp];
}

- (void)coreDataStepUp {
    NSString *bundleName = kTrunkBundleName;
    
    if (!_coreDataStack) {
        SQLiteMagicalRecordStack *stack = nil;
        while (TRUE) {
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"]];
            NSURL *modelURL = [bundle URLForResource:@"Model" withExtension:@"momd"];
            NSManagedObjectModel *model = [NSManagedObjectModel MR_managedObjectModelAtURL:modelURL];
            NSString *storeFileName = [NSString stringWithFormat:@"%@.sqlite",bundleName];
            NSURL *storeFilePath = [NSPersistentStore MR_fileURLForStoreName:storeFileName];
            stack = [SQLiteMagicalRecordStack stackWithStoreAtURL:storeFilePath model:model];
            if (![stack.coordinator persistentStores].count > 0) {
                NSURL *storeFilePath = [stack storeURL];
                [NSPersistentStore MR_removePersistentStoreFilesAtURL:storeFilePath];
                continue;
            }
            debugAssert([stack context]);
            if ([stack context]) {
                break;
            }
        }
        _coreDataStack = stack;
        _context = _coreDataStack.context;
        
        [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelError];
    }
}

- (LFLFetcher *)fetcherWithObject:(id)object {
    NSString *fetcherKey = [NSString stringWithFormat:@"%@_%@",object,NSStringFromClass([object class])];
    debugAssert(fetcherKey.length>0);
    if (!(fetcherKey.length > 0)) {
        return nil;
    }
    if (!_fetcherMap) {
        _fetcherMap = [[NSMutableDictionary alloc] init];
    }
    LFLFetcher *fetcher = _fetcherMap[fetcherKey];
    if (!fetcher) {
        fetcher = [[LFLFetcher alloc] init];
        _fetcherMap[fetcherKey] = fetcher;
    }
    fetcher.fetcherDelegate = object;
    return fetcher;
}

- (void)removeFetcherWithObjects:(id)object {
    NSString *fetcherKey = [NSString stringWithFormat:@"%@_%@",object,NSStringFromClass([object class])];
    [_fetcherMap removeObjectForKey:fetcherKey];
    if (_fetcherMap.count == 0) {
        LFLLog(@"fetcher对象全部清空");
    }
}

- (void)didEnterBackground {
    [[[[self class] shareInstance] context] MR_saveToPersistentStoreAndWait];
}

- (void)didBecomeActiveNotification {
    
}
@end
