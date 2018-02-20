//
//  GetProfilesThread.h
//  Heart
//
//  Created by Somkid on 4/8/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetProfilesThread : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject /*, Soap_LottoDateDelegate */> delegate;
    
    // parse xml
    NSXMLParser *parser;
    NSString *currentElement;
    NSMutableString *lottodate;
    // parse xml
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@property (nonatomic, copy) void (^completionHandler)(NSString *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start:(NSArray *)uids;
-(void)cancel;
@end
