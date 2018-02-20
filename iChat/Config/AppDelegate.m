//
//  AppDelegate.m
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import "AppDelegate.h"
#import "MessageRepo.h"
#import "WelcomeView.h"
#import "MainTabBarController.h"
#import "FriendProfileRepo.h"
#import "GroupChatRepo.h"
#import "GroupChat.h"
#import "MyApplicationsRepo.h"
#import "MyApplications.h"
#import "Center.h"
#import "CenterRepo.h"
#import "Classs.h"
#import "ClasssRepo.h"
#import "Following.h"
#import "FollowingRepo.h"
#import "MainViewController.h"
#import "MainTabBarController.h"
#import "ProfilesRepo.h"
#import "Friends.h"
#import "FriendsRepo.h"
#import "LogoutThread.h"
#import "GroupChatRepo.h"
#import "MyApplicationsRepo.h"
#import "FollowingRepo.h"
#import "ClasssRepo.h"
#import "SlideShowRepo.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

//@import Firebase;
//@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate , FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate (){
    NSMutableArray *childObservers, *childObserver_Friends;
    
    ProfilesRepo* profilesRepo;
    FriendsRepo* friendRepo;
    FriendProfileRepo *friendProfileRepo;
    GroupChatRepo* groupChatRepo;
    ClasssRepo *classsRepo;
    MyApplicationsRepo *myapplicationsRepo;
    FollowingRepo *followingRepo;
    
    CenterRepo *centerRepo;
    SlideShowRepo *slideShowRepo;
}

@end

@implementation AppDelegate
@synthesize ref /*, friendsProfile*/;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Cache
    NSString *documentdictionary;
    NSArray *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdictionary = [Path objectAtIndex:0];
    documentdictionary = [documentdictionary stringByAppendingPathComponent:@"D8_cache/"];
    self.obj_Manager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:500];
    
    HJMOFileCache *fileCache = [[HJMOFileCache alloc] initWithRootPath:documentdictionary];
    self.obj_Manager.fileCache=fileCache;
    
    fileCache.fileCountLimit=10000;
    fileCache.fileAgeLimit=60*60*24*7;
    [fileCache trimCacheUsingBackgroundThread];
    // Cache
    
    
    // Firebase
    // Firebase Config
    // [FIRApp configure];
    
    
    // [FIRApp configure];
    
    
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            
            // [[FIRMessaging messaging] setRemoteMessageDelegate:self];
            
            //[FIRMessaging messaging].delegate = self;
            
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }

// https://stackoverflow.com/questions/37472090/in-new-firebase-how-to-use-multiple-config-file-in-xcode
#ifdef DEBUG
    FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleService-Info-Development" ofType:@"plist"]];
    [FIRApp configureWithOptions:options];
#else
    FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleService-Info-Distribution" ofType:@"plist"]];
    [FIRApp configureWithOptions:options];
