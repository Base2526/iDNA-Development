//
//  UpdatePictureGroupThread.m
//  iChat
//
//  Created by Somkid on 8/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "UpdatePictureGroupThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation UpdatePictureGroupThread
-(void)start :(NSString *)group_id : (UIImage *)image
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].UPDATE_PICTURE_GROUP ]];
    
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
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&group_id=%@&image=%@", [[Configs sharedInstance] getUIDU], group_id, imgString];
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

