//
//  ContactsViewController.m
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.

#import "Tab_Contacts_Friend.h"
#import "ViewControllerCell.h"
#import "ViewControllerCellHeader.h"
#import "ProfileTableViewCell.h"
#import "FriendTableViewCell.h"
#import "GroupTableViewCell.h"
#import "CreateGroup.h"
#include <stdlib.h>
#import "Configs.h"
#import "AppConstant.h"
#import "AnNmousUThread.h"
#import "AppDelegate.h"
#import "UserDataUILongPressGestureRecognizer.h"
#import "UserDataUIAlertView.h"
#import "MyProfile.h"
#import "Changefriendsname.h"
#import "ManageGroup.h"
#import "FriendProfile.h"
#import "FriendProfileRepo.h"
#import "FriendProfileView.h"
#import "ChatWall.h"
#import "GroupChatRepo.h"
#import "GroupChat.h"
#import "Tab_Home.h"
#import "FriendsRepo.h"
#import "ProfilesRepo.h"
#import "AddFriend.h"
#import "ChatViewController.h"
#import "FriendRequestCell.h"
#import "FriendWaitForAFriendCell.h"
#import "CustomTapGestureRecognizer.h"

@interface Tab_Contacts_Friend ()<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrSelectedSectionIndex;
    BOOL isMultipleExpansionAllowed;
    NSMutableDictionary *all_data;
    
    NSMutableArray* friendsProfile;
    
    FriendProfileRepo *friendProfileRepo;
    FriendsRepo *friendsRepo;
    GroupChatRepo *groupChatRepo;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width
@end

@implementation Tab_Contacts_Friend
@synthesize ref;

#pragma mark - View Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];

    ref             = [[FIRDatabase database] reference];
    all_data        = [[NSMutableDictionary alloc] init];
    friendsProfile  = [[NSMutableArray alloc] init];
    
    friendsRepo         = [[FriendsRepo alloc] init];
    friendProfileRepo   = [[FriendProfileRepo alloc] init];
    groupChatRepo       = [[GroupChatRepo alloc] init];
    
    /*
     // 0 : Profile
     // 1 : Groups
     // 2 : Favorites
     // 3 : Friends
     // 4 : Friend Requests มีคำขอเป็นเพือน จะต้องแสดง Confirm, Delete
    */
    // [all_data setObject:@[@"profile-Red"] forKey:@"profile"];
    // [all_data setObject:@[@"groups-Red", @"groups-Yellow"] forKey:@"groups"];
    // [all_data setObject:@[@"favorites-Red", @"favorites-Yellow"] forKey:@"favorites"];
    // [all_data setObject:@[@"friends-Red", @"friends-Yellow", @"friends-Yellow", @"friends-Yellow"] forKey:@"friends"];
    
    //Set isMultipleExpansionAllowed = true is multiple expanded sections to be allowed at a time. Default is NO.
    isMultipleExpansionAllowed = YES;
    
    arrSelectedSectionIndex = [[NSMutableArray alloc] init];
    
    // if (!isMultipleExpansionAllowed) {
    //    [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:count+2]];
    // }
    
    for (int i=0; i< 5; i++) {
        // เป็นการจะให้ section ได้ open โดยเราจะต้อง add section index
        [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:i]];
    }
    
    [tblView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTableViewCell"];
    [tblView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    [tblView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupTableViewCell"];
    [tblView registerNib:[UINib nibWithNibName:@"FriendRequestCell" bundle:nil] forCellReuseIdentifier:@"FriendRequestCell"];
    [tblView registerNib:[UINib nibWithNibName:@"FriendWaitForAFriendCell" bundle:nil] forCellReuseIdentifier:@"FriendWaitForAFriendCell"];

    
    // FIRTrace *trace = [FIRPerformance startTraceWithName:@"test trace"];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_FRIEND
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_GROUP
                                               object:nil];
    
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FRIEND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_GROUP object:nil];
}

/*
// กลับจากการ ดึงข้อมูลของ user
-(void)synchronizeData:(NSNotification *) notification{
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    
   //  [(AppDelegate *)[[UIApplication sharedApplication] delegate] observeEventType];
    
    [self reloadData:nil];
    // [tblView reloadData];
    
    [tblView setHidden:NO];
}
*/

/*
 Type DATA
 -profiles           : profile ของผู้ใช้งาน
 -favorite friends   : friends ที่เราชื่นชอบ
 -friends            : เพื่อนทั้งหมด
 -groups             : กลุ่ม Chat
 -multi_chat         : คุยแบบไม่สร้างกลุ่ม
 -invite_groups       : กรณีมี เพื่อนเชิญเราเข้ากลุ่มสนทนา
 -invite_multi_chat  : กรณีมี เพื่อนเชิญเราเข้าสนทนา
 -recents            :  เก็บข้อมูลล่าสุดที่เราคุย กับเพือน กลุ่ม หรือ multi chat
 */
