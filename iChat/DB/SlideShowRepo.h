//
//  SlideShowRepo.h
//  iDNA
//
//  Created by Somkid on 9/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "SlideShow.h"

@interface SlideShowRepo : NSObject{
}

@property (nonatomic, strong) DBManager *dbManager;
- (BOOL)check:(NSString *)item_id;
- (NSArray *)get:(NSString *)item_id;
- (BOOL)update:(NSString* )item_id :(NSString *)data;
- (NSMutableArray *) getSlideShowAll;
- (BOOL)deleteSlideShow:(NSString *)item_id;
- (BOOL)deleteSlideShowAll;
@end
