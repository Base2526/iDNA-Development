//
//  PreLoginViewController.m
//  Heart
//
//  Created by Somkid on 12/17/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "PreLogin.h"
//#import "AnNmousUThread.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"
#import "MainTabBarController.h"
#import "MainViewController.h"
#import "AppConstant.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PreLogin ()<FBSDKLoginButtonDelegate>
{
    FBSDKLoginButton *loginButton;
}
@end

@implementation PreLogin
@synthesize btnLogin, btnAnnonymous;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Welcome to iDNA";
    
    btnLogin.layer.cornerRadius = 5;
    btnLogin.layer.borderWidth = 1;
    btnLogin.layer.borderColor = [UIColor blueColor].CGColor;
    
    btnAnnonymous.layer.cornerRadius = 5;
    btnAnnonymous.layer.borderWidth = 1;
    btnAnnonymous.layer.borderColor = [UIColor blueColor].CGColor;
    
    // https://stackoverflow.com/questions/35160329/custom-facebook-login-button-ios/35160568
    loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    // loginButton.center = self.view.center;
    loginButton.hidden = YES;
    
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    
    [self.view addSubview:loginButton];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"");
        [self fetchUserInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)  loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error{
        //use your custom code here
        //redirect after successful login
    
    if (error)
    {
        // Process error
        NSLog(@"");
    }
    else if (result.isCancelled)
    {
        // Handle cancellations
        NSLog(@"");
    }
    else
    {
        if ([result.grantedPermissions containsObject:@"email"])
        {
            NSLog(@"result is:%@",result);
            [self fetchUserInfo];
        }
    }
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    //use your custom code here
    //redirect after successful logout
    NSLog(@"");
}
    
-(void)fetchUserInfo {
    
// [FBSDKAccessToken setCurrentAccessToken:@""];
        if ([FBSDKAccessToken currentAccessToken])
        {
            NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown , friendlists"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error)
                 {
                     NSLog(@"resultis:%@",result);
                 }
                 else
                 {
                     NSLog(@"Error %@",error);
                 }
             }];
            
        }
        
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAnnmousu:(id)sender {
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL, [Configs sharedInstance].ANNMOUSU]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                   
                                                                   [[Configs sharedInstance] SVProgressHUD_Dismiss];
                                                                   if (error == nil) {
                                                                       
                                                                       NSObject* obj= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                                                                       
                                                                       if ([obj isKindOfClass:[NSArray class]]) {
                                                                           
                                                                           NSArray *objArray = (NSArray *)obj;
                                                                           NSString* text = [objArray objectAtIndex:0];
                                                                       }
                                                                       
                                                                       NSDictionary *jsonDict = (NSDictionary *)obj;
                                                                       if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                           
                                                                           NSMutableDictionary *idata  = jsonDict[@"data"];
                                                                           
                                                                           if (![idata isKindOfClass:[NSDictionary class]]) {
                                                                               [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", idata]];
                                                                           }else{
                                                                               if ([idata count] > 0) {
                                                                                   [[Configs sharedInstance] saveData:_USER :idata];
                                                                                   
                                                                                   [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                                                            selector:@selector(synchronizeData:)
                                                                                                                                name:@"synchronizeData"
                                                                                                                              object:nil];
                                                                                   
                                                                                   [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait Synchronize data"];
                                                                                   [[Configs sharedInstance] synchronizeData];
                                                                               }else{
                                                                                   [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Login Error"];
                                                                               }
                                                                           }
                                                                       }else{
                                                                           [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
                                                                       }
                                                                   }else{
                                                                       // self.errorHandler([error description]);
                                                                       
                                                                       [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[error description]];
                                                                   }
                                                               }];
    
    // 5
    [uploadTask resume];
}
    
- (IBAction)onLoginFB:(id)sender {
    [loginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}
    
-(void)synchronizeData:(NSNotification *) notification{
    
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    // NSDictionary *dict =  @{@"function" : @"reset"};
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
}
@end
