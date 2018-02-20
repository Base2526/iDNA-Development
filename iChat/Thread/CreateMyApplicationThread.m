//
//  AddNewMyApplicationThread.m
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "CreateMyApplicationThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation CreateMyApplicationThread
-(void)start: (UIImage*) photo: (NSString *)name : (NSString *)category :(NSString *)subcategory{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].CREATE_MY_APPLICATION ]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (photo != nil) {
        NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    NSMutableString *dataToSend = [NSMutableString string];
    [dataToSend appendFormat:@"uid=%@&name=%@&category=%@&subcategory=%@&image=%@&", [[Configs sharedInstance] getUIDU], name, category, subcategory, imgString];
    
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
