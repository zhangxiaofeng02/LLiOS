//
//  LFLFetcherManager.h
//  LFLFetcherLib
//
//  Created by 啸峰 on 16/4/10.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFLFetcher.h"
#import "SQLiteMagicalRecordStack.h"

@interface LFLFetcherManager : NSObject

@property (nonatomic, strong, readonly) SQLiteMagicalRecordStack *coreDataStack;
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

+ (instancetype)shareInstance;

/**
 * Fetch核心方法，任何想要发起网络请求，数据库操作的对象都需要通过此方法获取fetcher实例,并且传入自己，用于设置delegate.
 **/
- (LFLFetcher *)fetcherWithObject:(id)object;

/**
 * 去除某个请求
 **/
- (void)removeFetcherWithObjects:(id)object;

/**
 * 初始化数据库操作
 **/
- (void)initCoreData;
@end
