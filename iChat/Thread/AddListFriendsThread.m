//
//  ListFriendsThread.m
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AddListFriendsThread.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//@implementation ListFriendsThread
//
//@end

#import "Configs.h"
#import "AppConstant.h"

@implementation AddListFriendsThread

-(void)start
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].ADD_LIST_FRINEDS ]];
    
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
    
    
    NSDictionary* dict = @{ @"uid": [[Configs sharedInstance] getUIDU]};
    
    NSLog(@">%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]);
    
    NSError* error;
    NSData* _data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
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

- (NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end
