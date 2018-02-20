//
//  BlockFriends.m
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "BlockFriends.h"
#import "Configs.h"
#import "FriendProfileRepo.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "FriendsRepo.h"

@interface BlockFriends (){
    NSMutableDictionary *blockFriends;
    FriendProfileRepo *friendPRepo;
    FIRDatabaseReference *ref;
}

@end

@implementation BlockFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    friendPRepo = [[FriendProfileRepo alloc] init];
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
        FriendsRepo *friendsRepo = [[FriendsRepo alloc] init];
        NSMutableArray * fs = [friendsRepo getFriendsAll];
        
        blockFriends = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([friend objectForKey:@"block"]) {
                if ([[friend objectForKey:@"block"] isEqualToString:@"1"]) {
                    [blockFriends setObject:friend forKey:friend_id];
                }
            }
        }
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [blockFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
    NSArray *keys = [blockFriends allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [blockFriends objectForKey:aKey];
    
    
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
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadData:nil];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnUnblock = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unblock" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Unblock");
        
        NSArray *keys = [blockFriends allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/friends/%@/block/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], aKey];
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: @"0"};
        [ref updateChildValues:childUpdates];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUnblockFriend:aKey];
        });
    }];
    btnUnblock.backgroundColor = [UIColor redColor];
//    UITableViewRowAction *btnHide = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Hide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        NSLog(@"Hide");
//    }];
    // btnHide.backgroundColor = [UIColor grayColor];
    return @[btnUnblock];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/*
 Unblock
 */
-(void)updateUnblockFriend:(NSString*)friend_id{
    FriendsRepo *friendRepo = [[FriendsRepo alloc] init];
    NSArray *val =  [friendRepo get:friend_id];
    
    NSData *data =  [[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    
    if ([newDict objectForKey:@"block"]) {
        [newDict removeObjectForKey:@"block"];
    }
    [newDict setObject:@"0" forKey:@"block"];

    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
    
    [self reloadData:nil];
}


@end
