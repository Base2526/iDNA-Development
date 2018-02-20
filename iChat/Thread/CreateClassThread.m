//
//  CreateClassThread.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "CreateClassThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation CreateClassThread

-(void)start:(NSString*)fction: (NSString*) item_id: (UIImage *)image:(NSString *)name{
    //if there is a connection going on just cancel it.    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].CREATE_CLASS ]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&fction=%@&item_id=%@&image=%@&name=%@", [[Configs sharedInstance] getUIDU], fction, item_id, imgString, name];
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

