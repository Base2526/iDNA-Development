//
//  DeletePostThread.h
//  Heart
//
//  Created by Somkid on 1/18/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeletePostThread  : NSObject<NSURLConnectionDataDelegate>{
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

/*
 is_add = เป็น Status บอกว่าเป้นการเพิ่ม(1) หรือ แก้ไข(0)
 */
// self.nid :self.key_edit :self.edit_item_id
/*
 key    : เป็น key ของ my-app (firebase)
 nid    : node id ของ Pages My Application (Machine name: pages_my_app)
 key_edit : key ของ post ที่เราต้องแก้ไข (firebase)
 edit_item_id  : item id ของ post เพราะเราจะได้ แก้ใขได้ถูก
 */
-(void)start:(NSString *)nid: (NSString*)nid_post;
-(void)cancel;

@end
