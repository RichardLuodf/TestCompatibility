//
//  ENUM.h
//  kumu
//
//  Created by mac on 2017/10/12.
//  Copyright © 2017年 hw. All rights reserved.
//

#ifndef ENUM_h
#define ENUM_h

//聊天消息类型
typedef NS_ENUM (NSUInteger,MsgType) {
    Event = 0,
    Text = 1,
    Voice = 2,
    Image = 3,
    Location = 6,
    Time = 14,    //本地显示日期
};
//消息方向
typedef NS_ENUM(NSInteger,MsgDir){
    //自己发出
    from = 1,
    //收到
    to = 2
};

//消息状态
typedef NS_ENUM(NSInteger,MessageStatus){
    success = 1,
    faile = 2,
    unread = 3,
    alread = 4,
    sending = 5
};

//会话类型
typedef NS_ENUM(NSInteger,ConversaionType){
    //私聊
    ConversaionPrivate = 0,
    //群组
    ConversaionGroup = 1
};
//联系人类型
typedef NS_ENUM(NSInteger,ContactType){
    //未知
    ContactUnkonw = -1,
    //人
    ContactUser = 1,
    //群组
    ContactGroup = 2,
};

#endif /* ENUM_h */
