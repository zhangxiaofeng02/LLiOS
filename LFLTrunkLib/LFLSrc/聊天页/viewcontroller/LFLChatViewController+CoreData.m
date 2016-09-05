//
//  LFLChatViewController+CoreData.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController+CoreData.h"

@implementation LFLChatViewController (CoreData)

#pragma mark - CoreData

- (void)saveMessageToCoreData:(NSString *)message {
    Class entityClass = [self provideClass];
    NSInteger type = 0;
    if ([message containsString:@"110"]) {
        type = 1;
    }
    [LFLFetcher addObject:entityClass withPropertys:@{@"content":message,
                                                      @"time":[NSDate new],
                                                      @"cell_height":@(0),
                                                      @"type":@(type)}];
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
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
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
                    [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
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
                     withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationBottom];
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
