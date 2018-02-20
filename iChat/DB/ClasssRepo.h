//
//  ClasssRepo.h
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Classs.h"

@interface ClasssRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)item_id;
- (NSArray *)get:(NSString *)item_id;
//- (BOOL)insert:(Classs *)data;
//- (BOOL)update:(Classs *)data;

- (BOOL)update:(NSString* )item_id :(NSString *)data;

- (NSMutableArray *) getClasssAll;
- (BOOL)deleteClasss:(NSString *)item_id;
- (BOOL) deleteClasssAll;
@end

