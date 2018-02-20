//
//  CreateClassThread.h
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CreateClassThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject> delegate;
    
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

-(void)start:(NSString*)fction: (NSString*) item_id: (UIImage *)image:(NSString *)name;
-(void)cancel;

@end

