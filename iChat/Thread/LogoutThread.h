//
//  LogoutThread.h
//  iDNA
//
//  Created by Somkid on 18/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LogoutThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject> delegate;
}
@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start;
@end

