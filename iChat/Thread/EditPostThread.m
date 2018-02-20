//
//  EditPostThread.m
//  iDNA
//
//  Created by Somkid on 21/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "EditPostThread.h"

//@implementation EditPostThread
//
//@end

#import "Configs.h"
#import "AppConstant.h"

@implementation EditPostThread

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
-(void)start:(NSString *)app_id :(NSString *)category_id :(NSString *)post_id :(UIImage*)photo: (NSString *)title :(NSString *)detail
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].EDIT_POST ]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (photo != nil) {
        NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSMutableString *dataToSend = [NSMutableString string];//[[NSString alloc] initWithFormat:@"uid=%@&image=%@", [preferences objectForKey:_UID],imgString];
    
    [dataToSend appendFormat:@"uid=%@&app_id=%@&category_id=%@&post_id=%@&title=%@&detail=%@&image=%@", [[Configs sharedInstance] getUIDU], app_id, category_id, post_id, title, detail, imgString];
    
    /*
     // http://stackoverflow.com/questions/13676893/passing-array-to-php-using-post-from-ios
     // NSMutableString *bodyStr = [NSMutableString string];
     for (NSIndexPath *restID in email) {
     // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];
     
     NSLog(@"%d", restID.row);
     [dataToSend appendFormat:@"email[]=%d&", restID.row];
     }
     */
    // http://stackoverflow.com/questions/13676893/passing-array-to-php-using-post-from-ios
    // NSMutableString *bodyStr = [NSMutableString string];
    /*
     for (NSIndexPath *restID in phone) {
     // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];
     
     NSLog(@"%d", restID.row);
     [dataToSend appendFormat:@"phone[]=%d&", restID.row];
     }
     */
    
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
     //initialize a connection from request
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     self.connection = connection;
     // [connection release];
     
     //start the connection
     [connection start];
     */
    
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

