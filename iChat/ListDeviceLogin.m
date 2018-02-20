//
//  ForceLogout.m
//  iDNA
//
//  Created by Somkid on 22/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "ListDeviceLogin.h"
#import "Configs.h"
#import "UserDataUIAlertView.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ListDeviceLogin (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles, *device_access;
}
@end

@implementation ListDeviceLogin
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref           = [[FIRDatabase database] reference];
    profiles      = [[NSMutableDictionary alloc] init];
    device_access = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"EditEmail"]) {
//        EditEmail* v = segue.destinationViewController;
//        v.fction = @"add";
//        v.item_id = @"";
//    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    // return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    return [device_access count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    /*
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    //  NSDictionary* item = [mails objectAtIndex:indexPath.row];
    // label.text = [item objectForKey:@"value"];
    
    
    // id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
    
    NSArray *keys = [mails allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [mails objectForKey:aKey];
    
    label.text = [anObject objectForKey:@"name"];
    
    
    if ([fieldSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    */
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    UILabel *labelModel = (UILabel *)[cell viewWithTag:11];
    UILabel *labelOnline = (UILabel *)[cell viewWithTag:12];
    
    NSArray *keys = [device_access allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [device_access objectForKey:aKey];
    
    if ([anObject objectForKey:@"device_name"]) {
        [labelName setText:[anObject objectForKey:@"device_name"]];
    }
    
    if ([anObject objectForKey:@"model_number"]) {
        [labelModel setText:[anObject objectForKey:@"model_number"]];
    }
    
    if ([anObject objectForKey:@"online"]) {
        [labelOnline setText:[anObject objectForKey:@"online"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *forceLogoutAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Force Logout" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        // NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
        
        /*
        NSArray *keys = [mails allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [mails objectForKey:aKey];
        
        EditEmail *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmail"];
        v.fction     = @"edit";
        v.item_id    = aKey;
        v.email      = [anObject objectForKey:@"name"];
        */
        
        /*
         EditPhone *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
         v.fction = @"edit";
         v.item_id = aKey;
         v.number =[anObject objectForKey:@"phone"];
         */
        
        // [self.navigationController pushViewController:v animated:YES];
        
        NSArray *keys = [device_access allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [device_access objectForKey:aKey];
        
        NSString *text = [NSString stringWithFormat:@"Force Logout"];
        if ([anObject objectForKey:@"device_name"]) {
           text = [NSString stringWithFormat:@"Force Logout : %@", [anObject objectForKey:@"device_name"]];
        }
        
        UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:text
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Force Logout", @"Close", nil];
        
        alert.userData = indexPath;
        alert.tag = 1;
        [alert show];
        
    }];
    forceLogoutAction.backgroundColor = [UIColor redColor];
  
    return @[forceLogoutAction];
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                
                NSArray *keys = [device_access allKeys];
                id item_id = [keys objectAtIndex:indexPath.row];
                
                // Force Logout
                NSMutableDictionary *device_access = [profiles objectForKey:@"device_access"];
                
                NSMutableDictionary *newDeviceAccess = [[NSMutableDictionary alloc] init];
                [newDeviceAccess addEntriesFromDictionary:device_access];
                // [newPhones removeObjectForKey:self.item_id];
                
                NSMutableDictionary *newMail = [[NSMutableDictionary alloc] init];
                [newMail addEntriesFromDictionary:[device_access objectForKey:item_id]];
                [newMail removeObjectForKey:@"is_login"];
                [newMail setValue:@"0" forKey:@"is_login"];
                
                [newDeviceAccess removeObjectForKey:item_id];
                [newDeviceAccess setValue:newMail forKey:item_id];
                
                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                [newProfiles addEntriesFromDictionary:profiles];
                
                if ([newProfiles objectForKey:@"device_access"]) {
                    [newProfiles removeObjectForKey:@"device_access"];
                }
                [newProfiles setValue:newDeviceAccess forKey:@"device_access"];
                
                
                NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
                
                [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    if (error == nil) {
                        
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                        
                        [self reloadData:nil];
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update email."];
                    }
                }];
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

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{

        profiles = [[Configs sharedInstance] getUserProfiles];
        [device_access removeAllObjects];
        
        if ([profiles objectForKey:@"device_access"]) {
            // device_access = [profiles objectForKey:@"device_access"];
            
            // device_access
            
            for (NSString* key in [profiles objectForKey:@"device_access"]) {
                id value = [[profiles objectForKey:@"device_access"] objectForKey:key];
                // do stuff
                if ([[value objectForKey:@"is_login"] isEqualToString:@"1"] && ![[value objectForKey:@"udid"] isEqualToString:[[Configs sharedInstance] getUniqueDeviceIdentifierAsString]]) {
                    [device_access setObject:value forKey:key];
                }
            }
        }
        
        [tableView reloadData];
    });
}

@end
