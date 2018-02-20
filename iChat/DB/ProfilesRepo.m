//
//  ProfilesRepo.m
//  iDNA
//
//  Created by Somkid on 30/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ProfilesRepo.h"

@implementation ProfilesRepo
-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

-(NSArray *)get{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from profiles;"];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) set:(NSString *)data{
    NSArray *profile = [self get];
    
    if(profile != nil){
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
        //  แสดงว่ามีให้ทำการ udpate
        NSString *query = [NSString stringWithFormat:@"UPDATE profiles set 'data'='%@', 'update'='%@' WHERE id='%d';", data, [timeStampObj stringValue], [[profile objectAtIndex: [self.dbManager.arrColumnNames indexOfObject:@"id"]] integerValue]];
        
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
        Profiles *pf  = [[Profiles alloc] init];
        pf.data     = data;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        pf.create    = [timeStampObj stringValue];
        pf.update    = [timeStampObj stringValue];
        
        [self insert:pf];
    }
    
    return false;
}

- (BOOL) insert:(Profiles *)data{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO profiles ('data', 'create', 'update') VALUES ('%@', '%@', '%@');", data.data, data.create, data.update];
    
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

- (BOOL) delete{
    NSString *query = [NSString stringWithFormat:@"DELETE from profiles"];
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
