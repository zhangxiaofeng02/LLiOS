//
//  LFLChatViewController+CoreData.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController+CoreData.h"
#import "LFLChatMessage.h"
#import "MagicalRecord.h"
#import "LFLFetcher+CoreData.h"
#import "NSManagedObject+MagicalRecord.h"
#import "LFLChatViewController+UserInput.h"

@implementation LFLChatViewController (CoreData)

#pragma mark - CoreData

- (void)saveMessageToCoreData:(NSString *)message {
    NSInteger type = 0;
    if ([message containsString:@"110"]) {
        type = 1;
    }
    NSDictionary *noDic = [self getMessageNoAndGroupKey];
    if (!noDic) {
        return;
    }
    NSDictionary *property = @{@"content":message,
                               @"time":[NSDate new],
                               @"cell_height":@(0),
                               @"type":@(type),
                               @"msgNo":noDic[@"msgNo"],
                               @"groupKey":noDic[@"groupKey"]};
    [LFLFetcher addObject:[self provideClass] withPropertys:property];
}

- (void)saveVoiceMessageToCoreData:(NSString *)voiceUrl timeLong:(NSTimeInterval)length {
    NSInteger type = 3;
    NSDictionary *noDic = [self getMessageNoAndGroupKey];
    if (!noDic) {
        return;
    }
    NSInteger voiceNo = [self getVoiceMessageNo];
    NSDictionary *property = @{@"time":[NSDate new],
                               @"cell_height":@(0),//这里虽然高度固定，但是还是塞了0，为了刷新
                               @"type":@(type),
                               @"msgNo":noDic[@"msgNo"],
                               @"groupKey":noDic[@"groupKey"],
                               @"voiceNo":@(voiceNo),
                               @"voiceUrl":voiceUrl,
                               @"voiceLength":@(length)};
    [LFLFetcher addObject:[self provideClass] withPropertys:property];
}

- (void)updateVoiceMessage:(NSInteger)voiceNo timeLong:(NSTimeInterval)length {
    LFLChatMessage *object = [LFLChatMessage MR_findFirstWithPredicate:nil sortedBy:@"voiceNo" ascending:NO inContext:[[LFLFetcherManager shareInstance].coreDataStack context]];
    NSInteger time = length;
    time == 0 ? time = 1 : time;
    [object setValue:@(time) forKey:@"voiceLength"];
    [LFLFetcher updateObjectPropertyWith:object];
}

- (void)deleteVoiceMessage:(NSInteger)voiceNo {
    LFLChatMessage *object = [LFLChatMessage MR_findFirstWithPredicate:nil sortedBy:@"voiceNo" ascending:NO inContext:[[LFLFetcherManager shareInstance].coreDataStack context]];
    [LFLFetcher deleteObjects:@[object]];
}

- (NSInteger)getVoiceMessageNo {
    LFLChatMessage *object = [LFLChatMessage MR_findFirstWithPredicate:nil sortedBy:@"voiceNo" ascending:NO inContext:[[LFLFetcherManager shareInstance].coreDataStack context]];
    NSInteger voiceNo = -1;
    if (!object) {
        voiceNo = 1;
    } else {
        voiceNo = [object.voiceNo integerValue] + 1;
    }
    return voiceNo;
}

- (NSDictionary *)getMessageNoAndGroupKey {
    LFLChatMessage *object = [LFLChatMessage MR_findFirstWithPredicate:nil sortedBy:@"msgNo" ascending:NO inContext:[[LFLFetcherManager shareInstance].coreDataStack context]];
    NSInteger msgNo = -1;
    NSInteger groupKey = -1;
    if (!object) { //第一次发消息
        msgNo = 0;
        groupKey = 0;
    } else {
        msgNo = [object.msgNo integerValue] + 1;
        NSDate *msgDate = object.time;
        if ([[NSDate new] messageNeedToGroupCompareTime:msgDate]) {
            groupKey = [object.groupKey integerValue] + 1;
        } else {
            groupKey = [object.groupKey integerValue];
        }
    }
    if (msgNo <0 || groupKey <0) {
        debugAssert(0);
        return nil;
    }
    return @{@"msgNo":@(msgNo),@"groupKey":@(groupKey)};
}

- (Class)provideClass {
    return NSClassFromString(@"LFLChatMessage");
}

#pragma mark - NSFetchedResultsDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (controller != self.messageFetcher) {
        return;
    }
    if (LFL_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        if (!self.beginUpdates) {
            self.beginUpdates = YES;
            [self.messageTableView beginUpdates];
        }
    } else {
        [self.messageTableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (controller != self.messageFetcher) {
        return;
    }
    UITableView *tableView = self.messageTableView;
    
    if (LFL_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                if (![indexPath isEqual:newIndexPath]) {
                    [tableView deleteRowsAtIndexPaths:@[indexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                    [tableView insertRowsAtIndexPaths:@[newIndexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                
                break;
                //            case NSFetchedResultsChangeUpdate:
                //                if (DPD_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
                //                    return;
                //                }
                //                [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                //                return;
                //                break;
            default:
                break;
        } }else {
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeMove:
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case NSFetchedResultsChangeUpdate:
                    [self.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                default:
                    break;
            }
        }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (controller != self.messageFetcher) {
        return;
    }
    UITableView *tableView = self.messageTableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationBottom];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (controller != self.messageFetcher) {
        return;
    }
    if (LFL_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        if (self.beginUpdates){
            [self.messageTableView endUpdates];
            self.beginUpdates = NO;
        }
    } else {
        [self.messageTableView endUpdates];
    }
}
@end
