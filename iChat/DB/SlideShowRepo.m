//
//  SlideShowRepo.m
//  iDNA
//
//  Created by Somkid on 9/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "SlideShowRepo.h"
@implementation SlideShowRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

- (BOOL)check:(NSString *)friend_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from slide_show where item_id=%@", friend_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

-(NSArray *)get:(NSString *)friend_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from slide_show where item_id='%@';", friend_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

- (BOOL) insert:(SlideShow *)data{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO slide_show ('item_id', 'data', 'create', 'update') VALUES ('%@', '%@', '%@', '%@');", data.item_id, data.data, data.create, data.update];
    
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

- (BOOL)update:(NSString* )item_id :(NSString *)data{
    NSArray *f = [self get:item_id];
    if(f != nil){
        
        NSString *val = [f objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"data"]];
        if([val isEqualToString:data]){
            NSLog(@"SlideShowRepo : update -- xx");
            return true;
        }
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString* update    = [timeStampObj stringValue];
        
        //  แสดงว่ามีให้ทำการ udpate
        NSString *query = [NSString stringWithFormat:@"UPDATE slide_show set 'data'='%@', 'update'='%@' WHERE item_id='%@';", data, update, item_id];
        
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
        SlideShow *slide_show = [[SlideShow alloc] init];
        slide_show.item_id  = item_id;
        slide_show.data       = data;
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        slide_show.create    = [timeStampObj stringValue];
        slide_show.update    = [timeStampObj stringValue];
        
        BOOL sv = [self insert:slide_show];
        
        return true;
    }
    return false;
}

- (NSMutableArray *) getSlideShowAll{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from slide_show;"];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL)deleteSlideShow:(NSString *)item_id{
    NSString *query = [NSString stringWithFormat:@"DELETE from slide_show WHERE item_id = %@", item_id];
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

- (BOOL) deleteSlideShowAll{
    NSString *query = [NSString stringWithFormat:@"DELETE from slide_show"];
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
