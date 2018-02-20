//
//  Tab_Contacts_GroupChat.m
//  iDNA
//
//  Created by Somkid on 6/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "Tab_Contacts_GroupChat.h"
#import "HJManagedImageV.h"
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

//@import Firebase;
//@import FirebaseMessaging;
//@import FirebaseDatabase;

@interface Tab_Contacts_GroupChat (){
    // FIRDatabaseReference *ref;
}
@end

@implementation Tab_Contacts_GroupChat
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupTableViewCell"];
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
//        FriendsRepo *friendsRepo = [[FriendsRepo alloc] init];
//        NSMutableArray * fs = [friendsRepo getFriendsAll];
        
        /*
        hideFriends = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([friend objectForKey:@"hide"]) {
                if ([[friend objectForKey:@"hide"] isEqualToString:@"1"]) {
                    [hideFriends setObject:friend forKey:friend_id];
                }
            }
        }
        */
        
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//[hideFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
//    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
//    cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
    
    /*
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
    NSArray *keys = [hideFriends allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [hideFriends objectForKey:aKey];
    
    
    NSArray *fprofile = [friendPRepo get:aKey];
    
    NSData *data =  [[fprofile objectAtIndex:[friendPRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel]; // API_URL
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }else{
        [imageV clear];
    }
    [labelName setText:[NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], aKey]];
    */
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadData:nil];
}
@end
