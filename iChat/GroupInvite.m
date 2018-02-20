//
//  Invite.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "GroupInvite.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "GroupInviteNewMembersThread.h"

#import "GroupChatRepo.h"
#import "FriendProfileRepo.h"
#import "FriendsRepo.h"

@interface GroupInvite (){
    NSMutableDictionary *group;
    GroupChatRepo *groupChatRepo;
    FriendProfileRepo *friendProfileRepo;
    FriendsRepo *friendsRepo;
}

@property(nonatomic, strong)NSMutableDictionary *friends;
@property (nonatomic, strong) NSMutableDictionary *selectedIndex;
@end

@implementation GroupInvite
@synthesize group_id, ref;
@synthesize friends, selectedIndex, barBtnInvite;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    groupChatRepo = [[GroupChatRepo alloc] init];
    friendProfileRepo   = [[FriendProfileRepo alloc] init];
    friendsRepo = [[FriendsRepo alloc] init];
    
    selectedIndex = [NSMutableDictionary dictionary];

    // friends = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] mutableCopy];
    
    friends = [[NSMutableDictionary alloc] init];
    
    
    
    barBtnInvite.enabled = NO;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self reloadData:nil];
//}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_GROUP
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_GROUP object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray * fs = [friendsRepo getFriendsAll];
        
        
        
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // [friends setObject:friend forKey:friend_id];
            
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
            
            // สถานะรอการตอบรับคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    
                    flag = false;
                }
                
                // สถานะทีเราส่งคำขอเป้นเพือน
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    
                    flag = false;
                }
            }
            
            if (flag) {
                [friends setObject:friend forKey:friend_id];
            }
        }
        
        NSArray *_group = [groupChatRepo get:group_id];
        NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
        NSMutableDictionary *items = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        group = [NSJSONSerialization JSONObjectWithData:items options:0 error:nil];
        
        NSDictionary * members = [group objectForKey:@"members"];
        for (NSString *item_id in members) {
            NSDictionary *val = [members objectForKey:item_id];
            [friends removeObjectForKey:[val objectForKey:@"friend_id"]];
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
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
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
    ////---sort
    
    NSArray *fprofile = [friendProfileRepo get:[sortedKeys objectAtIndex:indexPath.row]];
    NSData *data =  [[fprofile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        // [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], [sortedKeys objectAtIndex:indexPath.row]] ;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (selectedIndex[indexPath] == nil) {
        // NSArray *keys = [friends allKeys];
        
        NSArray *myKeys = [friends allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
                
        [selectedIndex setObject:[sortedKeys objectAtIndex:indexPath.row] forKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [selectedIndex removeObjectForKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.title =[NSString stringWithFormat:@"Invite new members(%d)", [selectedIndex count]];
    
    barBtnInvite.enabled = NO;
    if ([selectedIndex count] > 0) {
        barBtnInvite.enabled = YES;
    }
}

- (IBAction)onInvite:(id)sender {
    
    NSMutableDictionary* newMembers =[NSMutableDictionary dictionary];
    
    for (NSString* key in selectedIndex) {
        id value = [selectedIndex objectForKey:key];
        [newMembers setObject:@"" forKey:value];
    }
    
    /*
     ที่เราไม่วิ่งผ่าน firebase เพราะว่า member จะมีการ เอา node id มาใช้งานด้วย
     */
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    GroupInviteNewMembersThread *groupINMT = [[GroupInviteNewMembersThread alloc] init];
    [groupINMT setCompletionHandler:^(NSData *data) {
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        // [self.navigationController popViewControllerAnimated:YES];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *members = [group objectForKey:@"members"];
                
                NSMutableDictionary *resultMembers = jsonDict[@"members"];
                for (NSString* key in resultMembers) {
                    NSDictionary* value = [resultMembers objectForKey:key];
                    
                    NSMutableDictionary *tempFriend = [[NSMutableDictionary alloc] init];
                    [tempFriend addEntriesFromDictionary:members];
                    [tempFriend removeObjectForKey:key];
                    [tempFriend setObject:value forKey:key];
                    
                    members = tempFriend;
                }
                
                NSArray *_group = [groupChatRepo get:group_id];
                NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
                
                NSMutableDictionary *items = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                
                NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
                [tgroup addEntriesFromDictionary:items];
                [tgroup removeObjectForKey:@"members"];
                [tgroup setObject:members forKey:@"members"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateGroup:group_id :tgroup];
            
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Success."];
    }];
    
    [groupINMT setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [groupINMT start:group_id : newMembers];
}
@end
