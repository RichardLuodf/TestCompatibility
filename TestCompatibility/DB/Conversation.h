//
//  Conversation.h
//  kumu
//
//  Created by crow on 2017/9/6.
//  Copyright © 2017年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ENUM.h"

@class Contact;
@class ChatMessage;

@interface Conversation : NSObject

@property (retain) NSString*        conversationId;//会话id

@property (assign) ConversaionType  type;//会话类型

@property (retain) NSString*        lastUserName;//最后发言人昵称

@property (retain) NSString*        content;//会话内容

@property (assign) int64_t          timeStamp;//存数据库时间戳

@property (assign) int              unReadNum;//消息未读数
@property (retain) NSString*        conversationName;//会话名称
@property (retain) NSString*        avatar;//会话头像

+ (void)initTable;
+ (BOOL)insertItemToDB:(Conversation*)conversation;
- (BOOL)update;

+ (NSArray<Conversation*>*)getObjWith:(NSString*)conversatonId;

+ (NSArray<Conversation*>*)getallObjects;

+(NSInteger)getAllUnReadCount;

- (BOOL)deleteFromDB;

+ (BOOL)deleteObj:(Conversation*)conversation;
@end
