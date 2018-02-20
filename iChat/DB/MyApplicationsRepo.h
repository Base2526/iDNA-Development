//
//  MyApplicationsRepo.h
//  iDNA
//
//  Created by Somkid on 19/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "MyApplications.h"

@interface MyApplicationsRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)app_id;
- (NSArray *)get:(NSString *)app_id;
// - (BOOL)insert:(MyApplications *)data;
// - (BOOL)update:(MyApplications *)data;

- (BOOL)update:(NSString* )app_id :(NSString *)data;

- (NSMutableArray *) getMyApplicationAll;

- (BOOL)deleteMyApplication:(NSString *)app_id;

- (BOOL) deleteMyApplicationAll;
@end

