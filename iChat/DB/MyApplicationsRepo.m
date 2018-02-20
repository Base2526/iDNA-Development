//
//  MyApplicationsRepo.m
//  iDNA
//
//  Created by Somkid on 19/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "MyApplicationsRepo.h"

@implementation MyApplicationsRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

/*
 - (BOOL)check:(NSString *)app_id;
 - (NSArray *)get:(NSString *)app_id;
 - (BOOL)insert:(MyApplications *)data;
 - (BOOL)update:(MyApplications *)data;
 
 - (NSMutableArray *) getGroupChatAll;
 
 - (BOOL)deleteMyApplication:(NSString *)app_id;
 
 - (BOOL) deleteMyApplicationAll;
 */

- (BOOL)check:(NSString *)app_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from my_applications where app_id=%@", app_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

-(NSArray *)get:(NSString *)app_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from my_applications where app_id='%@';", app_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) insert:(MyApplications *)data{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO my_applications ('app_id', 'data', 'create', 'update') VALUES ('%@', '%@', '%@', '%@');", data.app_id, data.data, data.create, data.update];
    
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

//- (BOOL) update:(MyApplications *)data{
//    //  แสดงว่ามีให้ทำการ udpate
//    NSString *query = [NSString stringWithFormat:@"UPDATE my_applications set 'data'='%@' WHERE app_id='%@';", data.data, data.app_id];
//
//    //  Execute the query.
//    [self.dbManager executeQuery:query];
//
//    //  If the query was succesfully executed then pop the view controller.
//    if (self.dbManager.affectedRows != 0) {
//        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
//        return true;
//    }else{
//        NSLog(@"Could not execute the query");
//        return false;
//    }
//}

- (BOOL)update:(NSString* )app_id :(NSString *)data{
    NSArray *f = [self get:app_id];
    if(f != nil){
        
        NSString *val = [f objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"data"]];
        if([val isEqualToString:data]){
            NSLog(@"MyApplicationsRepo : update -- xx");
            return true;
        }
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString* update    = [timeStampObj stringValue];
        
        //  แสดงว่ามีให้ทำการ udpate
        NSString *query = [NSString stringWithFormat:@"UPDATE my_applications set 'data'='%@', 'update'='%@' WHERE app_id='%@';", data, update, app_id];
        
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
        MyApplications *myApplications  = [[MyApplications alloc] init];
        myApplications.app_id  = app_id;
        myApplications.data     = data;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        myApplications.create    = [timeStampObj stringValue];
        myApplications.update    = [timeStampObj stringValue];
        
        BOOL sv = [self insert:myApplications];
    }
    return false;
}

- (NSMutableArray *) getMyApplicationAll{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from my_applications;"];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL)deleteMyApplication:(NSString *)app_id{
    NSString *query = [NSString stringWithFormat:@"DELETE from my_applications WHERE app_id = %@", app_id];
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

- (BOOL) deleteMyApplicationAll{
    NSString *query = [NSString stringWithFormat:@"DELETE from my_applications"];
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
