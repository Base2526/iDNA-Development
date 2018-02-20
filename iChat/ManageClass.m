//
//  ManageClass.m
//  iDNA
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageClass.h"
#import "ClasssRepo.h"
#import "Classs.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "ClasssListFriends.h"
#import "FriendsRepo.h"
#import "CreateClass.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ManageClass (){
    NSArray* data_all;
    ClasssRepo* classsRepo;
    FriendsRepo *friendsRepo;
    NSMutableDictionary *friends;
    FIRDatabaseReference *ref;
}
@end

@implementation ManageClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    data_all    = [[NSArray alloc] init];
    classsRepo  = [[ClasssRepo alloc] init];
    friendsRepo = [[FriendsRepo alloc] init];
    friends = [[NSMutableDictionary alloc] init];
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
                                                 name:RELOAD_DATA_CLASSS
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FRIEND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CLASSS object:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"CreateClass"]) {
        CreateClass* v = segue.destinationViewController;
        v.fction = @"add";
        v.item_id = @"";
    }
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        data_all = [classsRepo getClasssAll];
    
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
    
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    NSData *data =  [[value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
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
    
//    NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
//
//    int count = 0;
//    for (NSString* key in local_friends) {
//        NSDictionary* value = [local_friends objectForKey:key];
//        // do stuff
//
//        if ([value objectForKey:@"classs"]) {
//            NSString *classs = [value objectForKey:@"classs"];
//
//            if ([classs isEqualToString:item_id]) {
//                count++;
//            }
//        }
//    }
//    lblMembers.text =[NSString stringWithFormat:@"%d Users", count];
    
    int count = 0;
    // NSMutableArray * local_friends = [friendsRepo getFriendsAll];
    // for (NSString* key in local_friends) {
    for (NSString* key in  friends) {
        NSMutableDictionary *ff = [friends objectForKey:key];//[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([ff objectForKey:@"classs"]) {
            NSString *classs = [ff objectForKey:@"classs"];
            
            if ([classs isEqualToString:item_id]) {
                count++;
            }
        }
        NSLog(@"");
    }
    
     lblMembers.text =[NSString stringWithFormat:@"%d Users", count];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClasssListFriends* classListFriends = [storybrd instantiateViewControllerWithIdentifier:@"ClasssListFriends"];
    classListFriends.item_id = item_id;
    [self.navigationController pushViewController:classListFriends animated:YES];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSArray *value = [data_all objectAtIndex:indexPath.row];
        NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/classs/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], item_id];
        
        [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            if (error == nil) {
                // จะได้ classs id
                NSString* key = [ref key];
                
                // ลบ classs
                BOOL rs= [classsRepo deleteClasss:key];
        
                if (error == nil) {
                    [self reloadData:nil];
                }else{
                }
            }
        }];
    }];
    btnDelete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *btnEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSArray *value = [data_all objectAtIndex:indexPath.row];
        NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];

        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreateClass* v = [storybrd instantiateViewControllerWithIdentifier:@"CreateClass"];
        v.fction = @"edit";
        v.item_id = item_id;
        
        [self.navigationController pushViewController:v animated:YES];
    }];
    btnEdit.backgroundColor = [UIColor blueColor];
    
    return @[btnDelete, btnEdit];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
