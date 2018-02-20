//
//  AppDelegate.h
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "HJObjManager.h"
#import "Configs.h"
#import "Profiles.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) HJObjManager *obj_Manager;
@property (strong, nonatomic) FIRDatabaseReference *ref;


// @property (strong, nonatomic) NSMutableDictionary *friendsProfile;
/*
 การ Observe Event friends ทั้งหมด
 */
- (void)onAddObserveFirebase;

/*
 การ Observe Event friends ทั้งหมด
 */
- (void)onRemoveObserveFirebase;


/*
 force logout
 */
- (void)forceLogout;


- (void)initMainView;


/*
 update ข้อมูล Profile
 */
- (void)updateProfile:(NSDictionary*)data;

/*
 เป็นการ update ข้อมูลของเพือน
 */
- (void)updateFriend:(NSString *)friend_id:(NSDictionary *)data;

/*
 เป็นการ update ข้อมูลโปรไฟล์ของเพือน
 */
- (void)updateProfileFriend:(NSString *)friend_id:(NSDictionary *)data;

/*
 เป็นการ update ข้อมูลของกลุ่ม
 */
- (void)updateGroup:(NSString *)group_id:(NSDictionary *)data;

/*
 เป็นการ update Class
 */
- (void)updateClasss:(NSString* )item_id :(NSDictionary *)data;

/*
 เป็นการ update MyApplications
 */
-(void)updateMyApplications:(NSString* )app_id :(NSDictionary *)data;

/*
 เป็นการ update Following : คือ application  ทีเราไปกด follow ไว้
 */
-(void)updateFollowing:(NSString* )item_id :(NSDictionary *)data;

/*
 เป็นการ update Center
 */
-(void)updateCenter:(NSString* )item_id :(NSDictionary *)data;

/*
 เป็นการ update Slide Show
 */
-(void)updateSlideShow:(NSString* )item_id :(NSDictionary *)data;
@end

