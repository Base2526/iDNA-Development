//
//  ForgotPasswordThread.h
//  Heart
//
//  Created by Somkid on 12/17/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForgotPasswordThread : NSObject<NSURLConnectionDataDelegate>{
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

-(void)start:(NSString *)email;
-(void)cancel;

@end
