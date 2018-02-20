//
//  FriendProfileRepo.h
//  iDNA
//
//  Created by Somkid on 13/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "FriendProfile.h"

@interface FriendProfileRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)friend_id;
- (NSArray *)get:(NSString *)friend_id;
//- (BOOL)insert:(FriendProfile *)data;
//- (BOOL)update:(FriendProfile *)data;
- (BOOL)update:(NSString* )friend_id :(NSString *)data;

- (BOOL)deleteFriendProfileById:(NSString *)friend_id;
/*

 */
- (NSMutableArray *) getFriendProfileAll;

- (BOOL) deleteFriendProfileAll;
@end