-(void)reloadData:(NSNotification *) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [[Configs sharedInstance] saveData:_DATA :newDict];
        
        [all_data removeAllObjects];
        
        // #1 profile
        NSDictionary *profile = [[Configs sharedInstance] getUserProfiles];
        [all_data setValue:profile forKey:@"profiles"];
        // #1 profile
        
        NSMutableArray * fs = [friendsRepo getFriendsAll];
        
        NSMutableDictionary *friends = [[NSMutableDictionary alloc] init];
        
        // สถานะรอการตอบรับคำขอเป้นเพือน
        NSMutableDictionary *friend_request = [[NSMutableDictionary alloc] init];
        
        // สถานะทีเราส่งคำขอเป้นเพือน
        NSMutableDictionary *friend_wait_for_a_friend = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            Boolean flag = true;
            if ([friend objectForKey:@"hide"]) {
                if ([[friend objectForKey:@"hide"] isEqualToString:@"1"]) {
                    flag = false;
                }
            }
            if ([friend objectForKey:@"block"]) {
                if ([[friend objectForKey:@"block"] isEqualToString:@"1"]) {
                    flag = false;
                }
            }
            
            /*
             #define _FRIEND_STATUS_FRIEND            @"10"
             #define _FRIEND_STATUS_FRIEND_CANCEL     @"13"
             #define _FRIEND_STATUS_FRIEND_REQUEST    @"11"
             #define _FRIEND_STATUS_WAIT_FOR_A_FRIEND @"12"
             */
            
            // สถานะรอการตอบรับคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    if ([[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND_REQUEST]) {
                        [friend_request setObject:val forKey:friend];
                    }
                    flag = false;
                }
            }
            
            // สถานะทีเราส่งคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    if ([[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_WAIT_FOR_A_FRIEND]) {
                        [friend_wait_for_a_friend setObject:val forKey:friend];
                    }
                    flag = false;
                }
            }
            
            if (flag) {
                [friends setObject:friend forKey:friend_id];
            }
        }
        
        // #2 favorite
        NSMutableDictionary *favorites = [[NSMutableDictionary alloc] init];
        for (NSString* key in friends) {
            NSMutableDictionary* value = [friends objectForKey:key];
            if ([value objectForKey:@"favorite"]) {
                NSString* is_favorite = [value objectForKey:@"favorite"];
                if ([is_favorite isEqualToString:@"1"]) {
                    [favorites setObject:value forKey:key];
                }
            }
        }
        [all_data setValue:favorites forKey:@"favorite"];
        // #2 favorite
        
        // #3 friends
        [all_data setValue:friends forKey:@"friends"];
        // #3 friends
        
        
        // #4 groups
        /*
        NSMutableArray* groupChat_All =  [groupChatRepo getGroupChatAll];
        NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
        for (int i = 0; i<[groupChat_All count]; i++) {
            NSArray* group = [groupChat_All objectAtIndex:i];
            
            NSString* group_id = [group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
            NSData *data = [group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
            
            [groups setObject:data forKey:group_id];
        }
        
        [all_data setValue:groups forKey:@"groups"];
        */
        [all_data setValue:[[NSMutableDictionary alloc] init] forKey:@"groups"];
        
        // #4 groups
        
        // #5 Friend REQUEST
        [all_data setValue:friend_request forKey:_FRIEND_STATUS_FRIEND_REQUEST];
        // #5 Friend REQUEST
        
        // #6 Friend WAIT_FOR_A_FRIEND
        [all_data setValue:friend_wait_for_a_friend forKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
        // #6 Friend WAIT_FOR_A_FRIEND
        
        /*
         Updating data for UITableView in background breaks animations
         https://stackoverflow.com/questions/10831313/updating-data-for-uitableview-in-background-breaks-animations
         */
        [tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        [friendsProfile removeAllObjects];
        friendsProfile = [friendProfileRepo getFriendProfileAll];
        
        [tblView reloadData];
    });
}

