//
//  AddFriendThread.m
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AddFriendThread.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
//@implementation AddFriendThread
//
//@end

#import "Configs.h"
#import "AppConstant.h"

@implementation AddFriendThread

-(void)start: (NSString *)friend_id
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].ADD_FRINEDS ]];
    
    //initialize a request from url
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
            
    NSMutableString *dataToSend = [NSMutableString string];
    
//    [dataToSend appendFormat:@"uid=%@&friend_id=%@", [[Configs sharedInstance] getUIDU], friend_id];
//    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU], @"friend_id":friend_id};
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
