//
//  AddFriendThread.h
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFriendThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject /*, Soap_LottoDateDelegate */> delegate;
    
    // parse xml
    NSXMLParser *parser;
    NSString *currentElement;
    NSMutableString *lottodate;
    // parse xml
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start: (NSString *)friend_id;
-(void)cancel;

@end