#pragma mark - TableView methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return all_data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
        /* กรณีที่เรา click open section แล้วจะ return จำนวน item */
        switch (section) {
                // profile
            case 0:{
                return 1;
            }
                // groups
            case 1:{
                NSMutableArray *groups = [all_data valueForKey:@"groups"];
                return  [groups count];
                
            }
                // favorites
            case 2:{
                NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
                return  [favorite count];
            }
                // friends
            case 3:{
                NSMutableArray *friends = [all_data valueForKey:@"friends"];
                return  [friends count];
            }
                // friend_request
            case 4:{
                NSMutableArray *friend_request = [all_data valueForKey:_FRIEND_STATUS_FRIEND_REQUEST];
                return  [friend_request count];
            }
                
            case 5:{
                NSMutableArray *friend_wait_for_a_friend = [all_data valueForKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
                return  [friend_wait_for_a_friend count];
            }
                default:
                return 0;
        }
    }else{
        /* กรณีที่เรา click close section แล้วจะ return 0 */
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44.0f;
    }else if(section == 1){
        NSMutableArray *groups = [all_data valueForKey:@"groups"];
        if([groups count] == 0){
            return 0;
        }
    }else if(section == 2){
        NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
        if([favorite count] == 0){
            return 0;
        }
    }else if(section == 3){
        NSMutableArray *friends = [all_data valueForKey:@"friends"];
        if([friends count] == 0){
            return 0;
        }
    }else if(section == 4){
        NSMutableArray *friend_request = [all_data valueForKey:_FRIEND_STATUS_FRIEND_REQUEST];
        if([friend_request count] == 0){
            return 0;
        }
    }else if(section == 5){
        NSMutableArray *friend_wait_for_a_friend = [all_data valueForKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
        if([friend_wait_for_a_friend count] == 0){
            return 0;
        }
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        case 1:
        case 4:
        case 5:
            return 100.0f;
        default:
            return 140.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ViewControllerCellHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    if (headerView ==nil){
        [tblView registerClass:[ViewControllerCellHeader class] forCellReuseIdentifier:@"ViewControllerCellHeader"];
        headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    }
    
    switch (section) {
            // 0 : Profile
        case 0:{
            headerView.lbTitle.text = @"Profile";
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            //            [[headerView btnShowHide] setTag:section];
            //            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            
            [[headerView btnShowHide] setHidden:YES];
            
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
            
            // 1 : Groups
            // 2 : Favorites
            // 3 : Friends
        case 1:{
            
            NSMutableArray *groups = [all_data valueForKey:@"groups"];
            
            headerView.lbTitle.text = [NSString stringWithFormat:@"Groups (%ld)", [groups count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
        case 2:{
            
            NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Favorites (%ld)", [favorite count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
            
        case 3:{
            NSMutableArray *friends = [all_data valueForKey:@"friends"];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Friends (%ld)", [friends count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
            
        case 4:{
            NSMutableArray *friend_request = [all_data valueForKey:_FRIEND_STATUS_FRIEND_REQUEST];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Friend Request (%ld)", [friend_request count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
        case 5:{
            NSMutableArray *friend_request = [all_data valueForKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Friend Request Sent (%ld)", [friend_request count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
            
        default:{
            headerView.lbTitle.text = [NSString stringWithFormat:@"Section %ld", (long)section];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSectionButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
            
            //The setup code (in viewDidLoad in your view controller)
            CustomTapGestureRecognizer *singleFingerTap = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapShowHideSection:)];
            
            singleFingerTap.object = headerView.btnShowHide;
            
            [headerView.contentView setTag:section];
            [headerView.contentView addGestureRecognizer:singleFingerTap];
        }
            break;
    }
    return headerView.contentView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSDictionary *data = [[Configs sharedInstance] loadData:_DATA];
    if (indexPath.section == 0) {
        
        ProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *profiles = [all_data objectForKey:@"profiles"];
        if ([profiles objectForKey:@"image_url"]) {
            [cell.imgPerson clear];
            [cell.imgPerson showLoadingWheel];
            [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
        }else{}
        
        cell.lblName.text = [NSString stringWithFormat:@"%@-%@",[profiles objectForKey:@"name"] , [Configs sharedInstance].getUIDU];
        
        if ([profiles objectForKey:@"status_message"]) {
            cell.lblStatusmessage.text = [profiles objectForKey:@"status_message"];
        }else{
            cell.lblStatusmessage.text = @"";
        }
        
        UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
        
        lpgr.userData = indexPath;
        // lpgr.minimumPressDuration = 1.0; //seconds
        [cell addGestureRecognizer:lpgr];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }else{
        FriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        
        switch (indexPath.section) {
            case 1:{
                // @"Groups";
                GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
                
                NSMutableDictionary *groups = [all_data objectForKey:@"groups"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [groups allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [groups objectForKey:key];
                    [sortedValues addObject:object];
                }
                ////---sort
            
                NSData *data =  [[sortedValues objectAtIndex:indexPath.row] dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *item = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([item objectForKey:@"image_url"]) {
                    [cell.imageV clear];
                    [cell.imageV showLoadingWheel]; // API_URL
                    [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
                }else{
                    [cell.imageV clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"name"], [sortedKeys objectAtIndex:indexPath.row] ] ;
                // cell.lblMember.text = [NSString stringWithFormat:@"%@", [(NSDictionary *)[item objectForKey:@"members"] count] ] ;
                NSDictionary * member= [item objectForKey:@"members"];
                cell.lblMember.text = [NSString stringWithFormat:@"%d people", [member count]];
                
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                lpgr.userData = indexPath;
                [cell addGestureRecognizer:lpgr];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case 2:{
                // @"Favorite"
                NSMutableDictionary *favorite = [all_data objectForKey:@"favorite"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [favorite allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [favorite objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                NSMutableDictionary *f = [self getProfileFriend:[sortedKeys objectAtIndex:indexPath.row]];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], [sortedKeys objectAtIndex:indexPath.row]] ;
                
                cell.lblChangeFriendsName.text = @"";
                if ([item objectForKey:@"change_friends_name"]) {
                    cell.lblChangeFriendsName.text = [item objectForKey:@"change_friends_name"];
                }
                
                cell.lblOnline.text = @"NO";
                if([self checkIsOnline:f]){
                    cell.lblOnline.text = @"YES";
                }
                
                cell.lblStatusMessage.text = @"";
                if ([f objectForKey:@"status_message"]) {
                    cell.lblStatusMessage.text = [f objectForKey:@"status_message"];
                }
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
            case 3:{
                // @"Friends";
                NSMutableDictionary *friends = [all_data objectForKey:@"friends"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [friends allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [friends objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
        
                NSMutableDictionary *f = [self getProfileFriend:[sortedKeys objectAtIndex:indexPath.row]];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], [sortedKeys objectAtIndex:indexPath.row]] ;
                
                cell.lblChangeFriendsName.text = @"";
                if ([item objectForKey:@"change_friends_name"]) {
                    cell.lblChangeFriendsName.text = [item objectForKey:@"change_friends_name"];
                }
                
                cell.lblOnline.text = @"NO";
                if([self checkIsOnline:f]){
                    cell.lblOnline.text = @"YES";
                }
                
                cell.lblStatusMessage.text = @"";
                if ([f objectForKey:@"status_message"]) {
                    cell.lblStatusMessage.text = [f objectForKey:@"status_message"];
                }
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
            case 4:{
                FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];

                NSMutableDictionary *friend_request = [all_data objectForKey:_FRIEND_STATUS_FRIEND_REQUEST];
                
                NSArray *keys = [friend_request allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSArray *val = [friend_request objectForKey:key];
                
                NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
                
                NSMutableDictionary *f = [self getProfileFriend:friend_id];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imageV clear];
                    [cell.imageV showLoadingWheel]; // API_URL
                    [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
                }else{
                    [cell.imageV clear];
                }
                
                if ([f objectForKey:@"name"]) {
                    [cell.labelName setText:[f objectForKey:@"name"]];
                }
                
                UITapGestureRecognizer *singleBtnConfirmTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleBtnConfirmTap:)];
                
                cell.btnConfirm.tag = indexPath.row;
                [cell.btnConfirm addGestureRecognizer:singleBtnConfirmTap];
                
                UITapGestureRecognizer *singleBtnDeleteRequestTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleBtnDeleteRequestTap:)];
                
                cell.btnDeleteRequest.tag = indexPath.row;
                [cell.btnDeleteRequest addGestureRecognizer:singleBtnDeleteRequestTap];
                
                return cell;
            }
            case 5:{
                FriendWaitForAFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendWaitForAFriendCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"FriendWaitForAFriendCell"];
                
                NSMutableDictionary *friend_request = [all_data objectForKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
                
                NSArray *keys = [friend_request allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSArray *val = [friend_request objectForKey:key];
                
                NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
                
                NSMutableDictionary *f = [self getProfileFriend:friend_id];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imageV clear];
                    [cell.imageV showLoadingWheel]; // API_URL
                    [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
                }else{
                    [cell.imageV clear];
                }
                
                if ([f objectForKey:@"name"]) {
                    [cell.labelName setText:[f objectForKey:@"name"]];
                }
                
                UITapGestureRecognizer *singleBtnDeleteRequestTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(handleSingleBtnCancelRequestTap:)];
                
                cell.btnCancelRequest.tag = indexPath.row;
                [cell.btnCancelRequest addGestureRecognizer:singleBtnDeleteRequestTap];
                
                return cell;
            }
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

//The event handling method
- (void)handleSingleBtnConfirmTap:(UITapGestureRecognizer *)recognizer{
    NSMutableDictionary *friend_request = [all_data objectForKey:_FRIEND_STATUS_FRIEND_REQUEST];
    
    NSArray *keys = [friend_request allKeys];
    id key = [keys objectAtIndex:[recognizer.view tag]];
    NSArray *val = [friend_request objectForKey:key];
    NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
    /*
     การ udpate status ให้ status friend = _FRIEND_STATUS_FRIEND{ยอมรับการเป้นเพือน}
     1. เราต้อง udpate status friend ของ เรา
     2. เราต้องวิ่งไป update friend ขอเพือนทีเราเป็นเพือนด้วย {เราย้ายไปทำทีหลังบ้านแทน function user_for_friend_editupdate}
     */
    
    // 1. เราต้อง udpate status friend ของ เรา
    NSString *child = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
    
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/status/", child, friend_id]: _FRIEND_STATUS_FRIEND};
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            
            // 2. เราต้องวิ่งไป update friend ขอเพือนทีเราเป็นเพือนด้วย
            NSString *child2 = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], friend_id];
            
            NSDictionary *childUpdates2 = @{[NSString stringWithFormat:@"%@%@/status/", child2, [[Configs sharedInstance] getUIDU]]: _FRIEND_STATUS_FRIEND};
            [ref updateChildValues:childUpdates2 withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error == nil) {
                    
                    NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
                    
                    if ([newDict objectForKey:@"status"]) {
                        [newDict removeObjectForKey:@"status"];
                    }
                    
                    [newDict setObject:_FRIEND_STATUS_FRIEND forKey:@"status"];
                    
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
                    
                    [self reloadData:nil];
                }else{
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[error description]];
                }
            }];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[error description]];
        }
    }];
}

- (void)handleSingleBtnCancelRequestTap:(UITapGestureRecognizer *)recognizer{
    NSMutableDictionary *friend_request = [all_data objectForKey:_FRIEND_STATUS_WAIT_FOR_A_FRIEND];
    
    NSArray *keys = [friend_request allKeys];
    id key = [keys objectAtIndex:[recognizer.view tag]];
    NSArray *val = [friend_request objectForKey:key];
    NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
    
    [self deleteFriend:friend_id];
}

- (void)handleSingleBtnDeleteRequestTap:(UITapGestureRecognizer *)recognizer{
    NSMutableDictionary *friend_request = [all_data objectForKey:_FRIEND_STATUS_FRIEND_REQUEST];
    
    NSArray *keys = [friend_request allKeys];
    id key = [keys objectAtIndex:[recognizer.view tag]];
    NSArray *val = [friend_request objectForKey:key];
    NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
    
    [self deleteFriend:friend_id];
}

-(void)deleteFriend:(NSString *)friend_id{
    NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], friend_id];
    
    [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error == nil) {
            // จะได้ friend_id
            NSString* key = [ref key];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // ลบ เพือน
                BOOL rs= [friendsRepo deleteFriend:key];
            
                // ลบ โปรไฟร์เพือน
                rs = [friendProfileRepo deleteFriendProfileById:key];
            });
       
            if (error == nil) {
                [self reloadData:nil];
            }else{
            }
        }
    }];
    
    child = [NSString stringWithFormat:@"%@%@/friends/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], friend_id, [[Configs sharedInstance] getUIDU]];
    
    [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error == nil) {
            // จะได้ Group id
            NSString* key = [ref key];
            
            if (error == nil) {
            }else{
            }
        }
    }];
}

