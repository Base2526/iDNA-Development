//
//  LoginThread.m
//  ParseStarterProject
//
//  Created by somkid simajarn on 6/9/2559 BE.
//
//
#import "LoginThread.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Configs.h"

@implementation LoginThread
-(void)start:(NSString *)name:(NSString *)pass
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_LOGIN]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];

    NSDictionary *jsonBodyDict = @{@"name":name, @"pass":pass};
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

