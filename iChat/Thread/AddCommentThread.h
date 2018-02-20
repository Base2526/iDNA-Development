//
//  AddPostThread.h
//  Heart
//
//  Created by Somkid on 1/18/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddCommentThread : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject > delegate;
}

@property (nonatomic, copy) void (^completionHandler)(NSData *);
@property (nonatomic, copy) void (^errorHandler)(NSString *);

/*
 is_add = เป็น Status บอกว่าเป้นการเพิ่ม(1) หรือ แก้ไข(0)
 */
// self.nid :self.key_edit :self.edit_item_id
-(void)start:(NSString *)app_id :(UIImage*)post_id: (NSString *)message;
-(void)cancel;
@end//