#endif
    
    // [FIRApp configure];
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    ref = [[FIRDatabase database] reference];
    // Firebase Config
    // Firebase
    
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
    
    
    // สร้าง friendsProfile
    // friendsProfile = [[NSMutableDictionary alloc] init];
    
    
    
    ///<----
    /*
     เช็ดก่อนว่ามีการ login แล้วหรือเปล่า ถ้า
     - true
        : เราจะวิ่งไปที่  MainTabBarController
     
     - false 
        : จะไปหน้า login 
     */
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (![[Configs sharedInstance] isLogin]){
        WelcomeView *welcomeView = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeView"];
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:welcomeView];
        
        self.window.rootViewController = navCon;
        [self.window makeKeyAndVisible];
        
    }else{
        // MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
//        SWRevealViewController*mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//
//        self.window.rootViewController = mainTabBarController;
//        [self.window makeKeyAndVisible];
        
        
//        MainViewController *mainViewController = [storyboard instantiateInitialViewController];
//        mainViewController.rootViewController = navigationController;
//        [mainViewController setupWithType:indexPath.row];
//
//        UIWindow *window = UIApplication.sharedApplication.delegate.window;
//        window.rootViewController = mainViewController;
        
        // MainViewController
        
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"]]];
        
        /*
        MainViewController*mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        self.window.rootViewController = mainView;
        [self.window makeKeyAndVisible];
         */
        
        MainTabBarController *mainTabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        
        MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];;//[storyboard instantiateInitialViewController];
        mainViewController.rootViewController = mainTabBar;
        [mainViewController setupWithType:1];
        
        // UIWindow *window = UIApplication.sharedApplication.delegate.window;
        self.window.rootViewController = mainViewController;
        
        [self.window makeKeyAndVisible];
        
        [self onAddObserveFirebase];
    }
    //------>
    
    
    //  แสดงรายชื่อตารางทั้งหมด database
    DBManager * db = [[DBManager alloc] init];
    NSLog(@"แสดงรายชื่อตารางทั้งหมด database : %@",[db fetchTableNames]);
    //  แสดงรายชื่อตารางทั้งหมด database
    
    
    // ---- FB
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // ---- FB
    
    
    profilesRepo            = [[ProfilesRepo alloc] init];
    friendProfileRepo       = [[FriendProfileRepo alloc] init];
    friendRepo              = [[FriendsRepo alloc] init];
    groupChatRepo           = [[GroupChatRepo alloc] init];
    classsRepo              = [[ClasssRepo alloc] init];
    myapplicationsRepo      = [[MyApplicationsRepo alloc] init];
    followingRepo           = [[FollowingRepo alloc] init];
    centerRepo              = [[CenterRepo alloc] init];
    slideShowRepo           = [[SlideShowRepo alloc] init];
    
    childObserver_Friends   = [[NSMutableArray alloc] init];
    
    return YES;
}
   
// ---- FB
- (BOOL)application:(UIApplication *)application
                openURL:(NSURL *)url
                options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
    // Add any custom logic here.
    NSLog(@"");
    return handled;
}
    
- (BOOL)application:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation
                        ];
    NSLog(@"");
        // Add any custom logic here.
    return handled;
}
// ---- FB

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self updateStatusOnline:@"0"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/*
 App ถูกเปิด
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFcm];
    
    [self updateStatusOnline:@"1"];
}

/*
 App โดน quit ออกจาก Task
 เราจะไม่ใช้ fucntion applicationWillTerminate ในการบอกว่า offline เพราะว่า app จะหยุดการทำงานเลยโดยไม่มีการส่ง status ไป update เราจึงไปใช้ function applicationWillResignActive แทน
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
}

// Firebase
// [START receive_message]
// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    //    NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"test1", @"title", @"test1", @"body", nil];
    //    DebugLog(@"message id to respond?: %@, response: %@", userInfo[@"message_id"], response);
    //    [self connectToFcm];
    //
    //    [[FIRMessaging messaging] sendMessage:response to:@"----@gcm.googleapis.com." withMessageID:userInfo[@"message_id"]  timeToLive: 108];
}
// [END receive_message]


// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    if (refreshedToken != nil) {
        /*
         การที่เราไม่ check ก่อน save เพราะว่าเราต้องการให้ database เก็บ revision การ install/uninstall app ด้วย เพราะ refreshedToken ทีได้แต่ละครั้งจะไม่เหมือนการ drupal จะมีการเก็บ revision ในการ update ข้อมูล
         */
        NSDictionary *values =  @{@"token": refreshedToken,
                                  @"udid": [[Configs sharedInstance] getUniqueDeviceIdentifierAsString],
                                  @"platform": @"ios"
                                  };
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@token_notification/%@/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [ref childByAutoId].key]:values};
        [ref updateChildValues:childUpdates];
    }
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)forceLogout{
    if ([[Configs sharedInstance] isLogin]) {
        
        LogoutThread * logoutThread = [[LogoutThread alloc] init];
        [logoutThread setCompletionHandler:^(NSData * data) {
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                NSMutableDictionary *idata  = jsonDict[@"data"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    WelcomeView *welcomeView = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeView"];
                    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:welcomeView];
                    
                    self.window.rootViewController = navCon;
                });
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
            }
        }];
        [logoutThread setErrorHandler:^(NSString * data) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:data];
        }];
        [logoutThread start];
    }
}

