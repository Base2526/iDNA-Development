//
//  AddNewMyApplicationThread.h
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CreateMyApplicationThread : NSObject{
    id <NSObject> delegate;
}
@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);
-(void)start: (UIImage*) photo: (NSString *)name : (NSString *)category :(NSString *)subcategory;
-(void)cancel;
@end