//The event handling method
- (void)btnTapShowHideSection:(CustomTapGestureRecognizer *)recognizer
{
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    // NSLog(@"%d", [recognizer.view tag]);
    NSInteger tag = [recognizer.view tag];
    UIButton *sender = (UIButton*)recognizer.object;

    if (!sender.selected){
        if (!isMultipleExpansionAllowed) {
            [arrSelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:tag]];
        }else {
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:tag]];
        }
        sender.selected = YES;
    }else{
        sender.selected = NO;
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:tag]])
        {
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:tag]];
        }
    }
    if (!isMultipleExpansionAllowed) {
        [tblView reloadData];
    }else {
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(IBAction)btnTapShowHideSectionButton:(UIButton*)sender{
    if (!sender.selected){
        if (!isMultipleExpansionAllowed) {
            [arrSelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:sender.tag]];
        }else {
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        sender.selected = YES;
    }else{
        sender.selected = NO;
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
    }
    if (!isMultipleExpansionAllowed) {
        [tblView reloadData];
    }else {
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnBlock = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        /*
         section => 1 : Group
         section => 2 : Favorite
         section => 3 : Friends
         */
        switch (indexPath.section) {
            case 2:{
                // Favorite
                NSDictionary *favorite = [all_data objectForKey:@"favorite"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [favorite allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [favorite objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], [sortedKeys objectAtIndex:indexPath.row]];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"block"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                            }
                            flag = false;
                            break;
                        }
                    }
                
                    // กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/block/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                        
                        [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }
                }];
                NSLog(@"");
            }
                break;
            case 3:{
                // Friends
                NSDictionary *friends = [all_data objectForKey:@"friends"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [friends allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [friends objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], [sortedKeys objectAtIndex:indexPath.row]];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"block"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                            }
                            flag = false;
                            break;
                        }
                    }
                
                    // กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/block/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                        
                        [self updateBlockFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }
                }];
                NSLog(@"");
            }
                break;
                
            default:
                break;
        }
        
        [self reloadData:nil];
    }];
    btnBlock.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *btnHide = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Hide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // NSLog(@"Hide");
        // NSLog(@"--> %@", [NSString stringWithFormat:@"%d", indexPath.section]);
        
        switch (indexPath.section) {
            case 2:{
                // hide
                NSDictionary *favorite = [all_data objectForKey:@"favorite"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [favorite allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [favorite objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], [sortedKeys objectAtIndex:indexPath.row]];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"hide"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
                    // กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/hide/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                        
                        [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }
                }];
                
                NSLog(@"");
            }
                break;
            case 3:{
                // Friends
                NSDictionary *friends = [all_data objectForKey:@"friends"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [friends allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [friends objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], [sortedKeys objectAtIndex:indexPath.row]];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"hide"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                                
                                [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
                    // กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/hide/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                        
                        [self updateHideFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }
                }];
                
                NSLog(@"");
            }
                break;
                
            default:
                break;
        }
        
        [self reloadData:nil];
    }];
    btnHide.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"เป็นการทดสอบลบเพือน จะลบทั้งสองฝั่งเลย"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Delete", @"Close", nil];
                
        alert.userData = indexPath;
        alert.tag = 7;
        [alert show];
    }];
    btnDelete.backgroundColor = [UIColor orangeColor];
    
    return @[btnBlock, btnHide, btnDelete];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        case 1:{
            return NO;
        }
        default:
            return YES;
    }
}

