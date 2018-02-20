//
//  SignUpThread.m
//  Heart-Firebase
//
//  Created by Somkid on 9/24/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SignUpThread.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@implementation SignUpThread
//
//@end


#import "Configs.h"

@implementation SignUpThread

-(void)start:(NSString *)username:(NSString *)email
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    // self.receivedData = nil;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    
    //initialize url that is going to be fetched.
    // NSURL *url = [NSURL URLWithString:@"http://www.snee.com/xml/crud/posttest.cgi"];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?udid=%@&platform=ios&bundleidentifier=%@&version=%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].USER_REGISTER ,[[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication]]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    /*
     postData.put("token", token);
     postData.put("client", clientId);
     postData.put("apikey", Constants.API_KEY);
     postData.put("model", DeviceUtil.getDeviceModel());
     */
    
    //initialize a post data
    // NSString *postData = [[NSString alloc] initWithString:@"fname=example&lname=example"];  username, password, parse_id
    
    // NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@&parse_id=%@", username, password, parse_id];
    // NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    
    //set request content type we MUST set this value.
    // [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [request setValue:@"aAs9B_vHJ86yf5gjvXbFRfrPPBHV9ENHFIu8riaI7wM" forHTTPHeaderField:@"X-CSRF-Token"];
    
    //set post data of request
    // [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary* dict = @{ @"name": username,
                            @"pass": @"1234",
                            @"mail": email,
                            @"udid": [[Configs sharedInstance] getUniqueDeviceIdentifierAsString],
                            @"platform" : @"ios",
                            @"bundleidentifier" : [[Configs sharedInstance] getBundleIdentifier],
                            @"version" : [[Configs sharedInstance] getVersionApplication]};
    
    /*
         NSString *dataToSend = [[NSString alloc] initWithFormat:@"udid=%@&platform=ios&bundleidentifier=%@&version=%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication]];
     */
    
    NSError* error;
    NSData* _data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
//    NSString *postString = [NSString stringWithFormat:@"name=%@&pass=%@&mail=%@", strUsername, strPassword, strEmail];
    
    [request setHTTPBody:_data];
    
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
    
    NSLog(@"%@" , error);
    
    if (self.errorHandler) {
        self.errorHandler([error description]);
    }
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@" , htmlSTR);
    
    //    NSError *error = nil;
    //    id object = [NSJSONSerialization
    //                 JSONObjectWithData:self.receivedData
    //                 options:0
    //                 error:&error];
    //
    //    if(error) { /* JSON was malformed, act appropriately here */ }
    //    if([object isKindOfClass:[NSDictionary class]]){
    //        NSDictionary *results = object;
    //        NSLog(@"%@",[results objectForKey:@"status"]);
    //        NSLog(@"%@",[results objectForKey:@"output"]);
    //    }else{
    //        NSLog(@"there is not an JSON object");
    //    }
    
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}
@end


