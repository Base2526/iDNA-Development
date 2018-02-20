//
//  Configs.m
//  lottery
//
//  Created by somkid simajarn on 8/14/2558 BE.
//  Copyright (c) 2558 bit. All rights reserved.
//

#import "Configs.h"
#import <sys/utsname.h>
#import "SAMKeychain.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "FriendProfileRepo.h"
#import "Profiles.h"
#import "ProfilesRepo.h"
#import "Friends.h"
#import "FriendsRepo.h"
#import "MyApplications.h"
#import "MyApplicationsRepo.h"
#import "Following.h"
#import "FollowingRepo.h"
#import "Classs.h"
#import "ClasssRepo.h"
#import "UIDeviceHardware.h"
#import "Utility.h"
#import "ProfilesRepo.h"

@implementation Configs{
    ProfilesRepo *profilesPepo;
}

+ (Configs *)sharedInstance
{
    static Configs *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[Configs alloc] init];
        
        return sharedInstance;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        // sindex.php
        // Distribution
        // self.API_URL            = @"http://128.199.210.45";
        
        
        
// https://stackoverflow.com/questions/37472090/in-new-firebase-how-to-use-multiple-config-file-in-xcode
#ifdef DEBUG
        // Development
        self.API_URL            = @"http://188.166.208.70";
#else
        // Distribution
        self.API_URL            = @"http://128.199.210.45";
#endif
        
        self.END_POINT          = @"/api";
        
        self.FIREBASE_ROOT_PATH    = @"idna/";
        self.FIREBASE_DEFAULT_PATH = @"idna/user/";
        
        // v1.0 login by name
        self.USER_LOGIN         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/login"];

        self.USER_REGISTER      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user/register"];
        // user/request_new_password.json
        self.USER_REQUEST_NEW_PASSWORD = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user/request_new_password"];
        self.USER_LOGOUT        = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/logout"];
        self.USER_FORGOT_PASSWORD = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_forgot_password"];
        
        
        /*
        self.LIST_ARTICLE       = @"/service_heart/list_article.json?_format=json";
        self.ADD_ARTICLE        = @"/service_heart/add_article.json?_format=json";
        self.EDIT_ARTICLE       = @"/service_heart/edit_article.json?_format=json";
        self.DELETE_ARTICLE     = @"/service_heart/delete_article.json?_format=json";
        
        self.DEVICE_PUSH_NOTIFICATION   = @"/service_heart/device_push_notification.json?_format=json";
        
        self.FRIEND_RECOMMENDATION      = @"/service_heart/list_friend_recommendation";
        */
        
        self.FETCH_MY_PROFILE   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/basic_fetch_profile"];// @"/service_heart/klovers_fetch_profile";
        self.UPDATE_MY_PROFILE  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_my_profile"];
        /*
        self.FETCH_MY_APP   = @"/service_heart/klovers_fetch_my_app";
        self.UPDATE_MY_APP  = @"/service_heart/klovers_update_my_app";
        
        self.PUBLIC_RELATIONS  = @"/sati_endpoint/sati_public_relations"; //
        //
        self.PHOTO_GALLERY = @"/sati_endpoint/sati_photo_gallery";
        
        // firebase
        // self.API_URL_FIREBASE               = @"https://blazing-torch-6635.firebaseio.com/heart";
        self.API_URL_FIREBASE_USER_LOGIN    = @"user_login";
        self.API_URL_FIREBASE_USER_FRIEND   = @"user_friend";
        self.API_URL_FIREBASE_SEND_HEART    = @"send_heart";
         */
        
        self.USER_FRINEDS           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_friends"];
        self.USER_FRINEDS_HEART     = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_friends_heart"];
        self.ADD_FRINEDS            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/add_friend"];
        self.ADD_LIST_FRINEDS       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/list_friends"];
        self.SEND_HEART_TO_FRINEDS  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/send_heart_to_friends"];
        self.ACCEPT_FRIEND          = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/accept_friend"];
        self.NOT_ACCEPT_FRIEND      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/not_accept_friend"];
        
        self.FIND_FRIEND   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/find_friend"];
        self.PEOPLE_YOU_MAY_KNOW    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/people_you_may_know"];
        self.EDIT_DISPLAY_NAME      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_display_name"];
        self.EDIT_FRIEND_DISPLAY_NAME = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_friend_display_name"];
        self.UPDATE_PICTURE_PROFILE = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_picture_profile"];
        
        self.UPDATE_PICTURE_BG      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_picture_bg"];
        self.EDIT_PHONE             = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_phone_v1_0"];
        self.EDIT_MULTI_PHONE       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_multi_phone"];
        self.EDIT_MULTI_EMAIL       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_multi_email"];
        
        self.TURN_OFF_NOTIFICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/turn_off_notifications"];
        self.HIDE_FRIEND            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/hide_friend"];
        self.CANCEL_WAIT_TO_ACCEPT  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/cancel_wait_to_accept"];
        
        self.EDIT_STATUS_MESSAGE    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_status_message"];
        
        self.SET_MY_ID              = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/set_my_id"];
        self.DELETE_FRIEND          = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_friend"];
        self.SET_CLASS_FRIEND       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/set_class_friend"];
        self.ANNMOUSU               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu"];
        self.ANNMOUSU_REGISTER      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu_register"];
        self.ANNMOUSU_VERIFY        = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu_verify"];
        
        self.SHBY_CLASS             = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/shby_class"];
        
        self.UPDATE_NEW_PASSWORD    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_new_password"];
        
        
        self.CREATE_MY_CARD         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_my_card"];
        self.CREATE_MY_APPLICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_my_application"];
        self.DELETE_MY_APPLICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_my_application"];
        self.UPDATE_MY_APPLICATION_PROFILE = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_my_application_profile"];
        self.AED_POST               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/AED_post"];
        
        self.ADD_POST               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/add_post"];
        self.EDIT_POST               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_post"];
        self.DELETE_POST            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_post"];
        
        self.ADD_COMMENT           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/center_post_add_comments"];
        
        self.APPLICATION_CATEGORY   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/application_category"];
        self.TOKEN_NOTICATION       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/token_notication"];
        
        self.GET_STORE              = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_store"];
        self.GET_APP_DETAIL         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_app_detail"];
        
        self.GET_PROFILES           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_profiles"];
        
        self.CREATE_GROUP_CHAT      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_group_chat"];
        
        self.DELETE_GROUP_CHAT      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_group_chat"];
        
        self.GROUP_INVITE_NEW_MEMBERS = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/group_invite_new_members"];
        
        self.CREATE_MUTI_CHAT       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_muti_chat"];
        
        self.MUTI_CHAT_INVITE_NEW_MEMBERS       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/muti_chat_invite_new_members"];
        
        self.UPDATE_PICTURE_GROUP   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_picture_group"];
        
        self.CREATE_CLASS           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_class"];
        
        self.GET_GENDER             = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_gender"];
        
        self.RECREATE_QRCODE        = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/recreate_qrcode"];
    
        self.kBarHeight = 50.0f;
        
        self.navigationBarHeight = 30.0f;
        
        self.timeOut    = 100.0f;
        
        self.DBFileName = @"db.sql";
        
    }
    return self;
}

