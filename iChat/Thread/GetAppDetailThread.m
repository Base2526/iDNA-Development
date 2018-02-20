//
//  GetAppDetailThread.m
//  Heart
//
//  Created by Somkid on 4/3/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "GetAppDetailThread.h"

#import "Configs.h"
#import "AppConstant.h"
#import "Configs.h"

@implementation GetAppDetailThread
-(void)start:(NSString *)item_id
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].GET_APP_DETAIL]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    // [dataToSend appendString:[NSString stringWithFormat:@"uid=%@&",  [preferences objectForKey:_UID]]];
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"udid=%@&platform=ios&bundleidentifier=%@&version=%@&uid=%@&item_id=%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication], [[Configs sharedInstance] getUIDU], item_id];
    
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    // [connection release];
    
    //start the connection
    [connection start];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (self.errorHandler) {
        self.errorHandler([error description]);
    }
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}
@end
