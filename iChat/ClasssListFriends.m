//
//  ClasssListFriends.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ClasssListFriends.h"
#import "Configs.h"
#import "FriendProfileRepo.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"

#import "ClasssRepo.h"

#import "FriendsRepo.h"

@interface ClasssListFriends (){
    NSMutableDictionary *blockFriends;
    FriendProfileRepo *friendPRepo;
    FIRDatabaseReference *ref;
    NSMutableDictionary *friends;
    
    ClasssRepo *classsRepo;
    
    FriendsRepo *friendsRepo;
}
@end

@implementation ClasssListFriends
@synthesize item_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"List Class Users";
    
    ref         = [[FIRDatabase database] reference];
    friendPRepo = [[FriendProfileRepo alloc] init];
    friends     = [[NSMutableDictionary alloc] init];
    
    classsRepo  = [[ClasssRepo alloc] init];
    
    friendsRepo = [[FriendsRepo alloc] init];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)reloadData:(NSNotification *) notification{
    
    /*
    blockFriends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    
    for (NSString* key in blockFriends) {
        NSDictionary* value = [blockFriends objectForKey:key];
        
        if ([value objectForKey:@"block"]) {
            if ([[value objectForKey:@"block"] isEqualToString:@"1"]) {
                continue;
            }
        }
        
        NSMutableDictionary *newFriends = [[NSMutableDictionary alloc] init];
        [newFriends addEntriesFromDictionary:blockFriends];
        
        [newFriends removeObjectForKey:key];
        
        blockFriends = newFriends;
    }
    */
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *local_friends = [classsRepo get:item_id];//[[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
        
        NSData *data =  [[local_friends objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        int count = 0;
        for (NSString* key in f) {
            NSDictionary* value = [f objectForKey:key];
            // do stuff
            
            if ([value objectForKey:@"classs"]) {
                NSString *classs = [value objectForKey:@"classs"];
                
                if ([classs isEqualToString:item_id]) {
                    [friends addObject:key];
                }
            }
        }
        
        [self.tableView reloadData];
    });
    */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // data_all = [classsRepo getClasssAll];
        
        
        [friends removeAllObjects];
        
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
                
                
                if ([friend objectForKey:@"classs"]) {
                    NSString *classs = [friend objectForKey:@"classs"];
                    
                    if ([classs isEqualToString:item_id]) {
                        [friends setObject:friend forKey:friend_id];
                    }
                }
            }
        }
        
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
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
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *labelName = (UILabel *)[cell viewWithTag:10];
    
    
    NSArray *keys = [friends allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [friends objectForKey:aKey];
    
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
    [labelName setText:[NSString stringWithFormat:@"%@", [f objectForKey:@"name"]]];

    return cell;
}
@end
