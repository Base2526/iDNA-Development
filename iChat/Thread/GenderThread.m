//
//  GenderThread.m
//  iDNA
//
//  Created by Somkid on 5/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "GenderThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation GenderThread
-(void)start
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].GET_GENDER]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
        
    NSMutableString *dataToSend = [NSMutableString string];
    
    // [dataToSend appendFormat:@"uid=%@&fction=%@&item_id=%@&email=%@", [[Configs sharedInstance] getUIDU], fction, item_id, email];
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