-(void)handleLongPress:(UserDataUILongPressGestureRecognizer *)longPress{
    
    NSIndexPath * section = longPress.userData;
    
    if (section.section == 0) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded = %d", section.section);
        
        UserDataUIAlertView *alert =nil;
        switch (section.section) {
            case 1:{
                // Group
                alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Manage group", @"Delete Group", @"Chat", nil];
                
                alert.userData = section;
                alert.tag = 2;
                [alert show];
                break;
            }
            case 2:
            case 3:{
                // Favorite & Friends
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (section.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [idata allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [idata objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:section.row];
                ////---sort
                
                NSString*isFav = @"0";
                if ([item objectForKey:@"favorite"]) {
                    isFav = [item valueForKey:@"favorite"];
                }
                
                alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:[NSString stringWithFormat:@"Favorite : %@", isFav], @"Change friend's name", @"Friend Profile", @"Chat", nil];
                
                alert.userData = section;
                alert.tag = 1;
                [alert show];
                break;
            }
                
            case 4:{
                // Multi Chat
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Multi Chat"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Manage Multi Chat", @"Delete Multi Chat", nil];
                
                alert.userData = section;
                alert.tag = 4;
                [alert show];
            }
                break;
                
            case 5:{
                // Invite Group
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Invite Group"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Reject", @"Join", nil];
                
                alert.userData = section;
                alert.tag = 5;
                [alert show];
                NSLog(@"");
            }
                break;
            case 6:{
                // @"Invite Multi Chat";
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Invite Multi Chat"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Reject", @"Join", nil];
                
                alert.userData = section;
                alert.tag = 6;
                [alert show];
                NSLog(@"");
            }
                break;
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyProfile* profile = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
            [self.navigationController pushViewController:profile animated:YES];
        });

    }else if(indexPath.section == 1){
        // Groups
        NSMutableDictionary *groups = [all_data valueForKey:@"groups"];
        
        ////---sort เราต้องการเรียงก่อนแสดงผล
        NSArray *myKeys = [groups allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ManageGroup *manageGroup = [storybrd instantiateViewControllerWithIdentifier:@"ManageGroup"];
            manageGroup.group_id = [sortedKeys objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:manageGroup animated:YES];
        });
    }else if(indexPath.section == 2 || indexPath.section == 3){
        
        // ดึงข้อมูล
        NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
        switch (indexPath.section) {
            case 2:
            idata = [all_data objectForKey:@"favorite"];
            break;
            case 3:
            idata = [all_data valueForKey:@"friends"];
            break;
            
            default:
            break;
        }
        
        ////---sort เราต้องการเรียงก่อนแสดงผล
        NSArray *myKeys = [idata allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FriendProfileView* friendProfile = [storybrd instantiateViewControllerWithIdentifier:@"FriendProfileView"];
            friendProfile.friend_id = [sortedKeys objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:friendProfile animated:YES];
        });
    }
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        NSIndexPath * indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                // Favorite
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [idata allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [idata objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                // NSLog(@"Hide : section = %ld, row = %ld, friend id : %@", (long)indexPath.section, (long)indexPath.row, [sortedKeys objectAtIndex:indexPath.row]);
                
                __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], [sortedKeys objectAtIndex:indexPath.row]];
                
                if ([item objectForKey:@"favorite"]) {
                    NSString *favorite = [item objectForKey:@"favorite"];
                    if ([favorite isEqualToString:@"0"]) {
                        
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/favorite", child]: @"1"};
                        // [ref updateChildValues:childUpdates];
                        
                        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            NSLog(@"");
                        }];
                        
                        //update data local data
                        [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }else{
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/favorite", child]: @"0"};
                        // [ref updateChildValues:childUpdates];
                        
                        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            NSLog(@"");
                        }];
                        
                        //update data local data
                        [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                    }
                }else{
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/favorite", child]: @"1"};
                    [ref updateChildValues:childUpdates];
                    
                    //update data local data
                    [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                }
                
                /*
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"favorite"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                                
                                //update data local data
                                [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"0"];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                                
                                //update data local data
                                [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
         
                    //  กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า

                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/favorite/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                        
                        //update data local data
                        [self updateFavoriteFriend:[sortedKeys objectAtIndex:indexPath.row] :@"1"];
                    }
                }];
                */
            }
                break;
                
            case 2:{
                // Change friend's name
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [idata allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                for(id key in sortedKeys) {
                    id object = [idata objectForKey:key];
                    [sortedValues addObject:object];
                }
                NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                ////---sort
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    Changefriendsname *cn = [storybrd instantiateViewControllerWithIdentifier:@"Changefriendsname"];
                    cn.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:cn animated:YES];
                });
            }
                break;
                
            case 3:{
                // Friend Profile
                
                // ดึงข้อมูล
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [idata allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    FriendProfileView* friendProfile = [storybrd instantiateViewControllerWithIdentifier:@"FriendProfileView"];
                    friendProfile.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:friendProfile animated:YES];
                });
            }
                break;
                
            case 4:{
                NSLog(@"");
                // ดึงข้อมูล
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [idata allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ChatViewController *cV = [storybrd instantiateViewControllerWithIdentifier:@"ChatViewController"];
                    cV.type      = @"private";
                    cV.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:cV animated:YES];
                });
            }
                break;
            default:
                break;
        }
        
    }else if (alertView.tag == 2) {
        
        NSIndexPath * indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                NSMutableDictionary *groups = [all_data valueForKey:@"groups"];

                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [groups allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ManageGroup *manageGroup = [storybrd instantiateViewControllerWithIdentifier:@"ManageGroup"];
                    // manageGroup.group =item;//[friends objectAtIndex:indexPath.row];
                    manageGroup.group_id = [sortedKeys objectAtIndex:indexPath.row];
                    
                    [self.navigationController pushViewController:manageGroup animated:YES];
                });
            }
                break;
            case 2:{
                
                NSMutableDictionary *groups = [all_data valueForKey:@"groups"];
                
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [groups allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Delete group"
                                                                                message:@"Are you sure delete group?"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Close"
                                                                      otherButtonTitles:@"Delete", nil];
                
                alert.userData = [sortedKeys objectAtIndex:indexPath.row];//item;
                alert.tag = 3;
                [alert show];
            }
                break;
                
            case 3:{
                NSMutableDictionary *groups = [all_data valueForKey:@"groups"];
    
                ////---sort เราต้องการเรียงก่อนแสดงผล
                NSArray *myKeys = [groups allKeys];
                NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ChatViewController *cV = [storybrd instantiateViewControllerWithIdentifier:@"ChatViewController"];
                    cV.type = @"Groups";
                    cV.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:cV animated:YES];
                });
            }
                break;
        }
    }else if(alertView.tag == 3){
        // Delete Group
        NSString *group_id = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], group_id];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([groupChatRepo get:key] != nil){
                                BOOL sv = [groupChatRepo deleteGroup:key];
                            }
                            [self reloadData:nil];
                        });
                    }
                }];
            }
                break;
        }
    }else if(alertView.tag == 4){
        // Multi Chat
        NSIndexPath *indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                // Manage Multi Chat
                
                /*
                NSMutableDictionary *groups = [data valueForKey:@"multi_chat"];
                
                NSArray *keys = [groups allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSMutableDictionary*  item = [groups objectForKey:key];
                [item setValue:key forKey:@"multi_chat_id"];
                
                // ChatView2 *chatView2 = [storybrd instantiateViewControllerWithIdentifier:@"ChatView2"];
                // chatView2.friend =item;//[friends objectAtIndex:indexPath.row];
                // chatView2.typeChat =@"4";
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ManageMultiChat *manageMultiChat = [storybrd instantiateViewControllerWithIdentifier:@"ManageMultiChat"];
                manageMultiChat.friend =item;
                manageMultiChat.typeChat =@"4";
                
                [self.navigationController pushViewController:manageMultiChat animated:YES];
                */
            }
                break;
            case 2:{
                
                /*
                NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
                NSArray *keys = [multi_chat allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [multi_chat objectForKey:key];
                
                NSLog(@"Delete Multi Chat");
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/multi_chat/%@/", [[Configs sharedInstance] getUIDU], key];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // [ref parent]
                        //NSString* parent = ref.parent.key;
                        
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        NSLog(@"");
                    }
                }];
                */
            }
                break;
        }
    }else if(alertView.tag == 5){
        // Invite Group
        
        // @"Reject", @"Join"
        NSLog(@"");
        
        NSIndexPath *indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSLog(@"Reject");
                //                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/", [[Configs sharedInstance] getUIDU], [item objectForKey:@"group_id"]];
                //                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                //
                //                    if (error == nil) {
                //                        // [ref parent]
                //                        //NSString* parent = ref.parent.key;
                //
                //                        // จะได้ Group id
                //                        NSString* key = [ref key];
                //
                //                        NSLog(@"");
                //                    }
                //                }];
            }
                break;
            case 2:{
                NSLog(@"Join");
                
                /*
                 step การ Join
                 1. ต้องดึงรายละเอียดของกลุ่มมาก่อนเพือนำไปส้รางเป็นกลุ่มของตัวเองโดย owner_id ={ผู้สร้าง}
                 2. เอาข้อมูลที่ได้จากข้อ 1 ไปสร้างเป้น group
                 
                 3. วิ่งไป update toonchat/{owner_id}/group/{group_id}/members/{nod_id}/{status='access'}
                 4. ลบ invite_group by group_id ออก
                 */
                
                /*
                NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
                
                NSArray *keys = [invite_group allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id _item = [invite_group objectForKey:key];
                
                id item = [[Configs sharedInstance] loadData:key];
                
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@", [[Configs sharedInstance] getUIDU] , key];
                
                // #1, #2
                //                [[ref child:child] setValue:item withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                //                    NSLog(@"");
                //                    if (error == nil) {
                //
                //                    }
                //                }];
                [[ref  child:child] setValue:item];
                
                // #3
                __block NSString *iv_child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/members/%@/", [item objectForKey:@"owner_id"] , key, [_item objectForKey:@"node_id"]];
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", iv_child, @"status"]: @"access"};
                // [ref updateChildValues:childUpdates];
                
                [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error == nil) {
                        NSString *rm_child = [NSString stringWithFormat:@"toonchat/%@/invite_group/%@/", [[Configs sharedInstance] getUIDU] , key];
                        [[ref child:rm_child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            NSLog(@"");
                        }];
                    }
                }];
                */
                
                // #4
                
                NSLog(@"");
            }
                break;
        }
    }else if(alertView.tag == 6){
        // @"Invite Multi Chat";
        
        // @"Reject", @"Join"
        NSLog(@"");
        
        NSMutableDictionary *item = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSLog(@"Reject");

            }
                break;
            case 2:{
                NSLog(@"Join");
            }
                break;
        }
    }else if(alertView.tag == 7){
        
        NSIndexPath *indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                NSLog(@"Delete");
                
                NSLog(@"--> %@", [NSString stringWithFormat:@"%d", indexPath.section]);
                switch (indexPath.section) {
                    case 2:{
                        // hide
                        NSDictionary *favorite = [all_data objectForKey:@"favorite"];
                        
                        ////---sort เราต้องการเรียงก่อนแสดงผล
                        NSArray *myKeys = [favorite allKeys];
                        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                        }];
                        
                        NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                        for(id key in sortedKeys) {
                            id object = [favorite objectForKey:key];
                            [sortedValues addObject:object];
                        }
                        NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                        ////---sort
                        
                        [self deleteFriend:[sortedKeys objectAtIndex:indexPath.row]];
                    }
                        break;
                    case 3:{
                        // Friends
                        NSDictionary *friends = [all_data objectForKey:@"friends"];
                        
                        ////---sort เราต้องการเรียงก่อนแสดงผล
                        NSArray *myKeys = [friends allKeys];
                        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
                        }];
                        
                        NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
                        for(id key in sortedKeys) {
                            id object = [friends objectForKey:key];
                            [sortedValues addObject:object];
                        }
                        NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
                        ////---sort
                        
                        [self deleteFriend:[sortedKeys objectAtIndex:indexPath.row]];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                NSLog(@"Close");
            }
                break;
        }
    }
}

