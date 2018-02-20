//
//  ApplicationCategoryThread.m
//  Heart
//
//  Created by Somkid on 1/23/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ApplicationCategoryThread.h"

//@implementation ApplicationCategoryThread
//
//@end

#import "Configs.h"
#import "AppConstant.h"

@implementation ApplicationCategoryThread
-(void)start
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].APPLICATION_CATEGORY ]];
    
    //initialize a request from url
   //  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //    NSString *imgString =@"";
    //    if (image != nil) {
    //        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    //        imgString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //    }
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    UIDevice *deviceInfo = [UIDevice currentDevice];
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@", [[Configs sharedInstance] getUIDU]];
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
    
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}
@end

