//
//  SelectFriendClasss.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "SelectFriendClasss.h"
#import "ClasssRepo.h"
#import "Classs.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "Configs.h"
#import "FriendProfileRepo.h"

#import "Friends.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "FriendsRepo.h"


@interface SelectFriendClasss (){
    NSArray *data_all;
    ClasssRepo* classsRepo;
    NSString* select;
    
    FIRDatabaseReference *ref;
    
    // FriendProfileRepo *friendProfileRepo;
    
    FriendsRepo *friendRepo;
    NSDictionary * friend;
}
@end

@implementation SelectFriendClasss
@synthesize friend_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    data_all = [[NSArray alloc] init];
    classsRepo  = [[ClasssRepo alloc] init];
    
    friendRepo  = [[FriendsRepo alloc] init];
    
    select = @"0";
    
    ref = [[FIRDatabase database] reference];
    
    // friendProfileRepo = [[FriendProfileRepo alloc] init];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_FRIEND
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FRIEND object:nil];
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray *val =  [friendRepo get:friend_id];
        
        NSData *data =  [[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        data_all = [classsRepo getClasssAll];
        // NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
        // NSMutableDictionary *local_friend  = [local_friends objectForKey:friend_id];
        // [friend setValue:class forKey:@"classs"];
        if ([friend objectForKey:@"classs"]) {
            ClasssRepo * classsRepo = [[ClasssRepo alloc] init];
            NSArray *class = [classsRepo get:[friend objectForKey:@"classs"]];
            
            
            NSString *item_id = [class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
            //        NSData *class_data =  [[class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            //
            //        NSMutableDictionary *tmp = [NSJSONSerialization JSONObjectWithData:class_data options:0 error:nil];
            //
            //        [btnClasss setTitle:[tmp objectForKey:@"name"] forState:UIControlStateNormal];
            
            select = item_id;
        }else{
            select = @"0";
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
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    NSData *data =  [[value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName    =(UILabel *)[cell viewWithTag:101];
    // UILabel *lblMembers =(UILabel *)[cell viewWithTag:102];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], item_id] ;
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        
    }
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    // @"Friends";
    // NSMutableDictionary *friends = [data objectForKey:@"friends"];
    
    /*
    NSArray *keys = [friends allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id item = [friends objectForKey:key];
    
    NSMutableDictionary *f = [[Configs sharedInstance] loadData:key];//[[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
    
    // cell.lblName.text = ;
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    */
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([select isEqualToString:item_id]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // select = indexPath.row;

    NSArray *value = [data_all objectAtIndex:indexPath.row];
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    
    select = item_id;
    
   
    
    [self onSetClasss:select];
    
     [self reloadData:nil];
    
}

-(void)onSetClasss:(NSString*)class{
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:friend];
    
    if ([newDict objectForKey:@"classs"]) {
        [newDict removeObjectForKey:@"classs"];
    }
    [newDict setValue:class forKey:@"classs"];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
    
     __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
    
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/classs/", child, friend_id]: class};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            
            /*
            NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
            // ดึงเพือนตาม friend_id แล้ว set classs
            NSMutableDictionary *friend  = [friends objectForKey:friend_id];
            [friend setValue:class forKey:@"classs"];
            
            NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
            [newFriends addEntriesFromDictionary:friends];
            [newFriends removeObjectForKey:friend_id];
            [newFriends setObject:friend forKey:friend_id];
            
            // Update friends ของ DATA
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:@"friends"];
            [newDict setObject:newFriends forKey:@"friends"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            */
            
            // friendRepo = [[FriendsRepo alloc] init];
            
            
            // Friends *fd  = [[Friends alloc] init];
            // fd.friend_id = friend_id;
            
           
            
            
        }
    }];
}
/*
 __block NSString *text_name = [txtName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
 if (![text_name isEqualToString:@""] && [text_name length] > 0) {
 __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
 
 NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/change_friends_name/", child, friend_id]: text_name};
 [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
 if (error == nil) {
 
 NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
 
 
 // ดึงเพือนตาม friend_id แล้ว set change_friends_name
 
NSMutableDictionary *friend  = [friends objectForKey:friend_id];
[friend setValue:text_name forKey:@"change_friends_name"];

// Update friends ของ DATA
NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
[newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
[newDict removeObjectForKey:@"friends"];
[newDict setObject:friends forKey:@"friends"];

[[Configs sharedInstance] saveData:_DATA :newDict];

[self.navigationController popViewControllerAnimated:YES];
}
}];
}
 */

@end