- (void)onAddObserveFirebase{
    
    if (childObserver_Friends != nil) {
        for (FIRDatabaseReference *ref in childObserver_Friends) {
            [ref removeAllObservers];
        }
    }
    
    // Observers
    NSString *child = [NSString stringWithFormat:@"%@%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    
    /* กรณี เราโดนลบจากหลังบ้านให้ มีการ force logout */
    [[ref child:[NSString stringWithFormat:@"%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH]]] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        if([snapshot.key isEqualToString:[[Configs sharedInstance] getUIDU]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self forceLogout];
            });
        }
    }];
    
    
    [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        if ([snapshot.key isEqualToString:@"friends"]) {
            NSDictionary *friends = snapshot.value;
            
            for (NSString* key in friends) {
                NSDictionary* friend = [friends objectForKey:key];
                [self updateFriend:key :friend];
                
                
                /*
                 กรณีมีการ เพิ่มเพือนใหม่เราต้องเช็กทุกวัน friend_id นี้เราได้ดึง profile มาหรือยังถ้ายังให้ไปดึง
                 */
                
                if([key isEqualToString:@"729"]){
                    NSLog(@"");
                }
                NSArray *test =[friendProfileRepo get:key];
                if ([friendProfileRepo get:key] == nil){
                    
                    NSString *fchild = [NSString stringWithFormat:@"%@%@/profiles", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], key];
                    
                    // การดึง ข้อมูล profile friend มาครั้งแรก
                    [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snap) {
                        
                        NSString* parent = snap.ref.parent.key;
                        NSLog(@"%@, %@, %@", parent, snap.key, snap.value);
                        
                        // [[Configs sharedInstance] saveData:parent :snapshot.value];
                        
                        
                        if (snap.value == (id)[NSNull null]){
                            NSLog(@"");
                        }else{
                
                            [self updateProfileFriend:parent :snap.value];
                        }
                    }];
                }
                
                /*
                 เราจะ tage เฉพาะ profile friend เท่านั้น
                 */
                NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], key];
                
                [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                    
                    [self friendUpdateData:snapshot];
                    NSLog(@"");
                }];
                
                //  กรณี friend_id มีการ change data เช่น online, offline
                [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                    
                    // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
                    // NSString* parent = snapshot.ref.parent.key;
                    
                    
                    [childObserver_Friends addObject:[ref child:child]];
                    [self friendUpdateData:snapshot];
                    
                }];
                NSLog(@"");
            }
        }
    }];
    
    ////////////////////////////////////////////  friends  /////////////////////////////////////////////////
    /*
     กรณีมีการ เพิ่มเพือนใหม่
     */
    [[[ref child:child] child:@"friends"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);

        [self updateFriend:snapshot.key :snapshot.value];
        
        /*
         กรณีมีการ เพิ่มเพือนใหม่เราต้องเช็กทุกวัน friend_id นี้เราได้ดึง profile มาหรือยังถ้ายังให้ไปดึง
         */
        if ([friendProfileRepo get:snapshot.key] == nil){
            
            NSString *fchild = [NSString stringWithFormat:@"%@%@/profiles", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], snapshot.key];
            
            // การดึง ข้อมูล profile friend มาครั้งแรก
            [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snap) {
                
                NSString* parent = snap.ref.parent.key;
                NSLog(@"%@, %@, %@", parent, snap.key, snap.value);
                
                // [[Configs sharedInstance] saveData:parent :snapshot.value];
                
                
                if (snap.value == (id)[NSNull null]){
                    NSLog(@"");
                }else{
                    [self updateProfileFriend:parent :snap.value];
                }
            }];
        }
        
        /*
         เราจะ tage เฉพาะ profile friend เท่านั้น
         */
        NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], snapshot.key];
        
        [[ref child:child] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            [self friendUpdateData:snapshot];
            NSLog(@"");
        }];
        
        //  กรณี friend_id มีการ change data เช่น online, offline
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
            // NSString* parent = snapshot.ref.parent.key;
            
            
            [childObserver_Friends addObject:[ref child:child]];
            [self friendUpdateData:snapshot];
            
        }];
    }];
    
    /*
     กรณีมีการ ข้อมูลเพือนมีการแก้ไข
     */
    [[[ref child:child] child:@"friends"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        NSArray *val =  [friendRepo get:snapshot.key];
        
        NSString* friend_id =[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
    
    
        [self updateFriend:friend_id :snapshot.value];
    }];
    
    /*
     กรณีมีการ ลบเพือน
     */
    [[[ref child:child] child:@"friends"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [friendRepo deleteFriend:snapshot.key];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_FRIEND object:self userInfo:@{}];
        });
    }];
    ////////////////////////////////////////////  Friends  /////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////  MY Applications  /////////////////////////////////////////////////
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // NSLog(@"%@, %@ -> %@", snapshot.key, snapshot.value, snapshot.ref);
        
        [self updateMyApplications:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // NSLog(@"%@, %@", snapshot.key, snapshot.value);
        [self updateMyApplications:snapshot.key :snapshot.value];
    }];
    
    
    [[[ref child:child] child:@"my_applications"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
        dispatch_async(dispatch_get_main_queue(), ^{
            [myapplicationsRepo deleteMyApplication:snapshot.key];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_MY_APPLICATIONS object:self userInfo:@{}];
        });
    }];
    
    ////////////////////////////////////////////  MY Applications  /////////////////////////////////////////////////
    
    
    // device_access
    /*
     จะเช็กทุกครั้งเมือเปิดเข้ามาทุกครั้ง
     */
    [[[[ref child:child] child:@"profiles"] child:@"device_access"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(![snapshot.value isKindOfClass:[NSDictionary class]]){
            return;
        }
        
        NSDictionary *val = snapshot.value;
 
        if([[val objectForKey:@"udid"] isEqualToString:[[Configs sharedInstance] getUniqueDeviceIdentifierAsString]]){
            if([[val objectForKey:@"is_login"] isEqualToString:@"0"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self forceLogout];
                });
            }
        }
    }];
    
    [[[[ref child:child] child:@"profiles"] child:@"device_access"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if(![snapshot.value isKindOfClass:[NSDictionary class]]){
            return;
        }
        
        // NSLog(@"%@, %@", snapshot.key, snapshot.value);
        
        NSDictionary *val = snapshot.value;
        
        // [self getUniqueDeviceIdentifierAsString]
        
        if([[val objectForKey:@"udid"] isEqualToString:[[Configs sharedInstance] getUniqueDeviceIdentifierAsString]]){
            if([[val objectForKey:@"is_login"] isEqualToString:@"0"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self forceLogout];
                });
            }
        }
    }];
    
    /*
     กรณี friend_id มีการ change data เช่น online, offline
     */
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        // NSLog(@"%@, %@", snapshot.key, snapshot.value);
//        NSLog(@"");
        /*
         จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
         */
        
        if ([snapshot.key isEqualToString:@"profiles"]) {
            // NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            [self updateProfile:snapshot.value];
            
        }else if ([snapshot.key isEqualToString:@"friends"]) {
            
            /*
            NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
            NSLog(@"");
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
                    [newDict removeObjectForKey:snapshot.key];
                    
                    [newDict setObject:snapshot.value forKey:snapshot.key];
                    
                    [[Configs sharedInstance] saveData:_DATA :newDict];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
                    
                });
            });
            */
            
            
            
        }else if([snapshot.key isEqualToString:@"invite_group"]){
            
            NSDictionary *invite_group = snapshot.value;
            
            for (NSString* id_invite_group in invite_group) {
                NSDictionary* value = [invite_group objectForKey:id_invite_group];
                NSString*owner_id = [value objectForKey:@"owner_id"];
                
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], owner_id, id_invite_group];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    
                    [childObserver_Friends addObject:[ref child:child]];
                    
                    NSLog(@"%@", snapshot.key);
                    NSLog(@"%@", snapshot.value);
                    NSLog(@"");
                
                    if (![snapshot.value isEqual:[NSNull null]]){
                        NSMutableDictionary *value = snapshot.value;
                        NSMutableDictionary *members = [[value objectForKey:@"members"] mutableCopy];
                        
                        NSMutableDictionary *newMembers = [[NSMutableDictionary alloc] init];
                        for (NSString* key in members) {
                            id _val = [members objectForKey:key];
                            // do stuff
                            
                            if([[_val objectForKey:@"status"] isEqualToString:@"pedding"]){
                                
                            }else{
                                [newMembers setObject:_val forKey:key];
                            }
                        }
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:value];
                        [newDict removeObjectForKey:@"members"];
                        
                        [newDict setObject:newMembers forKey:@"members"];
                        
                        NSLog(@"");
                        // เป็นการเก้บข้อมูล ชื่อกลุ่ม, image_url ของกลุ่มที่ invite มาเราจะเก็บแบบชั่วคราวเท่านั้น
                        [[Configs sharedInstance] saveData:snapshot.key :snapshot.value];
                    }
                }];
                
                // do stuff
                NSLog(@"");
            }
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }else if([snapshot.key isEqualToString:@"groups"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }else if([snapshot.key isEqualToString:@"multi_chat"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        }
    }];
    
    ////////////////////////////////////////////  Groups  /////////////////////////////////////////////////
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        [self updateGroup:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        [self updateGroup:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"groups"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([groupChatRepo get:snapshot.key] != nil) {
                [groupChatRepo deleteGroup:snapshot.key];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_GROUP object:self userInfo:@{}];
            }
        });
    }];
    ////////////////////////////////////////////  Groups  /////////////////////////////////////////////////
    
    ////////////////////////////////////////////  Classs  /////////////////////////////////////////////////
    [[[ref child:child] child:@"classs"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        [self updateClasss:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"classs"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        [self updateClasss:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"classs"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([classsRepo get:snapshot.key] != nil) {
                [classsRepo deleteClasss:snapshot.key];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_CLASSS object:self userInfo:@{}];
            }
        });
    }];
    
    ////////////////////////////////////////////  Classs  /////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////  Following  /////////////////////////////////////////////////
    [[[ref child:child] child:@"following"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        [self updateFollowing:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"following"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
    
        [self updateFollowing:snapshot.key :snapshot.value];
    }];
    
    [[[ref child:child] child:@"following"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([followingRepo get:snapshot.key] != nil) {
                [followingRepo deleteFollowing:snapshot.key];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_FOLLOWING object:self userInfo:@{}];
            }
        });
    }];
    
    ////////////////////////////////////////////  Following  /////////////////////////////////////////////////
    

    ////////////////////////////////////////////  Center  /////////////////////////////////////////////////
    NSString *child_center = [NSString stringWithFormat:@"%@center/", [[Configs sharedInstance] FIREBASE_ROOT_PATH]];
    
    [[ref child:child_center] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        for (NSString* key in snapshot.value) {
            [self updateCenter:key :[snapshot.value objectForKey:key]];
        }
    }];
    
    [[ref child:child_center]observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        for (NSString* key in snapshot.value) {
            [self updateCenter:key :[snapshot.value objectForKey:key]];
        }
    }];
    
    [[ref child:child_center ] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSString* key in snapshot.value) {
                if ([centerRepo get:key] != nil) {
                    [centerRepo deleteCenter:key];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_CENTER object:self userInfo:@{}];
                }
            }
        });
        
    }];
    ////////////////////////////////////////////  Center  /////////////////////////////////////////////////
    
    ////////////////////////////////////////////  Slide show  /////////////////////////////////////////////////
    NSString *child_slide_show = [NSString stringWithFormat:@"%@center-slide/", [[Configs sharedInstance] FIREBASE_ROOT_PATH]];
    
    [[ref child:child_slide_show] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        [self updateSlideShow:snapshot.key :snapshot.value];
    }];
    
    [[ref child:child_slide_show]observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        [self updateSlideShow:snapshot.key :snapshot.value];
    }];
    
    [[ref child:child_slide_show ] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@-%@", snapshot.key, snapshot.value);
        NSLog(@"");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([slideShowRepo get:snapshot.key] != nil) {
                [slideShowRepo deleteSlideShow:snapshot.key];
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_SLIDE_SHOW object:self userInfo:@{}];
            }
        });
        
    }];
    ////////////////////////////////////////////  Slide show  /////////////////////////////////////////////////
    
    /*
    NSMutableDictionary *groups = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"groups"];
    for (NSString* key in groups) {
        NSDictionary *item = [groups objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
               
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
     
                //  ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
     
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
    
    /*
    NSMutableDictionary *multi_chat = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"multi_chat"];
    for (NSString* key in multi_chat) {
        NSDictionary *item = [multi_chat objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
     
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
     
                //  ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
    */
}

