//
//  ChatMessage.m
//  kumu
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 hw. All rights reserved.
//

#import "ChatMessage.h"
#import "DBManage.h"
#import <WCDB/WCDB.h>
#define MESSAGE_TABLE @"ChatMessage"

@interface ChatMessage (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(msgId)
WCDB_PROPERTY(chatId)
WCDB_PROPERTY(chatType)
WCDB_PROPERTY(sendUserId)
WCDB_PROPERTY(sendUserNick)
WCDB_PROPERTY(sendUserAvatar)
WCDB_PROPERTY(msgType)
WCDB_PROPERTY(text)
WCDB_PROPERTY(extra)
WCDB_PROPERTY(time)//保护测试版本
WCDB_PROPERTY(fileUrl)
WCDB_PROPERTY(direction)
//WCDB_PROPERTY(status)
WCDB_PROPERTY(messageStatus)
WCDB_PROPERTY(location)
WCDB_PROPERTY(locolUrl)
WCDB_PROPERTY(timeStamp)
WCDB_PROPERTY(tag_users)
WCDB_PROPERTY(mentions)
WCDB_PROPERTY(reply)

@end

@implementation ChatMessage

WCDB_IMPLEMENTATION(ChatMessage)

WCDB_SYNTHESIZE(ChatMessage, msgId)
WCDB_SYNTHESIZE(ChatMessage, chatId)
WCDB_SYNTHESIZE_DEFAULT(ChatMessage, chatType,0)
WCDB_SYNTHESIZE(ChatMessage, sendUserId)
WCDB_SYNTHESIZE(ChatMessage, sendUserNick)
WCDB_SYNTHESIZE(ChatMessage, sendUserAvatar)
WCDB_SYNTHESIZE(ChatMessage, locolUrl)
WCDB_SYNTHESIZE(ChatMessage, timeStamp)
WCDB_SYNTHESIZE_DEFAULT(ChatMessage, msgType,1)
WCDB_SYNTHESIZE_DEFAULT(ChatMessage, text,@"")
WCDB_SYNTHESIZE(ChatMessage, extra)
WCDB_SYNTHESIZE(ChatMessage, fileUrl)
WCDB_SYNTHESIZE(ChatMessage, direction)
WCDB_SYNTHESIZE_DEFAULT(ChatMessage, messageStatus, 1)
//WCDB_SYNTHESIZE_DEFAULT(ChatMessage, status,1)
WCDB_SYNTHESIZE(ChatMessage, location)

WCDB_UNIQUE(ChatMessage, msgId)
WCDB_NOT_NULL(ChatMessage, msgId)
WCDB_PRIMARY(ChatMessage, msgId)

+(void)initTable{
    NSString *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"CahtMessageDate"];
    if ((![[DBManage userDB] isTableExists:MESSAGE_TABLE]) || !([lastUpdatedTime isEqualToString:@"1.0"])) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:@"CahtMessageDate"];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[DBManage userDB] createTableAndIndexesOfName:MESSAGE_TABLE withClass:ChatMessage.class];
        });
    }
}

+ (BOOL)insertToDB:(ChatMessage*)message{
    [ChatMessage initTable];
    return [[DBManage userDB] insertObject:message into:MESSAGE_TABLE];
}
+ (BOOL)insertMessagesToDB:(NSArray<ChatMessage*>*)messages{
    if (messages.count == 0) {
        return YES;
    }
    return [[DBManage userDB] insertOrReplaceObjects:messages into:MESSAGE_TABLE];
}
- (BOOL)update{
    [ChatMessage initTable];
    return [[DBManage userDB] updateRowsInTable:MESSAGE_TABLE onProperties:ChatMessage.AllProperties withObject:self where:ChatMessage.msgId == self.msgId];
}

- (BOOL)updateMsgId:(NSString *)msgId{
    [ChatMessage initTable];
    NSString *timeStr = [NSString stringWithFormat:@"%lld",self.timeStamp];
    if (timeStr.length == 10) {
        self.timeStamp = self.timeStamp*1000;
    }
    NSString *clientId = self.msgId;
    self.msgId = msgId;
    return [[DBManage userDB] updateRowsInTable:MESSAGE_TABLE onProperties:ChatMessage.AllProperties withObject:self where:ChatMessage.msgId == clientId];
}

+ (NSArray<ChatMessage*>*)getOneObjWithId:(NSString *)msgId{
    [ChatMessage initTable];
    return [[DBManage userDB] getObjectsOfClass:ChatMessage.class fromTable:MESSAGE_TABLE where:ChatMessage.msgId == msgId];
}

+(NSArray<ChatMessage *> *)getObjesWith:(NSString *)conversationId offset:(int)offset limit:(int)limit{
    [ChatMessage initTable];
    NSArray *array = [[DBManage userDB] getObjectsOfClass:ChatMessage.class fromTable:MESSAGE_TABLE where:ChatMessage.chatId == conversationId orderBy:ChatMessage.timeStamp.order(WCTOrderedDescending) limit:limit offset:offset];
    return [[array reverseObjectEnumerator] allObjects];
}

+ (NSArray<ChatMessage*>*)getObjects{
    [ChatMessage initTable];
    return [[DBManage userDB] getObjectsOfClass:ChatMessage.class fromTable:MESSAGE_TABLE orderBy:ChatMessage.timeStamp.order() limit:30];
}

+ (NSArray<ChatMessage *> *)getHistroyMessagesWith:(ChatMessage *)message{
    [ChatMessage initTable];
    NSArray *chatmessages = [[DBManage userDB] getObjectsOfClass:ChatMessage.class fromTable:MESSAGE_TABLE where:((ChatMessage.chatId == message.chatId
                                                                                                                ) && (ChatMessage.timeStamp >= (message.timeStamp))) orderBy:ChatMessage.timeStamp.order()];
    return chatmessages;
}

- (BOOL)deleteFromDB{
    [ChatMessage initTable];
    return [[DBManage userDB] deleteObjectsFromTable:MESSAGE_TABLE where:ChatMessage.msgId == self.msgId];
}

+ (BOOL)deleteObj:(ChatMessage*)message{
    [ChatMessage initTable];
    return [[DBManage userDB] deleteObjectsFromTable:MESSAGE_TABLE where:ChatMessage.msgId == message.msgId];
}

+(BOOL)deleteSessionMessage:(NSString *)converId{
    [ChatMessage initTable];
    return [[DBManage userDB] deleteObjectsFromTable:MESSAGE_TABLE where:ChatMessage.chatId == converId];
}
- (NSString *)descOnConversationList {
    NSString *desc = @"";
    if (self.msgType == Text) {
        desc = self.text;
    } else if (self.msgType == Image) {
        desc = @"[图片]";
    } else if (self.msgType == Voice) {
        desc = @"[语音]";
    }
    return desc;
}

@end

