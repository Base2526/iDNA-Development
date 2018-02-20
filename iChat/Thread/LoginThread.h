//
//  LoginThread.h
//  ParseStarterProject
//
//  Created by somkid simajarn on 6/9/2559 BE.
//
//

#import <Foundation/Foundation.h>
@interface LoginThread : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject> delegate;
}
@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start:(NSString *)name:(NSString *)pass;
@end