/*
 เช็กว่า user login หรือไม่
 */
-(BOOL)isLogin{
    if (![self getUIDU]){
        return false;
    }
    return true;
}

/*
 ดึง UID User
 */
-(NSString *)getUIDU{
    
    NSDictionary *u = [self loadData:_USER];
    return [u objectForKey:@"user"][@"uid"];
}

/*
 ดึง token user
 */
-(NSString *)getUToken{
    return [[Configs sharedInstance] loadData:_USER][@"token"];
}

/*
 เราต้อง add header ตอน request http api ทุกครั้งเพือเช็ดค่าอะไรบ้างว่าเป้นการเรียกจาก device
 Refer : https://tetontech.wordpress.com/2009/02/28/detecting-device-information-on-the-iphone/
 */
-(NSMutableURLRequest *)setURLRequest_HTTPHeaderField:(NSURL *)url{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[Configs sharedInstance].timeOut];
    
    /*
     version-osx
     */
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"version_os"];
    
    /*
     */
    [request setValue:[[UIDevice currentDevice] systemName] forHTTPHeaderField:@"system_name"];
    
    /*
     device name
     
     NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
     NSString *base64String = [plainData base64EncodedStringWithOptions:0];
     */
    
    // Create NSData object
    NSData *nsdata = [[[UIDevice currentDevice] name]
                      dataUsingEncoding:NSUTF8StringEncoding];

    // Get NSString from NSData object in Base64
    NSString *name64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    // NSLog(@"Encoded: %@", name64Encoded);
    [request setValue:name64Encoded forHTTPHeaderField:@"device_name"];
    
    /*
     ดึง Bundle identifier
     Ex. heart.idna
     */
    [request setValue:[self getBundleIdentifier] forHTTPHeaderField:@"bundle_identifier"];
    
    /*
     Platform
     */
    [request setValue:@"ios" forHTTPHeaderField:@"platform"];
    
    /*
     ดึง Version Application
     Ex. 1.0
     */
    [request setValue:[self getVersionApplication] forHTTPHeaderField:@"version_application"];
    
    /*
     device udid
     */
    [request setValue:[self getUniqueDeviceIdentifierAsString] forHTTPHeaderField:@"udid"];
    
    // NSLog(@"%@", [request allHTTPHeaderFields]);
    /*
     Model Number
     https://stackoverflow.com/questions/11197509/how-to-get-device-make-and-model-on-ios
     */
    [request setValue:[self modelNumber] forHTTPHeaderField:@"model_number"];
    
    // build version
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [request setValue:build forHTTPHeaderField:@"build"];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

