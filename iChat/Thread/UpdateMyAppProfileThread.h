//
//  UpdatePhotoMyAppThread.h
//  Heart
//
//  Created by Somkid on 1/19/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface UpdatePhotoMyAppThread : NSObject
//
//@end

#import <UIKit/UIKit.h>

@interface UpdateMyAppProfileThread  : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject> delegate;
}
@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

-(void)start: (NSString *)item_id: (NSString *)fi: (UIImage *)image;

@end