-(void)onRemoveObserveFirebase{    
    if (childObserver_Friends != nil) {
        for (FIRDatabaseReference *ref in childObserver_Friends) {
            [ref removeAllObservers];
        }
    }
}

-(void)friendUpdateData:(FIRDataSnapshot *) snapshot{
    if([snapshot.key isEqualToString:@"image_url"] || [snapshot.key isEqualToString:@"mail"] || [snapshot.key isEqualToString:@"name"] || [snapshot.key isEqualToString:@"online"] || [snapshot.key isEqualToString:@"platform"] || [snapshot.key isEqualToString:@"status_message"] || [snapshot.key isEqualToString:@"udid"] || [snapshot.key isEqualToString:@"version"] || [snapshot.key isEqualToString:@"mails"] || [snapshot.key isEqualToString:@"phones"] || [snapshot.key isEqualToString:@"line_id"] || [snapshot.key isEqualToString:@"facebook"] || [snapshot.key isEqualToString:@"device_access"]){
     
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSLog(@"friendUpdateData >> %@, %@, %@",snapshot.ref.parent.parent.key,snapshot.key, snapshot.value);
            // FriendProfile *friendProfile = [[FriendProfile alloc] init];
            
            NSString* parent = snapshot.ref.parent.parent.key;
            
            NSArray *fprofile = [friendProfileRepo get:parent];
            NSData *data =  [[fprofile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data == nil) {
                return;
            }
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //*** update field ที่มีการ update
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:f];
            
            if([f objectForKey:snapshot.key]){
                
                if([[f objectForKey:snapshot.key] isKindOfClass:[NSString class]]){
                    if([[f objectForKey:snapshot.key] isEqualToString:snapshot.value]){
                        return;
                    }
                }else if([[f objectForKey:snapshot.key] isKindOfClass:[NSDictionary class]]){
                    if([[f objectForKey:snapshot.key] isEqualToDictionary:snapshot.value]){
                        return;
                    }
                }else{
                    [newDict removeObjectForKey:snapshot.key];
                }
            }
           
            [newDict setObject:snapshot.value forKey:snapshot.key];
            //****
            
            [self updateProfileFriend:parent :newDict];
        });
    }
}

