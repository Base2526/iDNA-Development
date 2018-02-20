//
//  AddPostThread.m
//  Heart
//
//  Created by Somkid on 1/18/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AddCommentThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation AddCommentThread

/*
  is_add : เป้นสถานะบอกว่าจะเพิ่ม(1) หรือ แก้ไข(0)
  key    : เป็น key ของ my-app
  nid    : node id ของ Pages My Application (Machine name: pages_my_app)
  key_edit : key ของ post ที่เราต้องแก้ไข
  edit_item_id  : item id ของ post เพราะเราจะได้ แก้ใขได้ถูก
  photo  : รูป
  title  : ชื่อ post
  detail : รายละเอียด
 */
-(void)start:(NSString *)app_id :(UIImage*)post_id: (NSString *)message
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].ADD_COMMENT ]]; // comments
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    /*
    NSString *imgString =@"";
    if (photo != nil) {
        NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    */
    
    NSMutableString *dataToSend = [NSMutableString string];
    [dataToSend appendFormat:@"uid=%@&app_id=%@&post_id=%@&message=%@", [[Configs sharedInstance] getUIDU], app_id, post_id, message];
    
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            self.completionHandler(data);
        }else{
            self.errorHandler([error description]);
        }
    }];
    
    [postDataTask resume];
}

@end
