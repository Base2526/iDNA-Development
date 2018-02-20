//
//  ListEP.m
//  Heart
//
//  Created by Somkid on 4/17/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListEP.h"
#import "AppConstant.h"
#import "EditPhone.h"
#import "Configs.h"
#import "CustomAlertView.h"
#import "EditPhoneThread.h"

@interface ListEP (){
    NSMutableArray *fieldSelected;
    NSMutableDictionary *EPS;
    
    NSMutableArray *center;
    
    NSMutableArray *childObservers;
}
@end

@implementation ListEP
@synthesize isYes;
@synthesize ref;
@synthesize item_id;
@synthesize category;
- (void)viewDidLoad {
    [super viewDidLoad];
    fieldSelected = [[NSMutableArray alloc] init];
    
    ref = [[FIRDatabase database] reference];
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadDataCenter"
                                               object:nil];
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadDataCenter" object:nil];
    
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
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
    return  [EPS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    //    NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row] ;
    //    label.text = [item objectForKey:@"value"];
    //
    //    NSDictionary *_items = [data_profile2 objectForKey:indexPath.row];
    // id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
    
    
    NSArray *keys = [EPS allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [EPS objectForKey:aKey];
    
    if (isYes) {
        // mails
        if ([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:@"mails"]) {
            NSDictionary *mails = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:@"mails"];
            
            if ([mails objectForKey:aKey]) {
                if ([[[mails objectForKey:aKey] objectForKey:@"isUse"] isEqualToString:@"1"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        // phones
        if ([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:@"phones"]) {
            NSDictionary *phones = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:@"phones"];
            
            if ([phones objectForKey:aKey]) {
                if ([[[phones objectForKey:aKey] objectForKey:@"isUse"] isEqualToString:@"1"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    label.text = [anObject objectForKey:@"name"];
    

    
//    if ([fieldSelected containsObject:indexPath]){
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    // center
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //the below code will allow multiple selection
    if ([fieldSelected containsObject:indexPath]){
        [fieldSelected removeObject:indexPath];
    }else{
        [fieldSelected addObject:indexPath];
    }

    NSArray *keys = [EPS allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id object = [EPS objectForKey:key];
    
    if (isYes) {
        // mails
        
//        NSString *ochild = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/%@/like/", category, item_id, post_id];
//        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", ochild, [[Configs sharedInstance] getUIDU]]: val};
//        [ref updateChildValues:childUpdates];

        // จะเก็บว่าเราไป liking อะไรไว้บ้าง
        __block NSString *child = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/mails/", category, item_id];
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            NSLog(@"%@", snapshot.children);
            
            NSMutableDictionary *val = [[NSMutableDictionary alloc] init];
            [val setObject:[object objectForKey:@"name"] forKey:@"name"];
            
            BOOL flag = TRUE;
            for(FIRDataSnapshot* snap in snapshot.children){
                flag = FALSE;
                
                NSMutableDictionary *tvalue = snapshot.value;
                
                if ([tvalue objectForKey:key]) {
                    NSDictionary* tkey = [tvalue objectForKey:key];
                 
                    if ([[tkey objectForKey:@"isUse"] isEqualToString:@"0"]) {
                 
                        [val setObject:@"1" forKey:@"isUse"];
                 
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                        [ref updateChildValues:childUpdates];
                    }else{
                        [val setObject:@"0" forKey:@"isUse"];
                 
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                        [ref updateChildValues:childUpdates];
                    }
                 }else{
                 
                     [val setObject:@"1" forKey:@"isUse"];
                 
                     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                     [ref updateChildValues:childUpdates];
                 }
            }
            
            if (flag) {
                
                [val setObject:@"1" forKey:@"isUse"];
                
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                [ref updateChildValues:childUpdates];
            }
            
        }];
    }else{
        // phones
        
        // จะเก็บว่าเราไป liking อะไรไว้บ้าง
        __block NSString *child = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/phones/", category, item_id];
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            NSLog(@"%@", snapshot.children);
            
            NSMutableDictionary *val = [[NSMutableDictionary alloc] init];
            [val setObject:[object objectForKey:@"name"] forKey:@"name"];
            
            BOOL flag = TRUE;
            for(FIRDataSnapshot* snap in snapshot.children){
                flag = FALSE;
                
                NSMutableDictionary *tvalue = snapshot.value;
                
                if ([tvalue objectForKey:key]) {
                    NSDictionary* tkey = [tvalue objectForKey:key];
                    
                    if ([[tkey objectForKey:@"isUse"] isEqualToString:@"0"]) {
                        
                        [val setObject:@"1" forKey:@"isUse"];
                        
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                        [ref updateChildValues:childUpdates];
                    }else{
                        [val setObject:@"0" forKey:@"isUse"];
                        
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                        [ref updateChildValues:childUpdates];
                    }
                }else{
                    
                    [val setObject:@"1" forKey:@"isUse"];
                    
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                    [ref updateChildValues:childUpdates];
                }
            }
            
            if (flag) {
                
                [val setObject:@"1" forKey:@"isUse"];
                
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, key]: val};
                [ref updateChildValues:childUpdates];
            }
        }];
    }
    
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        // [self.tableView setEditing:NO];
        
        NSArray *keys = [EPS allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [EPS objectForKey:aKey];
        
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

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                
                NSDictionary* userInfo = alertView.object;
                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
                
                NSArray *keys = [EPS allKeys];
                id aKey = [keys objectAtIndex:indexPath.row];
                id anObject = [EPS objectForKey:aKey];
                
                // NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
                // NSString* phone = [anObject objectForKey:@"number"];
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                EditPhoneThread *dThread = [[EditPhoneThread alloc] init];
                [dThread setCompletionHandler:^(NSData *data) {
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        [self reloadData: nil];
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                }];
                
                [dThread setErrorHandler:^(NSString *error) {
                    NSLog(@"%@", error);
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                // self.number
                [dThread start:@"delete" :aKey : @""];
            }
            break;
        default:
            break;
    }
}

-(void)reloadData:(NSNotification *) notification{
    // NSDictionary *data = [[Configs sharedInstance] loadData:_DATA];
    center   = [[Configs sharedInstance] loadData:_CENTER];
    
    if (isYes) {
        // emails
        if([[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"]){
            EPS = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"];
            if ([EPS count] > 0) {
                self._table.hidden = NO;
                self.emptyMessage.hidden = YES;
            }
        }else{
            EPS = [[NSMutableDictionary alloc] init];
            
            self._table.hidden = YES;
            self.emptyMessage.hidden = NO;
        }
    }else{
        // phones
        if([[[Configs sharedInstance] loadData:_DATA] objectForKey:@"phones"]){
            EPS = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"phones"];
            if ([EPS count] > 0) {
                self._table.hidden = NO;
                self.emptyMessage.hidden = YES;
            }
        }else{
            EPS = [[NSMutableDictionary alloc] init];
            
            self._table.hidden = YES;
            self.emptyMessage.hidden = NO;
        }
    }
    
    [self._table reloadData];
}
@end

