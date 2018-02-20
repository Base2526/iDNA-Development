//
//  SettingsViewController.m
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_Settings.h"
#import "Configs.h"
#import "HideFriends.h"
#import "BlockFriends.h"
#import "LogoutThread.h"
#import "WelcomeView.h"
#import "MessageRepo.h"
#import "FriendProfileRepo.h"
#import "GroupChatRepo.h"
#import "MyApplicationsRepo.h"
#import "ProfilesRepo.h"
#import "FriendsRepo.h"
#import "ClasssRepo.h"
#import "FollowingRepo.h"
#import "CenterRepo.h"
#import "UserDataUIAlertView.h"
#import "ListClasss.h"
#import "CreateGroup.h"
#import "FriendsRepo.h"
#import "Friends.h"
#import "ListDeviceLogin.h"

#import "ClasssRepo.h"
#import "GroupChatRepo.h"
#import "ListGroup.h"
#import "ListMyApplication.h"

@interface Tab_Settings (){
    FriendsRepo *friendsRepo;
    NSMutableArray *all_data;
    NSMutableDictionary *friends;
    
    NSMutableArray *all_classs;
    NSMutableArray *all_group;
    NSMutableArray *all_myapplication;
    ClasssRepo *classsRepo;
    GroupChatRepo *groupChatRepo;
    
    MyApplicationsRepo *myApplicationsRepo;
    
    NSDictionary *profiles;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
#define kWIDTH          UIScreen.mainScreen.bounds.size.width
@end

@implementation Tab_Settings
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendsRepo = [[FriendsRepo alloc] init];
    classsRepo  = [[ClasssRepo alloc] init];
    groupChatRepo = [[GroupChatRepo alloc] init];
    
    myApplicationsRepo = [[MyApplicationsRepo alloc] init];
    
    profiles = [[NSDictionary alloc] init];
    all_data = [[NSMutableArray alloc] init];
    all_classs = [[NSMutableArray alloc] init];
    all_group  = [[NSMutableArray alloc] init];
    all_myapplication = [[NSMutableArray alloc] init];
    
    [all_data addObject:@"Hide"];
    [all_data addObject:@"Block"];
    [all_data addObject:@"Manage class"];
    [all_data addObject:@"Manage Group"];
    [all_data addObject:@"Manage My Application"];
    [all_data addObject:@"Force Logout"];
    [all_data addObject:@"Logout"];
}

-(void) viewWillAppear:(BOOL)animated{
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
                                                 name:RELOAD_DATA_CLASSS
                                               object:nil];
    
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FRIEND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CLASSS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles = [[Configs sharedInstance] getUserProfiles];
        all_classs = [classsRepo getClasssAll];
        all_group  = [groupChatRepo getGroupChatAll];
        all_myapplication = [myApplicationsRepo getMyApplicationAll];
        
        NSMutableArray * fs = [friendsRepo getFriendsAll];
        friends = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([friend objectForKey:@"hide"]) {
                if ([[friend objectForKey:@"hide"] isEqualToString:@"1"]) {
                    [friends setObject:friend forKey:friend_id];
                }
            }
            if ([friend objectForKey:@"block"]) {
                if ([[friend objectForKey:@"block"] isEqualToString:@"1"]) {
                    [friends setObject:friend forKey:friend_id];
                }
            }
        }
        [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [all_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
    NSString *name = [all_data objectAtIndex:indexPath.row];

    
    switch (indexPath.row) {
            // Hide
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            int count = 0;
            for (NSString* key in friends) {
                NSDictionary* value = [friends objectForKey:key];
                // do stuff
                
                if ([value objectForKey:@"hide"]) {
                    
                    if ([[value objectForKey:@"hide"] isEqualToString:@"1"]) {
                        count++;
                    }
                }
            }
            
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, count]];
        }
            break;
            
        case 1:
            // Block
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            int count = 0;
            for (NSString* key in friends) {
                NSDictionary* value = [friends objectForKey:key];
                // do stuff
                
                if ([value objectForKey:@"block"]) {
                    
                    if ([[value objectForKey:@"block"] isEqualToString:@"1"]) {
                        count++;
                    }
                }
            }
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, count]];
        }
            break;
            
        case 2:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, [all_classs count]]];
        }
            break;
        case 3:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, [all_group count]]];
        }
            break;
            
        case 4:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, [all_myapplication count]]];
        }
            break;
            
        case 5:{
            
            int count = 0;
            
            if([profiles objectForKey:@"device_access"]){
                for (NSString* key in [profiles objectForKey:@"device_access"]) {
                    id value = [[profiles objectForKey:@"device_access"] objectForKey:key];
                    // do stuff
                    if ([[value objectForKey:@"is_login"] isEqualToString:@"1"] && ![[value objectForKey:@"udid"] isEqualToString:[[Configs sharedInstance] getUniqueDeviceIdentifierAsString]]) {
                        count++;
                    }
                }
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [labelName setText:[NSString stringWithFormat:@"%@ (%d)", name, count]];
        }
            break;
        // Logout
        case 6:{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [labelName setText:name];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 HideFriends* hideFriend = [storybrd instantiateViewControllerWithIdentifier:@"HideFriends"];
                 [self.navigationController pushViewController:hideFriend animated:YES];
             });
        }
            break;
            
        case 1:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                BlockFriends* blockFriends = [storybrd instantiateViewControllerWithIdentifier:@"BlockFriends"];
                [self.navigationController pushViewController:blockFriends animated:YES];
            });
        }
            break;
            
        case 2:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ListClasss* listClasss = [storybrd instantiateViewControllerWithIdentifier:@"ListClasss"];
                [self.navigationController pushViewController:listClasss animated:YES];
            });
        }
            break;
            
        case 3:{            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ListGroup* listGroup = [storybrd instantiateViewControllerWithIdentifier:@"ListGroup"];
                [self.navigationController pushViewController:listGroup animated:YES];
            });
        }
            break;
            
            //
            
        case 4:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ListMyApplication* listGroup = [storybrd instantiateViewControllerWithIdentifier:@"ListMyApplication"];
                [self.navigationController pushViewController:listGroup animated:YES];
            });
        }
            break;
            
        case 5:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ListDeviceLogin * ldLogin = [storybrd instantiateViewControllerWithIdentifier:@"ListDeviceLogin"];
                [self.navigationController pushViewController:ldLogin animated:YES];
            });
        }
            break;
        
        case 6:{
            UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Logout"
                                                       message:@"Are you sure logout?"
                                                      delegate:self
                                             cancelButtonTitle:@"Close"
                                             otherButtonTitles:@"Logout", nil];

            alert.userData = indexPath;
            alert.tag = 1;
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
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
                // Logout
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                LogoutThread * logoutThread = [[LogoutThread alloc] init];
                [logoutThread setCompletionHandler:^(NSData * data) {
                     [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                     NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                 
                     if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                             NSMutableDictionary *idata  = jsonDict[@"data"];
                 
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             WelcomeView *welcomeView = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeView"];
                             UINavigationController *navPreLogin = [[UINavigationController alloc] initWithRootViewController:welcomeView];
                 
                             [self presentViewController:navPreLogin animated:YES completion:nil];
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
                break;
        }
    }
}
@end