-(NSString *)getUniqueDeviceIdentifierAsString
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SAMKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SAMKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    
    return strApplicationUUID;
}

-(BOOL) NSStringIsValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)NSStringIsValidPhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}
    
- (NSString *) modelNumber{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void)registerForRemoteNotifications
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}

-(NSString *)pathCacheArchiver:(NSString *)fname
{
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,   NSUserDomainMask, YES);
//    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
//    NSString *documentsResourcesPath = [documentPath  stringByAppendingPathComponent:@"MyAppCache"];
//    
//    NSString *fullPath = [documentsResourcesPath stringByAppendingPathComponent:@"file-heart.data"];
    
    NSString *documentdictionary;
    NSArray *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdictionary = [Path objectAtIndex:0];
    documentdictionary = [documentdictionary stringByAppendingPathComponent:@"Cache/"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentdictionary]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentdictionary withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *fullPath = [documentdictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", fname]];
    
    return fullPath;
}

-(BOOL)saveData:(NSString *)filename :(NSMutableDictionary *)data
{
    if (![NSKeyedArchiver archiveRootObject:data toFile:[self pathCacheArchiver:filename]])
    {
        return NO;
    }else{
        
        /* save เพิ่ม share ไปที่ Extension
         _DATA
         
         Try this:
         
         You can use NSKeyedArchiver to write out your dictionary to an NSData, which you can store among the preferences.
         
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.selectedOptionPositions];
         [[NSUserDefaults standardUserDefaults] setObject:data forKey:PREF_OPTIONS_KEY];
         
         For retrieving data:
         NSData *dictionaryData = [defaults objectForKey:PREF_OPTIONS_KEY];
         NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        */
        
        if ([filename isEqualToString:_DATA] || [filename isEqualToString:_USER]) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // do your task here
                
                if([filename isEqualToString:_DATA]){
                    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
                    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"data"];
                    [userDefaults synchronize];
                }else if([filename isEqualToString:_USER]){
                    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
                    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"user"];
                    [userDefaults synchronize];
                }

            });
        }
        
        return TRUE;
    }
}

