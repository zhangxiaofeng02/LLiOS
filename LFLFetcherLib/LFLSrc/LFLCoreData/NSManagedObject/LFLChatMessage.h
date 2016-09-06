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
    LFLChatVoiceMessageLeftType,
    LFLChatVoiceMessageRightType
};

@interface LFLChatMessage : NSManagedObject

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSNumber *cell_height;
@property (nonatomic, retain) NSNumber *msgNo;
@property (nonatomic, retain) NSNumber *groupKey;
@property (nonatomic, retain) NSNumber *voiceNo;
@property (nonatomic, retain) NSString *voiceUrl;
@property (nonatomic, retain) NSNumber *voiceLength;
@end

