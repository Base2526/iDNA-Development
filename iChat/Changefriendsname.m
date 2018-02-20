//
//  Changefriendsname.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "Changefriendsname.h"
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;
#import "Configs.h"
#import "FriendsRepo.h"

@interface Changefriendsname (){
    
    FriendsRepo *friendRepo;
    NSDictionary *friend;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation Changefriendsname
@synthesize friend_id, txtName, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"Friend id > %@", friend_id];
    
    ref = [[FIRDatabase database] reference];
    
    NSLog(@"friend_id = %@", friend_id);
    
    friendRepo = [[FriendsRepo alloc] init];
    NSArray *val =  [friendRepo get:friend_id];
    
    NSData *data =  [[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
     [NSJSONSerialization JSONObjectWithData:[[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
     */
        
    friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];//[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] objectForKey:friend_id];
    
    txtName.text = @"";
    if ([friend objectForKey:@"change_friends_name"] != nil) {
        txtName.text = [friend objectForKey:@"change_friends_name"];
    }
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

- (IBAction)onSave:(id)sender {
    __block NSString *text_name = [txtName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (![text_name isEqualToString:@""] && [text_name length] > 0) {
        __block NSString *child = [NSString stringWithFormat:@"%@%@/friends/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
 
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/change_friends_name/", child, friend_id]: text_name};
        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error == nil) {                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                [newDict addEntriesFromDictionary:friend];
                
                if ([newDict objectForKey:@"change_friends_name"]) {
                    [newDict removeObjectForKey:@"change_friends_name"];
                }
                
                [newDict setObject:text_name forKey:@"change_friends_name"];
            
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :newDict];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
@end
