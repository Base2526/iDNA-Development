//
//  CreateGroupChatThread.h
//  iChat
//
//  Created by Somkid on 2/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CreateGroupChatThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject> delegate;
}
@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);
-(void)start: (NSString*)name :(UIImage *)image :(NSArray *)members;

@end

