//
//  MyQRCode.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "MyQRCode.h"
#import "AppDelegate.h"
#import "UserDataUIAlertView.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MyQRCode (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}
@end

@implementation MyQRCode
@synthesize hjhQR;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref         = [[FIRDatabase database] reference];
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles    = [[Configs sharedInstance] getUserProfiles];
        if ([profiles objectForKey:@"url_my_qrcode"]) {
            [hjhQR clear];
            [hjhQR showLoadingWheel];
            // [self.hjhQR setUrl:[NSURL URLWithString:self.uri]];
            // [img setImage:[UIImage imageWithData:fileData]];
            
            [self.hjhQR setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"url_my_qrcode"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjhQR];
        }else{
            [hjhQR clear];
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSettings:(id)sender {
    NSLog(@"onSettings");
    
    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Create new qrcode.", @"Close", nil];
    
    // alert.userData = indexPath;
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:{
                // Create new qrcode.
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].RECREATE_QRCODE ]];
                
                NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
                // NSLog(@"%@", [request allHTTPHeaderFields]);
                /*
                 NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&platform=%@&bundleidentifier=%@", [[Configs sharedInstance] getUIDU], @"ios", [[Configs sharedInstance] getBundleIdentifier] ];
                 [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
                 */
                
                NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU]};
                NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
                [request setHTTPBody:jsonBodyData];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    if (error == nil) {
                        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            
                            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                            [newProfiles addEntriesFromDictionary:profiles];
                            
                            if ([newProfiles objectForKey:@"url_my_qrcode"]) {
                                [newProfiles removeObjectForKey:@"url_my_qrcode"];
                            }
                            
                            [newProfiles setValue:jsonDict[@"url_my_qrcode"] forKey:@"url_my_qrcode"];
                            
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                            
                            [self reloadData:nil];
                        }else{
                            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
                        }
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error."];
                    }
                }];
                
                [postDataTask resume];
            }
                break;
                
            case 1:{
                // Close
                NSLog(@"Close");
            }
                break;
        }
    }
}
@end
