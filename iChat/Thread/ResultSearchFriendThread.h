//
//  ResultSearchFriendThread.h
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultSearchFriendThread  : NSObject<NSURLConnectionDataDelegate>{
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

-(void)start: (NSString *)uid: (NSString *)isQR;
-(void)cancel;

@end