/**
 เป็นการ udpate status favorite
 */
-(void)updateFavoriteFriend:(NSString*)friend_id:(NSString *)is_favorite{

    NSArray *val =  [friendsRepo get:friend_id];
    
    // NSString* friend_id =[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
    NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
//    Friends *friend  = [[Friends alloc] init];
//    friend.friend_id = friend_id;
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    
    if ([newDict objectForKey:@"favorite"]) {
        [newDict removeObjectForKey:@"favorite"];
    }
    [newDict setObject:is_favorite forKey:@"favorite"];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
    
    [self reloadData:nil];
}

/*
 block
 */
-(void)updateBlockFriend:(NSString*)friend_id:(NSString *)is_block{
    NSArray *val =  [friendsRepo get:friend_id];
    NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    
    if ([newDict objectForKey:@"block"]) {
        [newDict removeObjectForKey:@"block"];
    }
    [newDict setObject:is_block forKey:@"block"];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
    
    [self reloadData:nil];
}

/*
 hide
 */
-(void)updateHideFriend:(NSString*)friend_id:(NSString *)is_hide{
    NSArray *val =  [friendsRepo get:friend_id];
    
    NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    
    if ([newDict objectForKey:@"hide"]) {
        [newDict removeObjectForKey:@"hide"];
    }
    [newDict setObject:is_hide forKey:@"hide"];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
    
    [self reloadData:nil];
}

