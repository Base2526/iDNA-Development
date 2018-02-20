//
//  EditPostThread.h
//  iDNA
//
//  Created by Somkid on 21/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface EditPostThread : NSObject
//
//@end

#import <UIKit/UIKit.h>

@interface EditPostThread : NSObject<NSURLConnectionDataDelegate>{
    id <NSObject /*, Soap_LottoDateDelegate */> delegate;
    
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

/*
 is_add = เป็น Status บอกว่าเป้นการเพิ่ม(1) หรือ แก้ไข(0)
 */
// self.nid :self.key_edit :self.edit_item_id
-(void)start:(NSString *)app_id :(NSString *)category_id :(NSString *)post_id :(UIImage*)photo: (NSString *)title :(NSString *)detail;
-(void)cancel;
@end//

