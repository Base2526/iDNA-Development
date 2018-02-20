//
//  CreateGroupChatThread.m
//  iChat
//
//  Created by Somkid on 2/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "CreateGroupChatThread.h"
#import "Configs.h"
@implementation CreateGroupChatThread
-(void)start: (NSString*)name :(UIImage *)image :(NSArray *)members{
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].CREATE_GROUP_CHAT ]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[Configs sharedInstance].timeOut];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    /*
     เราต้อง set Content-Type = application/x-www-form-urlencoded เพราะว่ามีการ update image เพราะว่าส่ง image แบบ json จะช้า
     */
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSMutableString *dataToSend = [NSMutableString string];
    
    [dataToSend appendFormat:@"uid=%@&name=%@&image=%@&", [[Configs sharedInstance] getUIDU], name, imgString];
    
    for (NSString *friend_id in members) {
        [dataToSend appendFormat:@"members[]=%@&", friend_id];
    }
    
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

