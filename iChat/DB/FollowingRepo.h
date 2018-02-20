//
//  FollowingRepo.h
//  iDNA
//
//  Created by Somkid on 11/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Following.h"

@interface FollowingRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)item_id;
- (NSArray *)get:(NSString *)item_id;
// - (BOOL)insert:(Following *)data;
// - (BOOL)update:(Following *)data;

- (BOOL)update:(NSString* )item_id :(NSString *)data;

- (NSMutableArray *) getFollowingAll;
- (BOOL)deleteFollowing:(NSString *)item_id;
- (BOOL) deleteFollowingAll;
@end

