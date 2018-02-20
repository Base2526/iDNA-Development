//
//  UpdatePhotoMyAppThread.m
//  Heart
//
//  Created by Somkid on 1/19/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "UpdateMyAppProfileThread.h"

//@implementation UpdatePhotoMyAppThread
//
//@end
#import "Configs.h"
#import "AppConstant.h"

@implementation UpdateMyAppProfileThread
-(void)start:(NSString *)item_id :(NSString *)fi :(UIImage *)image{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].UPDATE_MY_APPLICATION_PROFILE ]];

    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imgString =@"";
    if (image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        imgString = [[Utility base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&item_id=%@&fi=%@&image=%@", [[Configs sharedInstance] getUIDU], item_id, fi, imgString];
    
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