- (IBAction)onRefresh:(id)sender {
    [self reloadData:nil];
}

- (IBAction)onCreateGroup:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriend* addFriend = [storybrd instantiateViewControllerWithIdentifier:@"AddFriend"];
    [self.navigationController pushViewController:addFriend animated:YES];
}

/*
 ดึง Profile Friends
 */
-(NSMutableDictionary *)getProfileFriend:(NSString *)friend_id{
    for (int i =0; i<[friendsProfile count]; i++) {
        NSArray* data = [friendsProfile objectAtIndex:i];
        
        NSString * _fid = [data objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
        
        if ([_fid isEqualToString:friend_id]) {
            NSData *d =  [[data objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            return [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            break;
        }
    }
    return nil;
}

/*
 Check is online
 */
-(BOOL)checkIsOnline:(NSDictionary *)data{
    // device_access
    if ([data objectForKey:@"device_access"]) {
        NSDictionary *device_access =[data objectForKey:@"device_access"];
        for (NSString* key in device_access) {
            NSDictionary* value = [device_access objectForKey:key];
            if ([value objectForKey:@"online"]) {
                if ([[value objectForKey:@"online"] isEqualToString:@"1"]) {
                    return TRUE;
                    break;
                }
            }
        }
        
        return FALSE;
    }else{
        return FALSE;
    }
}
@end
