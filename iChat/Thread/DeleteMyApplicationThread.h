//
//  DeleteMyApplicationThread.h
//  Heart
//
//  Created by Somkid on 1/19/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeleteMyApplicationThread : NSObject<NSURLConnectionDataDelegate>{
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

-(void)start: (NSString *)item_id;
-(void)cancel;
@end//
