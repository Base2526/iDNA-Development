//
//  EditEmailThread.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "EditEmailThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation EditEmailThread

-(void)start:(NSString *) fction: (NSString *)item_id : (NSString *)email
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].EDIT_MULTI_EMAIL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    // NSMutableString *dataToSend = [NSMutableString string];
    
    // [dataToSend appendFormat:@"uid=%@&fction=%@&item_id=%@&email=%@", [[Configs sharedInstance] getUIDU], fction, item_id, email];
    // [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU], @"fction":fction, @"item_id":item_id, @"email":email};
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
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
