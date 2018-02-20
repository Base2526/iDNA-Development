//
//  ListGroup.m
//  iDNA
//
//  Created by Somkid on 1/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "ListGroup.h"
#import "GroupChatRepo.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "ClasssListFriends.h"
#import "FriendsRepo.h"
#import "CreateGroup.h"
#import "ManageGroup.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ListGroup (){
    NSArray* data_all;
    GroupChatRepo* groupChatRepo;
    FriendsRepo *friendsRepo;
    NSMutableDictionary *friends;
    FIRDatabaseReference *ref;
}
@end

@implementation ListGroup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref             = [[FIRDatabase database] reference];
    data_all        = [[NSArray alloc] init];
    groupChatRepo   = [[GroupChatRepo alloc] init];
    friendsRepo     = [[FriendsRepo alloc] init];
    friends         = [[NSMutableDictionary alloc] init];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_GROUP
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FRIEND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_GROUP object:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"CreateGroup"]) {
        CreateGroup* v = segue.destinationViewController;
        v.fction = @"add";
        v.item_id = @"";
    }
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        data_all = [groupChatRepo getGroupChatAll];
        
        NSMutableArray * fs = [friendsRepo getFriendsAll];
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
                    
                    flag = false;
                }
            }
            
            // สถานะทีเราส่งคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    
                    flag = false;
                }
            }
            
            if (flag) {
                [friends setObject:friend forKey:friend_id];
            }
        }
        
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    
    NSString *item_id = [value objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
    NSData *data =  [[value objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName    =(UILabel *)[cell viewWithTag:101];
    UILabel *lblMembers =(UILabel *)[cell viewWithTag:102];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], item_id] ;
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        
    }
    //
    lblMembers.text =[NSString stringWithFormat:@"0 Users"];
    
    if ([f objectForKey:@"members"]) {
        NSDictionary* members =[f objectForKey:@"members"];
        
        lblMembers.text =[NSString stringWithFormat:@"%d Users", [members count]];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray *value = [data_all objectAtIndex:indexPath.row];
        
        NSString *group_id = [value objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"group_id"]];
        
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageGroup *manageGroup = [storybrd instantiateViewControllerWithIdentifier:@"ManageGroup"];
        manageGroup.group_id = group_id;
        [self.navigationController pushViewController:manageGroup animated:YES];
    });
}
@end
