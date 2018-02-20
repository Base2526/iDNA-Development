//
//  UpdateBGThread.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "UpdatePictureBGThread.h"
#import "Configs.h"
#import "AppConstant.h"

@implementation UpdatePictureBGThread
-(void)start: (UIImage *)image
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // http://localhost/test-parse/gen_qrcode.php?user=52So6zp2om
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].UPDATE_PICTURE_BG ]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
//    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
//
//    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&image=%@", [[Configs sharedInstance] getUIDU], imgString];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
 
    //  ติดปัญหาตรง nsdictionary limit size value ทำให้เราไม่สามารถส่ง imgString ไปได้จึงใช้แบบเดิมไปก่อน
 
//    NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU], @"image":imgString};
//    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
//    [request setHTTPBody:jsonBodyData];
    

    
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
/*

-(void)start: (UIImage *)image{
    // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"REST URL PATH"]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].UPDATE_PICTURE_BG ]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [[Configs sharedInstance] getUToken];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=uid\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[Configs sharedInstance] getUIDU]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.png\r\n", @"image_key"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error != nil) {
            self.errorHandler([error description]);
        }
        if(data.length > 0)
        {
            //success
            self.completionHandler(data);
        }else{
            self.errorHandler(@"Error upload.");
        }
    }];
}
 */
@end

