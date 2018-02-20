//
//  GroupInviteNewMembersThread.m
//  iChat
//
//  Created by Somkid on 5/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "GroupInviteNewMembersThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation GroupInviteNewMembersThread

-(void)start: (NSString*)group_id :(NSArray *)members
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].GROUP_INVITE_NEW_MEMBERS]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[Configs sharedInstance].timeOut];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    // [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSMutableString *dataToSend = [NSMutableString string];//[[NSString alloc] initWithFormat:@"uid=%@&image=%@", [[Configs sharedInstance] getUIDU], imgString];
    
    [dataToSend appendFormat:@"uid=%@&group_id=%@&", [[Configs sharedInstance] getUIDU], group_id];
    
    for (NSString *friend_id in members) {
        // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];
        
        NSLog(@"%@", friend_id);
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