-(NSMutableDictionary *)loadData:(NSString *)filename
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathCacheArchiver:filename]]) {
        return nil;
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[self pathCacheArchiver:filename]];
        return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)removeData:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:[self pathCacheArchiver:filename] error:&error];
    if (success) {
        NSLog(@"> removeData %@", filename);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

/*
 ดึง Bundle identifier
 Ex. heart.idna
 */
-(NSString *)getBundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

/*
 ดึง Version Application
 Ex. 1.0
 */
-(NSString *)getVersionApplication
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/*
 จะ Sync ข้อมูลใหม่ทุกครั่งที่ login โดยจะดึงข้อมูลทั้งหมดจะ firebase ของ user login
 */
-(void)synchronizeData{
    NSMutableArray *childObservers = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
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
         
            // MyApplicationsRepo *myAppRepo = [[MyApplicationsRepo alloc] init];
            for (NSString* key in my_applications) {
                NSDictionary* val = [my_applications objectForKey:key];
                
                /*
                MyApplications *myApp = [[MyApplications alloc] init];
                myApp.app_id = key;
                
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:val options:0 error:&err];
                myApp.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                myApp.create    = [timeStampObj stringValue];
                myApp.update    = [timeStampObj stringValue];
                
                BOOL sv = [myAppRepo insert:myApp];
                */
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateMyApplications:key :val];
            }
        }
        // #2 ส่วนของ my_applications
        
        // #3 ส่วนของ following
        if ([value objectForKey:@"following"] != nil) {
            NSDictionary *following = [value objectForKey:@"following"];
            
            FollowingRepo *followingRepo = [[FollowingRepo alloc] init];
            for (NSString* key in following) {
                NSDictionary* val = [following objectForKey:key];
                
                /*
                Following *fw = [[Following alloc] init];
                fw.item_id = key;
                
                NSError * err;
                NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:val options:0 error:&err];
                fw.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
                fw.create    = [timeStampObj stringValue];
                fw.update    = [timeStampObj stringValue];
                
                BOOL sv = [followingRepo insert:fw];
                */
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFollowing:key :val];
            }
        }
        // #3 ส่วนของ following
        
        // #4 ส่วนของ classs
        if ([value objectForKey:@"classs"] != nil) {
            NSDictionary *classs = [value objectForKey:@"classs"];
            
            ClasssRepo *classsRepo = [[ClasssRepo alloc] init];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeData" object:self userInfo:@{}];
            return;
        }
        
        FriendsRepo *friendsRepo = [[FriendsRepo alloc] init];
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
                
                // [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] setObject:snapshot.value forKey:parent];
                
                // [self saveData:parent :snapshot.value];
                
                if (snapshot.value == (id)[NSNull null]){
                    return;
                }
                
                FriendProfileRepo *friendProfileRepo = [[FriendProfileRepo alloc] init];
                
                if (![friendProfileRepo check:parent]) {
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfileFriend:parent :snapshot.value];
                }
                
                // จะออกก็ต่อเมือดึงข้อมูล ถึงคนสุดท้ายเท่านั้น
                if (friends.count == count) {
                    for (FIRDatabaseReference *ref in childObservers) {
                        [ref removeAllObservers];
                    }
                    
                    // [[Configs sharedInstance] saveData:_PROFILE_FRIENDS :[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile]];
                    NSArray *friendAll = [friendsRepo getFriendsAll];
                    NSArray *fprofileAll = [friendProfileRepo getFriendProfileAll];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeData" object:self userInfo:@{}];
                }
            }];
        }
        
        // #5 ส่วนข้อมูลของ friends & profile friend
    }];
}
    
-(NSString *)getIDDeviceAccess:(FIRDataSnapshot *)snap{    
    for (NSString* key in snap.value) {
        NSDictionary* val = [snap.value objectForKey:key];
        if([[val objectForKey:@"udid"] isEqualToString:[self getUniqueDeviceIdentifierAsString]]){
            return key;
        }
    }
    return @"";
}

/*
 ดึง Profile User
 */
-(NSMutableDictionary *)getUserProfiles{
    profilesPepo = [[ProfilesRepo alloc] init];
    
    NSArray *pf = [profilesPepo get];
    NSData *data =  [[pf objectAtIndex:[profilesPepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data == nil) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}




//-(void)synchronizeLogout{
//    for (FIRDatabaseReference *ref in childObservers) {
//        [ref removeAllObservers];
//    }
//}

/*
 ดึงค่าความสูงของ Tabbar //const CGFloat kBarHeight = 50;
 */


/*
 [[SVProgressHUD appearance] setHudBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
 //[[SVProgressHUD appearance] setHudForegroundColor:[UIColor yellowColor]];
 [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
 [self showImage:[[self sharedView] hudSuccessImage] status:string];
 
 -(void)SVProgressHUD_ShowWithStatus:(NSString *)message;
 -(void)SVProgressHUD_ShowErrorWithStatus:(NSString *)message;
 */

//-(void)showSuccessWithStatus:(NSString *)string {
//
//}

/*
 Custom SVProgressHUD
 refer : http://stackoverflow.com/questions/16932624/change-bg-color-of-svprogesshud-in-objective-c
 */
-(void)SVProgressHUD_ShowWithStatus:(NSString *)message{
    /*
    // [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor yellowColor]];
    [[SVProgressHUD appearance] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
    [SVProgressHUD showSuccessWithStatus:message];
    */
    /*
    [[SVProgressHUD appearance] setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
    //[[SVProgressHUD appearance] setHudForegroundColor:[UIColor yellowColor]];
    [[SVProgressHUD appearance] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
    // [self showImage:[[self sharedView] hudSuccessImage] status:string];
     */

    
    [SVProgressHUD showWithStatus:message];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

-(void)SVProgressHUD_ShowSuccessWithStatus:(NSString *)message{
    [SVProgressHUD showSuccessWithStatus:message];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)SVProgressHUD_ShowErrorWithStatus:(NSString *)message{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", message]];
    
    // Delay execution of my block for 2 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

-(void)SVProgressHUD_Dismiss{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

/*
 FIRDatabaseReference *ref = [[FIRDatabase database] reference];
 
 NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
 
 __block NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/", [preferences objectForKey:_UID], [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]];
 
 [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
 
 NSLog(@"%@", snapshot.value);

}];

 */
@end
