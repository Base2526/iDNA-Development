//
//  ListPhone.m
//  Heart
//
//  Created by Somkid on 1/23/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListPhone.h"
#import "AppConstant.h"
#import "EditPhone.h"
#import "Configs.h"
#import "CustomAlertView.h"
#import "EditPhoneThread.h"

@interface ListPhone (){
    FIRDatabaseReference *ref;
    
    NSMutableArray *fieldSelected;
    NSMutableDictionary *phones;
    NSMutableDictionary *profiles;
}
@end

@implementation ListPhone
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fieldSelected = [[NSMutableArray alloc] init];
    ref         = [[FIRDatabase database] reference];
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
 if ([segue.identifier isEqualToString:@"EditPhone"]) {
     EditPhone* v = segue.destinationViewController;
     v.fction = @"add";
     v.item_id = @"";
 }
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [phones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    NSArray *keys = [phones allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [phones objectForKey:aKey];
    
    label.text = [anObject objectForKey:@"name"];
    
    if ([fieldSelected containsObject:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //the below code will allow multiple selection
    if ([fieldSelected containsObject:indexPath]){
        [fieldSelected removeObject:indexPath];
    }else{
        [fieldSelected addObject:indexPath];
    }
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        NSArray *keys = [phones allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [phones objectForKey:aKey];
        
        // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        
        EditPhone *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
        v.fction = @"edit";
        v.item_id = aKey;
        v.number =[anObject objectForKey:@"name"];
        
        [self.navigationController pushViewController:v animated:YES];
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        // NSLog(@"");
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
        alertView.tag = -999;
        
        alertView.object = @{@"indexPath" : indexPath};
        
        [alertView show];
        
    }];
    
    return @[hiddenAction, blockAction];
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                
                NSDictionary* userInfo = alertView.object;
                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
                
                NSArray *keys = [phones allKeys];
                id aKey = [keys objectAtIndex:indexPath.row];
                id anObject = [phones objectForKey:aKey];
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                if([profiles objectForKey:@"phones"]){
                    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/phones/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], aKey];
                    
                    [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        
                         [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        if (error == nil) {
                            // จะได้ item_id
                            NSString* key = [ref key];
                            
                            if([profiles objectForKey:@"phones"]){
                                NSMutableDictionary *phones = [profiles objectForKey:@"phones"];
                                
                                NSMutableDictionary *newPhones = [[NSMutableDictionary alloc] init];
                                [newPhones addEntriesFromDictionary:phones];
                                [newPhones removeObjectForKey:key];
                                
                                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                                [newProfiles addEntriesFromDictionary:profiles];
                                
                                if ([newProfiles objectForKey:@"phones"]) {
                                    [newProfiles removeObjectForKey:@"phones"];
                                }
                                
                                [newProfiles setValue:newPhones forKey:@"phones"];
                                
                                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                                
                                if (error == nil) {
                                    [self reloadData:nil];
                                }else{
                                }
                            }
                        }
                    }];
                }
            }
            break;
        default:
            break;
    }
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles = [[Configs sharedInstance] getUserProfiles];
        
        if ([profiles objectForKey:@"phones"]) {
            phones = [profiles objectForKey:@"phones"];
            
            self._table.hidden = NO;
            
        }else{
            self._table.hidden = YES;
        }

        [self._table reloadData];
    });
}
@end
