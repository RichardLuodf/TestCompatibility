//
//  DBManage.m
//  DB
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 hw. All rights reserved.
//

#import "DBManage.h"
#import <WCDB/WCDB.h>

static WCTDatabase* userdb;

static WCTDatabase* sharedb;
//WCTStatistics SetGlobalSQLTrace

static NSString* rootPath = (NSString*)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
@interface DBManage ()

@property(nonatomic,copy) NSString* rootPath;

@end

@implementation DBManage

+ (DBManage*)share{
    static DBManage* manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DBManage new];
    });
    return manager;
}

+(WCTDatabase*)shareDB{
    if(!sharedb){
        NSString* filePath = [rootPath stringByAppendingPathComponent:@"share.db"];
        sharedb = [[WCTDatabase alloc] initWithPath:filePath];
    }
    return sharedb;
}

+(void)setShareDB{
    if(!sharedb){
        NSString* filePath = [rootPath stringByAppendingPathComponent:@"share.db"];
        sharedb = [[WCTDatabase alloc] initWithPath:filePath];
    }
}

+ (WCTDatabase*)userDB{
    if(!userdb){
        return sharedb;
    }
    return userdb;
}

+(void)setUserDB:(WCTDatabase*)db{
    userdb = db;
}

+(void)setUserDBWith:(NSString*)idOrName{
    NSString* filePath = [rootPath stringByAppendingPathComponent:idOrName];
    userdb = [[WCTDatabase alloc] initWithPath:[filePath stringByAppendingPathExtension:@"db"]];
    NSString *lastUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDatabase"];
    NSString *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataBaseTime"];
    if (![lastUser isEqualToString:idOrName] || ![lastUpdatedTime isEqualToString:@"11"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:@"DataBaseTime"];
        [[NSUserDefaults standardUserDefaults] setObject:idOrName forKey:@"UserDatabase"];
        [[DBManage userDB] createTableAndIndexesOfName:@"ChatMessage" withClass:ChatMessage.class];
        [[DBManage userDB] createTableAndIndexesOfName:@"Conversation" withClass:Conversation.class];
        
    }
}

+(void)resetUserDB{
    userdb = NULL;
}

+(void)sql{
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"SQL: %@", sql);
    }];
}


@end

