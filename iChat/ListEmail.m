//
//  ListEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListEmail.h"

#import "Configs.h"
#import "EditEmail.h"
#import "Configs.h"
#import "AnNmousURegister.h"
#import "AnNmousUVerify.h"
#import "CustomAlertView.h"
#import "EditEmailThread.h"

@interface ListEmail (){
    NSMutableDictionary *mails;
    NSMutableArray *sectionTitleArray;
    NSMutableArray *fieldSelected;
    
    NSMutableDictionary *profiles;
}
@end

@implementation ListEmail
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fieldSelected = [[NSMutableArray alloc] init];
    mails = [[NSMutableDictionary alloc] init];
    sectionTitleArray = [NSMutableArray arrayWithObjects: @"Email Register", @"Email", nil];
    
    ref         = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"EditEmail"]) {
        EditEmail* v = segue.destinationViewController;
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
    // return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    return [mails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    //  NSDictionary* item = [mails objectAtIndex:indexPath.row];
    // label.text = [item objectForKey:@"value"];
    
    
    // id aKey = [keys objectAtIndex:indexPath.row];
    // id anObject = [[all_data objectForKey:[sectionTitleArray objectAtIndex:1]] objectForKey:aKey];
    
    
    NSArray *keys = [mails allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [mails objectForKey:aKey];
    
    label.text = [anObject objectForKey:@"name"];
    
    
    if ([fieldSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
        
        // NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
        
        NSArray *keys = [mails allKeys];
        id aKey = [keys objectAtIndex:indexPath.row];
        id anObject = [mails objectForKey:aKey];

        EditEmail *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmail"];
        v.fction     = @"edit";
        v.item_id    = aKey;
        v.email      = [anObject objectForKey:@"name"];
        
        /*
         EditPhone *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPhone"];
         v.fction = @"edit";
         v.item_id = aKey;
         v.number =[anObject objectForKey:@"phone"];
         */
        
        [self.navigationController pushViewController:v animated:YES];
        
        
    }];
    // blockAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        /*
        NSDictionary* item = [data_profile2 objectAtIndex:indexPath.row];
        NSLog(@"");
         */
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        
        alertView.tag = -999;
        
        alertView.object = @{@"indexPath" : indexPath};

        [alertView show];
        
    }];
    
    return @[hiddenAction, blockAction];
}

-(void)onRegisterTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    
     UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     AnNmousURegister *anNmousURegister =[storybrd instantiateViewControllerWithIdentifier:@"AnNmousURegister"];
     
     // homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
     // homeViewController.title = @"Home";
     // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
     
     // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
     // set register notification
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(AnNmousURegisterRESULT:)
     name:@"AnNmousURegister_RESULT" object:nil];
     
     [self presentViewController:[[UINavigationController alloc] initWithRootViewController:anNmousURegister] animated:YES completion:nil];
}

-(void)AnNmousURegisterRESULT:(NSNotification *)notice{
    NSString *email = [notice object];
    
    // removeObserver : AnNmousURegister_RESULT
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnNmousURegister_RESULT" object:nil];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AnNmousUVerify *anNmousUVerify =[storybrd instantiateViewControllerWithIdentifier:@"AnNmousUVerify"];
    anNmousUVerify.email = email;
    
    // set register notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AnNmousUVerifyRESULT:)
                                                 name:@"AnNmousUVerify_RESULT" object:nil];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:anNmousUVerify] animated:YES completion:nil];
}

-(void)AnNmousUVerifyRESULT:(NSNotification *)notice{
    // NSString *email = [notice object];
    
    NSLog(@"%@", [[notice userInfo] objectForKey:@"email"]);
    
    // NSDictionary *_userInfo = @{@"result" : @"1", @"email" : self.email};
    
    // removeObserver : AnNmousURegister_RESULT
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnNmousUVerify_RESULT" object:nil];
    
    NSLog(@"");
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                NSLog(@"ตกลง");
                
                NSDictionary* userInfo = alertView.object;
                
                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
                
                // NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
                
                NSArray *keys = [mails allKeys];
                id aKey = [keys objectAtIndex:indexPath.row];
                id anObject = [mails objectForKey:aKey];
               
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                if([profiles objectForKey:@"mails"]){
                    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/mails/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], aKey];
                    
                    [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        
                        [[Configs sharedInstance] SVProgressHUD_Dismiss];
                        if (error == nil) {
                            // จะได้ item_id
                            NSString* key = [ref key];
                            
                            if([profiles objectForKey:@"mails"]){
                                NSMutableDictionary *mails = [profiles objectForKey:@"mails"];
                                
                                NSMutableDictionary *newMails = [[NSMutableDictionary alloc] init];
                                [newMails addEntriesFromDictionary:mails];
                                [newMails removeObjectForKey:key];
                                
                                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                                [newProfiles addEntriesFromDictionary:profiles];
                                
                                if ([newProfiles objectForKey:@"mails"]) {
                                    [newProfiles removeObjectForKey:@"mails"];
                                }
                                [newProfiles setValue:newMails forKey:@"mails"];
                                
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
        
        if ([profiles objectForKey:@"mails"]) {
            mails = [profiles objectForKey:@"mails"];
        }
        [self._table reloadData];
    });
}
@end
