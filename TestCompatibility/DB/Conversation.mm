//
//  Conversation.m
//  kumu
//
//  Created by crow on 2017/9/6.
//  Copyright © 2017年 hw. All rights reserved.
//

#import "Conversation.h"
#import "DBManage.h"
#import "ChatMessage.h"
#import <WCDB/WCDB.h>


#define CONVERSION_TABLE @"Conversation"

@interface Conversation (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(conversationId)
WCDB_PROPERTY(type)
WCDB_PROPERTY(content)
WCDB_PROPERTY(lastUserName)
WCDB_PROPERTY(unReadNum)

WCDB_PROPERTY(isVideo)
WCDB_PROPERTY(timeStamp)
WCDB_PROPERTY(videoUserName)
WCDB_PROPERTY(channelId)
WCDB_PROPERTY(videoType)
WCDB_PROPERTY(replied)

@end

@implementation Conversation

WCDB_IMPLEMENTATION(Conversation)

WCDB_SYNTHESIZE(Conversation, conversationId)
WCDB_SYNTHESIZE(Conversation, type)
WCDB_SYNTHESIZE(Conversation, content)
WCDB_SYNTHESIZE(Conversation, unReadNum)
WCDB_SYNTHESIZE(Conversation, lastUserName)
WCDB_SYNTHESIZE(Conversation, conversationName)
WCDB_SYNTHESIZE(Conversation, avatar)
WCDB_SYNTHESIZE(Conversation, timeStamp)

WCDB_UNIQUE(Conversation, conversationId)

WCDB_PRIMARY(Conversation, conversationId)
//WCDB_INDEX(Conversation, "_index", lastTime)

+ (void)initTable{
    NSString *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"conversionDate"];
    if ((![[DBManage userDB] isTableExists:CONVERSION_TABLE]) || !([lastUpdatedTime isEqualToString:@"1.0"])) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:@"conversionDate"];
         static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([[DBManage userDB] createTableAndIndexesOfName:CONVERSION_TABLE withClass:Conversation.class]){
            }
        });
    }
}
+ (BOOL)insertItemToDB:(Conversation*)conversation{
    [Conversation initTable];
    return [[DBManage userDB] insertOrReplaceObject:conversation into:CONVERSION_TABLE];
}
- (BOOL)update{
    [Conversation initTable];
    return [[DBManage userDB] updateRowsInTable:CONVERSION_TABLE onProperties:Conversation.AllProperties  withObject:self where:Conversation.conversationId == self.conversationId];
}

+ (NSArray<Conversation*>*)getObjWith:(NSString*)conversaionId{
    [Conversation initTable];
    NSArray *allArr = [[DBManage userDB] getObjectsOfClass:Conversation.class fromTable:CONVERSION_TABLE where:Conversation.conversationId == conversaionId];
    return allArr;
}

+ (NSArray<Conversation*>*)getallObjects{
    [Conversation initTable];
    NSMutableArray *allArr = [NSMutableArray arrayWithArray:[[DBManage userDB] getObjectsOfClass:Conversation.class fromTable:CONVERSION_TABLE orderBy:Conversation.timeStamp.order(WCTOrderedDescending)]];
    return allArr;
}


+(NSInteger)getAllUnReadCount{
    NSMutableArray *allArr = [NSMutableArray arrayWithArray:[[DBManage userDB] getObjectsOfClass:Conversation.class fromTable:CONVERSION_TABLE where:Conversation.unReadNum > 0]];
    NSInteger count = 0;
    for (Conversation *conver in allArr) {
        count += conver.unReadNum;
    }
    return count;
}

- (BOOL)deleteFromDB{
    [Conversation initTable];
    return [[DBManage userDB] deleteObjectsFromTable:CONVERSION_TABLE where:Conversation.conversationId == self.conversationId];
}

+ (BOOL)deleteObj:(Conversation*)conversionId{
    [Conversation initTable];
    return [[DBManage userDB] deleteObjectsFromTable:CONVERSION_TABLE where:Conversation.conversationId == conversionId.conversationId];
}

@end



