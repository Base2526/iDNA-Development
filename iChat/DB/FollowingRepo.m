//
//  FollowingRepo.m
//  iDNA
//
//  Created by Somkid on 11/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "FollowingRepo.h"

@implementation FollowingRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}
- (BOOL)check:(NSString *)item_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from following where item_id=%@", item_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

-(NSArray *)get:(NSString *)item_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from following where item_id='%@';", item_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) insert:(Following *)data{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO following ('item_id', 'data', 'create', 'update') VALUES ('%@', '%@', '%@', '%@');", data.item_id, data.data, data.create, data.update];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

/*
- (BOOL) update:(Following *)data{
    //  แสดงว่ามีให้ทำการ udpate
    NSString *query = [NSString stringWithFormat:@"UPDATE following set 'data'='%@' WHERE item_id='%@';", data.data, data.item_id];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}
*/

- (BOOL)update:(NSString* )item_id :(NSString *)data{
    NSArray *f = [self get:item_id];
    if(f != nil){
        
        NSString *val = [f objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"data"]];
        if([val isEqualToString:data]){
            NSLog(@"FollowingRepo : update -- xx");
            return true;
        }
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString* update    = [timeStampObj stringValue];
        
        //  แสดงว่ามีให้ทำการ udpate
        NSString *query = [NSString stringWithFormat:@"UPDATE following set 'data'='%@', 'update'='%@' WHERE item_id='%@';", data, update, item_id];
        
        //  Execute the query.
        [self.dbManager executeQuery:query];
        
        //  If the query was succesfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
            return true;
        }else{
            NSLog(@"Could not execute the query");
            return false;
        }
    }else{
        Following *following  = [[Following alloc] init];
        following.item_id  = item_id;
        following.data     = data;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        following.create    = [timeStampObj stringValue];
        following.update    = [timeStampObj stringValue];
        
        BOOL sv = [self insert:following];
        
        return true;
    }
    return false;
}

- (NSMutableArray *) getFollowingAll{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from following;"];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL)deleteFollowing:(NSString *)item_id{
    NSString *query = [NSString stringWithFormat:@"DELETE from following WHERE item_id = %@", item_id];
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

- (BOOL) deleteFollowingAll{
    NSString *query = [NSString stringWithFormat:@"DELETE from following"];
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}
@end

