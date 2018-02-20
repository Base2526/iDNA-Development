//
//  ProfilesRepo.h
//  iDNA
//
//  Created by Somkid on 30/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Profiles.h"

@interface ProfilesRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (NSArray *)get;
// - (BOOL)insert:(Profiles *)data;
- (BOOL)set:(NSString *)data;

// - (BOOL)update:(int)profile_id:(NSString *)data;

- (BOOL)delete;
@end

