//
//  FriendsRepo.h
//  iDNA
//
//  Created by Somkid on 30/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Friends.h"

@interface FriendsRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)friend_id;
- (NSArray *)get:(NSString *)friend_id;
// - (BOOL)insert:(Friends *)data;
// - (BOOL)update:(Friends *)data;
- (BOOL)update:(NSString* )friend_id :(NSString *)data;
- (NSMutableArray *) getFriendsAll;
- (BOOL)deleteFriend:(NSString *)friend_id;
- (BOOL) deleteFriendAll;
@end

