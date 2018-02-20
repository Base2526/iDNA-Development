//
//  GroupChatRepo.h
//  iDNA
//
//  Created by Somkid on 16/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "GroupChat.h"

@interface GroupChatRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)group_id;
- (NSArray *)get:(NSString *)group_id;
// - (BOOL)insert:(GroupChat *)data;
// - (BOOL)update:(GroupChat *)data;

- (BOOL)update:(NSString* )group_id :(NSString *)data;

- (NSMutableArray *) getGroupChatAll;

- (BOOL)deleteGroup:(NSString *)group_id;

- (BOOL) deleteGroupAll;
@end
