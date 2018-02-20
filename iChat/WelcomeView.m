//
//  PreLoginViewController.m
//  Heart
//
//  Created by Somkid on 12/17/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "WelcomeView.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"
#import "MainTabBarController.h"
#import "MainViewController.h"
#import "AppConstant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MyApplicationsRepo.h"
#import "FollowingRepo.h"

#import "FriendProfileRepo.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface WelcomeView ()<FBSDKLoginButtonDelegate>{
    FBSDKLoginButton *loginButton;
    FIRDatabaseReference *ref;
    FriendProfileRepo *friendProfileRepo;
}
@end

@implementation WelcomeView
@synthesize btnLogin, btnAnnonymous;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Welcome to iDNA";
    
    ref = [[FIRDatabase database] reference];
    friendProfileRepo = [[FriendProfileRepo alloc] init];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] onRemoveObserveFirebase];
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
    if ([FBSDKAccessToken currentAccessToken]){
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
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [self onAnnmousu:data :error];
    }];
    
    // 5
    [uploadTask resume];
}
    
- (IBAction)onLoginFB:(id)sender {
    [loginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}
    
-(void)showMainView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
    });
}

-(void)onAnnmousu:(NSData *)value:(NSError *)error{
   
    if (error == nil) {
        NSDictionary* jsonDict= [NSJSONSerialization JSONObjectWithData:value  options:kNilOptions error:nil];
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableDictionary *data  = jsonDict[@"data"];
            
            /*
            [[Configs sharedInstance] saveData:_USER :data];
            
            // #1 ส่วนของ profiles user
            NSMutableDictionary *profiles = jsonDict[@"profiles"];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:profiles];
            // #1 ส่วนของ profiles user
            
            NSMutableDictionary *friends = jsonDict[@"friends"];
            if ([friends count] > 0) {
                for (NSString* key in friends) {
                    NSDictionary* value = [friends objectForKey:key];
                    
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:key :value];
                    NSLog(@"%@", value);
                }
            }
            
            NSMutableDictionary *profile_friend = jsonDict[@"profile_friend"];
            if ([profile_friend count] > 0) {
                for (NSString* key in profile_friend) {
                    NSDictionary* value = [profile_friend objectForKey:key];
                    
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfileFriend:key :value];
                    NSLog(@"%@", value);
                }
            }
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            [self showMainView];
            NSLog(@"");
            */
            
            if (![data isKindOfClass:[NSDictionary class]]) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", data]];
            }else{
                if ([data count] > 0) {
                    [[Configs sharedInstance] saveData:_USER :data];
                    
                    NSMutableArray *childObservers = [[NSMutableArray alloc] init];
                
                    NSString *child = [NSString stringWithFormat:@"%@%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                    
                    // [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    [[ref child:child] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                        // NSLog(@"%@", snapshot.value);
                        
                        [childObservers addObject:[ref child:child]];
                        
                        NSMutableDictionary *value = snapshot.value;
                        
                        // #1 ส่วนของ profiles user
                        NSMutableDictionary *profiles = [value objectForKey:@"profiles"];
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:profiles];
                        // #1 ส่วนของ profiles user
                        
                        // #2 ส่วนของ my_applications
                        if ([value objectForKey:@"my_applications"] != nil) {
                            NSDictionary *my_applications = [value objectForKey:@"my_applications"];
                            
                            for (NSString* key in my_applications) {
                                NSDictionary* val = [my_applications objectForKey:key];

                                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateMyApplications:key :val];
                            }
                        }
                        // #2 ส่วนของ my_applications
                        
                        // #3 ส่วนของ following
                        if ([value objectForKey:@"following"] != nil) {
                            NSDictionary *following = [value objectForKey:@"following"];
                            
                            for (NSString* key in following) {
                                NSDictionary* val = [following objectForKey:key];
                                
                                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFollowing:key :val];
                            }
                        }
                        // #3 ส่วนของ following
                        
                        // #4 ส่วนของ classs
                        if ([value objectForKey:@"classs"] != nil) {
                            NSDictionary *classs = [value objectForKey:@"classs"];
                            
                            // ClasssRepo *classsRepo = [[ClasssRepo alloc] init];
                            for (NSString* key in classs) {
                                NSDictionary* val = [classs objectForKey:key];
                                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateClasss:key :val];
                            }
                        }
                        // #4 ส่วนของ classs
                        
                        // #5 ส่วนข้อมูลของ friends & profile friend
                     
                        //  กรณีไม่มีเพือนเราจะออกจะเกิดกรณีนี้เมือ พึงสมัครมาครั้งแรก
                     
                        if ([value objectForKey:@"friends"] == nil) {
                            [[Configs sharedInstance] SVProgressHUD_Dismiss];
                            
                            [self showMainView];
                            return;
                        }
                        
                        // FriendsRepo *friendsRepo = [[FriendsRepo alloc] init];
                        NSMutableDictionary *friends = [value objectForKey:@"friends"];
                        
                        __block int count = 0;
                        for (NSString* key in friends) {
                            
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:key :[friends objectForKey:key]];
                            
                            NSString *fchild = [NSString stringWithFormat:@"%@%@/profiles", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], key];
                            [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                
                                NSString* parent = snapshot.ref.parent.key;
                                NSLog(@"%@, %@, %@", parent, snapshot.key, snapshot.value);
                                
                                count++;
                                
                                [childObservers addObject:[ref child:fchild]];
         
                                if (snapshot.value == (id)[NSNull null]){
                                    return;
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (![friendProfileRepo check:parent]) {
                                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfileFriend:parent :snapshot.value];
                                    }
                                });
                                
                                // จะออกก็ต่อเมือดึงข้อมูล ถึงคนสุดท้ายเท่านั้น
                                if (friends.count == count) {
                                    for (FIRDatabaseReference *ref in childObservers) {
                                        [ref removeAllObservers];
                                    }
                                    
                                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                                    [self showMainView];
                                }
                            }];
                        }
                        // #5 ส่วนข้อมูลของ friends & profile friend
                    }];
                }else{
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Login Error"];
                }
            }
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
        }
    }else{
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[error description]];
    }
}
@end
