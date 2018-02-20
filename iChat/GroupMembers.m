//
//  Members.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "GroupMembers.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "GroupInvite.h"
#import "GroupChatRepo.h"
#import "FriendProfileRepo.h"

@interface GroupMembers (){
    NSArray* group_array;
    NSMutableDictionary *group_data;
    NSMutableDictionary *members;
    GroupChatRepo *groupChatRepo;
    FriendProfileRepo *friendProfileRepo;
}

@property(nonatomic, getter=isEditing) BOOL editing;
@end

@implementation GroupMembers
@synthesize group_id, ref, bbiInvite, bbiEdit;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref                 = [[FIRDatabase database] reference];
    groupChatRepo       = [[GroupChatRepo alloc] init];
    friendProfileRepo   = [[FriendProfileRepo alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    bbiInvite.enabled = YES;
    bbiEdit.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_GROUP
                                               object:nil];
    
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_GROUP object:nil];
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        group_array =  [groupChatRepo get:group_id];
        
        NSString* group_id = [group_array objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
        NSString *data = [group_array objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
        
        group_data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        members = [group_data objectForKey:@"members"];
        // friendsProfile = [(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] ;
        
        self.title = [NSString stringWithFormat:@"Group Members(%d)", [members count]];
        
        [self.tableView reloadData];
    });
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GroupInvite"]){
        GroupInvite *groupInvite = (GroupInvite*)segue.destinationViewController;
        groupInvite.group_id = group_id;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
    

    
    /*
    NSArray *keys = [members allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id item = [members objectForKey:key];
    
    NSMutableDictionary *fprofile = [[Configs sharedInstance] loadData:[item objectForKey:@"friend_id"]];//[friendsProfile objectForKey:[item objectForKey:@"friend_id"]];
    
    */
    
    // NSMutableDictionary *favorite = [all_data objectForKey:@"favorite"];
    
    ////---sort เราต้องการเรียงก่อนแสดงผล
    NSArray *myKeys = [members allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *sortedValues = [[NSMutableArray alloc] init] ;
    for(id key in sortedKeys) {
        id object = [members objectForKey:key];
        [sortedValues addObject:object];
    }
    NSDictionary *item = [sortedValues objectAtIndex:indexPath.row];
    ////---sort
    
    /*
     NSArray *keys = [favorite allKeys];
     id key = [keys objectAtIndex:indexPath.row];
     id item = [favorite objectForKey:key];
     */
    
    // NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    // NSMutableDictionary *f = [[Configs sharedInstance] loadData:[sortedKeys objectAtIndex:indexPath.row]];
    
    
    
    NSArray *arrayProfile = [friendProfileRepo get:[item objectForKey:@"friend_id"]];
    
    NSData *data =  [[arrayProfile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *fprofile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    label.text =[NSString stringWithFormat:@"%@-%@", [fprofile objectForKey:@"name"], [item objectForKey:@"friend_id"]];// ;
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([fprofile objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        // [imageV setUrl:[NSURL URLWithString:[fprofile objectForKey:@"image_url"]]];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[fprofile objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }else{}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( editingStyle== UITableViewCellEditingStyleDelete) {
        // NSArray *keys = [members allKeys];
        // id key = [keys objectAtIndex:indexPath.row];
        
        NSArray *myKeys = [members allKeys];
        NSArray *sortedKeys = [myKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        
        id key = [sortedKeys objectAtIndex:indexPath.row];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/members/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], group_id, key];
        [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {

            if (error == nil) {
                // [ref parent]
                //NSString* parent = ref.parent.key;

                // จะได้ Group id
                NSString* key = [ref key];

                // [members removeObjectForKey:key];
                
                NSMutableDictionary *newMembers = [[NSMutableDictionary alloc] init];
                [newMembers addEntriesFromDictionary:members];
                [newMembers removeObjectForKey:key];
            
                NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
                [tgroup addEntriesFromDictionary:group_data];
                [tgroup removeObjectForKey:@"members"];
                [tgroup setObject:newMembers forKey:@"members"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateGroup:group_id :tgroup];

                [self reloadData:nil];
            }
        }];

    }
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return UITableViewCellEditingStyleNone;
//    }
    return UITableViewCellEditingStyleDelete;
}

- (IBAction)onEdit:(id)sender {
    if([self.tableView isEditing]){
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}
@end
