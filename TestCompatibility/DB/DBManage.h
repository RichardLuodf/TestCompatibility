//
//  DBManage.h
//  DB
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"
#import "Conversation.h"
@class WCTDatabase;

@interface DBManage : NSObject

+ (DBManage*)share;

+ (WCTDatabase*)shareDB;

+ (void)setShareDB;

+ (WCTDatabase*)userDB;

+ (void)setUserDB:(WCTDatabase*)db;

+ (void)setUserDBWith:(NSString*)idOrName;

+ (void)resetUserDB;

+ (void)sql;



@end
