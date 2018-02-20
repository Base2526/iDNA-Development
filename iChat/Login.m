//
//  Login.m
//  Heart-Basic
//
//  Created by somkid simajarn on 9/3/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "Login.h"
//#import "SWRevealViewController.h"

#import <Firebase/Firebase.h>
#import "SVProgressHUD.h"
#import "LoginThread.h"
#import "AppConstant.h"
#import "Configs.h"
#import "MainTabBarController.h"
#import <FirebaseInstanceID/FIRInstanceID.h>
#import "FriendProfileRepo.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Login (){
    FIRDatabaseReference *ref;
    FriendProfileRepo *friendProfileRepo;
}
@end

@implementation Login
@synthesize btnLogin, btnSignUp, btnForgotPassword;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    friendProfileRepo = [[FriendProfileRepo alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
   
    // Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blazing-torch-6635.firebaseio.com/web/saving-data/fireblog"];
    
    btnLogin.layer.cornerRadius = 5;
    btnLogin.layer.borderWidth = 1;
    btnLogin.layer.borderColor = [UIColor blueColor].CGColor;

    btnSignUp.layer.cornerRadius = 5;
    btnSignUp.layer.borderWidth = 1;
    btnSignUp.layer.borderColor = [UIColor blueColor].CGColor;
    
    btnForgotPassword.layer.cornerRadius = 5;
    btnForgotPassword.layer.borderWidth = 1;
    btnForgotPassword.layer.borderColor = [UIColor blueColor].CGColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:_EMAIL_LAST] != nil){
        self.TxtEmail.text = [preferences objectForKey:_EMAIL_LAST];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 

 */

- (IBAction)onLogin:(id)sender {
//    SWRevealViewController *mtc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    [self presentViewController:mtc animated:YES completion:nil];
    
    NSString *strEmail = [self.TxtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//self.TxtEmail.text;
    NSString *strPassword = [self.TxtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//
    
    if ([strEmail isEqualToString:@""] && [strPassword isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Email & Password is Empty."];
    }else if([strEmail isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"Email is Empty."];
    }else if([strPassword isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"Password is Empty."];
    }/*else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
        [SVProgressHUD showErrorWithStatus:@"Email is Invalid."];
    }*/else{
         [SVProgressHUD showWithStatus:@"Login"];
        
         LoginThread *lThread = [[LoginThread alloc] init];
         [lThread setCompletionHandler:^(NSData * str) {
             NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
         
             // [myObject isKindOfClass:[NSString class]]

             if ([jsonDict isKindOfClass:[NSArray class]]) {
                 [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[(NSArray *)jsonDict objectAtIndex:0]];
                 return;
             }
             
             if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                 
                 NSMutableDictionary *idata         = jsonDict[@"data"];
                 
                 if (![idata isKindOfClass:[NSDictionary class]]) {
                     [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", idata]];
                 }else{
                     if ([idata count] > 0) {
                         
                         [[Configs sharedInstance] saveData:_USER :idata];
                         
                         /*
                         [[NSNotificationCenter defaultCenter] addObserver:self
                                                                  selector:@selector(synchronizeData:)
                                                                      name:@"synchronizeData"
                                                                    object:nil];
                         
                         [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait Synchronize data"];
                         [[Configs sharedInstance] synchronizeData];
                         */
                         
                         NSMutableArray *childObservers = [[NSMutableArray alloc] init];
                         
                         NSString *child = [NSString stringWithFormat:@"%@%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                         
                         [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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
                             /*
                              กรณีไม่มีเพือนเราจะออกจะเกิดกรณีนี้เมือ พึงสมัครมาครั้งแรก
                              */
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
         }];
         [lThread setErrorHandler:^(NSString * str) {
             [SVProgressHUD  showErrorWithStatus:str];
         }];
         
         [lThread start:strEmail :strPassword];
    }
}

-(void)showMainView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
    });
}

//-(void)synchronizeData:(NSNotification *) notification{
//
//    [[Configs sharedInstance] SVProgressHUD_Dismiss];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] initMainView];
//}

@end
