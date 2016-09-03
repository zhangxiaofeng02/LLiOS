//
//  LFLChatMessage.h
//  
//
//  Created by 啸峰 on 16/9/2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger,LFLChatMessageType) {
    LFLChatMessageLeftType,
    LFLChatMessageRightType,
};

@interface LFLChatMessage : NSManagedObject

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *cell_height;

@end

