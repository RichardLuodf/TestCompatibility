//
//  ChatMessage.h
//  kumu
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ENUM.h"


@interface ChatMessage : NSObject

@property (retain) NSString*        msgId;//聊天id

@property (retain) NSString*        chatId;//会话id

@property (assign) ConversaionType  chatType; //会话类型

@property (retain) NSString*        sendUserId;//发送者id

@property (retain) NSString*        sendUserNick;//发送者昵称

@property (retain) NSString*        sendUserAvatar;//发送者头像

@property (assign) MsgType          msgType;

@property (retain) NSString*        text;//信息文本

@property (retain) NSString*        fileUrl;//资源远程地址

@property (retain) NSString*        locolUrl;//本地数据

@property (retain) NSString*        extra;//附加信息

@property (assign) int64_t          timeStamp;//存数据库时间戳

@property (assign) MsgDir           direction;//接收或者发送

//@property (assign) int8_t           msgStatus;//5发送中1发送成功2发送失败3未读4已读

@property (assign) MessageStatus    messageStatus;

@property (retain) NSDictionary*    location;//位置信息

//以下字段并未入库，临时使用
@property (retain) NSString*        groupNickname;//资源远程地址

@property (retain) NSString*        groupAvatar;//本地数据

////发送使用
//- (instancetype)initWithSendMessage:(IMMessage*)imMsg;
////接收使用
//+ (instancetype)initWithRecivedMessage:(IMMessage*)imMsg;

+ (void)initTable;

+ (BOOL)insertToDB:(ChatMessage*)message;
+ (BOOL)insertMessagesToDB:(NSArray<ChatMessage*>*)messages;

- (BOOL)update;
//更新消息ID，在发送消息成功获取到服务端的消息ID后更新之前设置的客户端消息ID
- (BOOL)updateMsgId:(NSString *)msgId;

+ (NSArray<ChatMessage*>*)getOneObjWithId:(NSString*)msgId;

+ (NSArray<ChatMessage*>*)getObjesWith:(NSString *)conversationId offset:(int)offset limit:(int)limit;

+ (NSArray<ChatMessage*>*)getHistroyMessagesWith:(ChatMessage *)message;

- (BOOL)deleteFromDB;
+ (BOOL)deleteObj:(ChatMessage*)message;
+ (BOOL)deleteSessionMessage:(NSString *)converId;
//- (void)configMessage:(IMMessage*)imMsg;
- (NSString *)descOnConversationList;
@end