- (void)initMainView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [mainViewController setupWithType:1];
    // [self presentViewController:mainViewController animated:YES completion:nil];
    
    self.window.rootViewController = mainViewController;
    
    [self.window makeKeyAndVisible];
    
    [self onAddObserveFirebase];
}

/*
 เป็นการ update Profile
 */
- (void)updateProfile:(NSDictionary*)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL sv = [profilesRepo set:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_PROFILES object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Friend
 */

- (void)updateFriend:(NSString *)friend_id:(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [friendRepo update:friend_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_FRIEND object:self userInfo:@{}];
    });
}

/*
 เป็นการ update ข้อมูลโปรไฟล์ของเพือน
 */
- (void)updateProfileFriend:(NSString *)friend_id:(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [friendProfileRepo update:friend_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_FRIEND object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Group
 */
- (void)updateGroup:(NSString *)group_id:(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [groupChatRepo update:group_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_GROUP object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Class
 */
- (void)updateClasss:(NSString* )item_id :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [classsRepo update:item_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_CLASSS object:self userInfo:@{}];
    });
}

/*
 เป็นการ update MyApplications
 */
-(void)updateMyApplications:(NSString* )app_id :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [myapplicationsRepo update:app_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_MY_APPLICATIONS object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Following
 */
-(void)updateFollowing:(NSString* )item_id :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [followingRepo update:item_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_FOLLOWING object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Center
 */
-(void)updateCenter:(NSString* )item_id :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [centerRepo update:item_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_CENTER object:self userInfo:@{}];
    });
}

/*
 เป็นการ update Slide Show
 */
-(void)updateSlideShow:(NSString* )item_id :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError * err;
        NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
        
        BOOL rs= [slideShowRepo update:item_id :[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA_SLIDE_SHOW object:self userInfo:@{}];
    });
}

/*
 update status online
 */
- (void)updateStatusOnline:(NSString *)status{
    if([[Configs sharedInstance] isLogin]){
        __block NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            BOOL flag = true;
            for(FIRDataSnapshot* snap in snapshot.children){
                if([snap.key isEqualToString:@"device_access"]){
                    // NSLog(@"snapshot.children : %@", snap.value);
                    
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/%@/online/", child, snap.key, [[Configs sharedInstance] getIDDeviceAccess:snap]]: status};
                    [ref updateChildValues:childUpdates];
                }
            }
        }];
    }
}

@end
