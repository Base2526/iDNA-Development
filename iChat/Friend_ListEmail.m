//
//  ListEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "Friend_ListEmail.h"

#import "Configs.h"
#import "EditEmail.h"
#import "Configs.h"
#import "AnNmousURegister.h"
#import "AnNmousUVerify.h"
#import "CustomAlertView.h"
#import "EditEmailThread.h"

#import "ProfilesRepo.h"
#import "FriendProfileRepo.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "SVProgressHUD.h"

@interface Friend_ListEmail ()<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
    NSMutableDictionary *mails;
    NSMutableArray *sectionTitleArray;
    NSMutableArray *fieldSelected;
    
//    ProfilesRepo *profilesRepo;
//    NSMutableDictionary *profiles;
    
    FriendProfileRepo *friendProfileRepo;
    
    NSMutableDictionary *friend_profile;
}
@end

@implementation Friend_ListEmail
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fieldSelected = [[NSMutableArray alloc] init];
    mails = [[NSMutableDictionary alloc] init];
    sectionTitleArray = [NSMutableArray arrayWithObjects: @"Email Register", @"Email", nil];
    
    ref         = [[FIRDatabase database] reference];
    friendProfileRepo = [[FriendProfileRepo alloc] init];
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // return  3;//[data_profile2 count];
    
    return [mails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
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
    /*
    switch (indexPath.section) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            //the below code will allow multiple selection
            if ([fieldSelected containsObject:indexPath]){
                [fieldSelected removeObject:indexPath];
            }else{
                [fieldSelected addObject:indexPath];
            }
        }
            break;
            
        default:
            break;
    }
    */
    
    NSArray *keys = [mails allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [mails objectForKey:aKey];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"iDNA"];
        [mailCont setToRecipients:[NSArray arrayWithObject:[anObject objectForKey:@"name"]]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
        
        NSString* URLEMail =[NSString stringWithFormat:@"mailto:%@?subject=subject&body=body", [anObject objectForKey:@"name"]];
        
        NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }
    
    [self reloadData:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    switch (indexPath.section) {
//        case 1:
//        {
//            return YES;
//        }
//            break;
//
//        default:
//            break;
//    }
    return NO;
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

//- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (alertView.tag) {
//        case -999:
//            if (buttonIndex == 0){
//                NSLog(@"ยกเลิก");
//            }else{
//                NSLog(@"ตกลง");
//
//                NSDictionary* userInfo = alertView.object;
//
//                NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
//
//                // NSMutableDictionary *_items = [mails objectForKey:[sectionTitleArray objectAtIndex:1]];
//
//                NSArray *keys = [mails allKeys];
//                id aKey = [keys objectAtIndex:indexPath.row];
//                id anObject = [mails objectForKey:aKey];
//
//                // NSString* email = [[_items objectAtIndex:indexPath.row] objectForKey:@"value"];
//
//
//                /*
//                 NSMutableDictionary *_items = [all_data objectForKey:[sectionTitleArray objectAtIndex:1]];
//
//                 NSArray *keys = [_items allKeys];
//                 id aKey = [keys objectAtIndex:indexPath.row];
//                 id anObject = [_items objectForKey:aKey];
//
//                 EditEmail *v = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmail"];
//                 v.fction     = @"edit";
//                 v.item_id    = aKey;
//                 v.email      = [anObject objectForKey:@"email"];
//                 */
//
//                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
//
//                EditEmailThread *editPhone = [[EditEmailThread alloc] init];
//                [editPhone setCompletionHandler:^(NSData *data) {
//
//                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//
//                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
//
//                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//
//                        NSMutableDictionary * mails = [[profiles objectForKey:@"mails"] mutableCopy];
//
//                        if ([mails objectForKey:jsonDict[@"item_id"]]) {
//
//                            // [phones setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
//                            [mails removeObjectForKey:jsonDict[@"item_id"]];
//
//                            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
//                            [newProfile addEntriesFromDictionary:profiles];
//                            [newProfile removeObjectForKey:@"mails"];
//                            [newProfile setObject:mails forKey:@"mails"];
//
//                            NSArray *profile = [profilesRepo get];
//
//                            Profiles *pf = [[Profiles alloc] init];
//                            NSError * err;
//                            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfile options:0 error:&err];
//                            pf.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//                            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
//                            pf.update    = [timeStampObj stringValue];
//
//                            BOOL sv = [profilesRepo update:pf];
//                        }
//
//
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            // code here
//                            [self reloadData:nil];
//                        });
//                    }else{
//                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
//                    }
//                }];
//
//                [editPhone setErrorHandler:^(NSString *error) {
//                    NSLog(@"%@", error);
//                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
//
//                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
//                }];
//                // self.number
//                [editPhone start:@"delete" :aKey : @""];
//            }
//
//            break;
//
//        default:
//            break;
//    }
//}

-(void)reloadData:(NSNotification *) notification{
    /*
    if([[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"]){
        mails = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"mails"];
        if ([mails count] > 0) {
            self._table.hidden = NO;
            // self.emptyMessage.hidden = YES;
        }
    }else{
        mails = [[NSMutableDictionary alloc] init];
        self._table.hidden = YES;
        // self.emptyMessage.hidden = NO;
    }
    */
    
    
    // self._table.hidden = YES;
    
    /*
    if ([[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] objectForKey:@"profile"] objectForKey:@"mails"]) {
        NSDictionary* mails = [[[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] objectForKey:@"profile"] objectForKey:@"mails"];
        
        NSLog(@"%@", mails);
        if ([mails count] > 0) {
            self._table.hidden = NO;
            
            for (NSString* key in mails) {
                NSDictionary* value = [mails objectForKey:key];
                if ([[value objectForKey:@"enabled"] isEqualToString:@"1"]) {
                    if ([[value objectForKey:@"level"] isEqualToString:@"0"]) {
                        [all_data setValue:value forKey:[sectionTitleArray objectAtIndex:0]];
                        
                        // Email
                        NSMutableDictionary*_mails = [mails mutableCopy];
                        [_mails removeObjectForKey:key];

                        [all_data setValue:_mails forKey:[sectionTitleArray objectAtIndex:1]];
                        break;
                    }
                }
            }
        }
    }
    */
    
//    NSArray *pf = [profilesRepo get];
//    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
//
//    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//    if ([profiles objectForKey:@"mails"]) {
//        mails = [profiles objectForKey:@"mails"];
//    }
    
    // [self._table reloadData];
    
    NSArray *fprofile = [friendProfileRepo get:self.friend_id];
    NSData *data =  [[fprofile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    friend_profile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([friend_profile objectForKey:@"mails"]) {
        mails = [friend_profile objectForKey:@"mails"];
    }
    
    [self._table reloadData];
}

#pragma mark -  to the delegate:
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            // NSLog(@"You sent the email.");
            
            [SVProgressHUD showSuccessWithStatus:@"You sent the email."];
            break;
        case MFMailComposeResultSaved:
            // NSLog(@"You saved a draft of this email");
            
            [SVProgressHUD showSuccessWithStatus:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            // NSLog(@"You cancelled sending this email.");
            
            // [SVProgressHUD showErrorWithStatus:@"You cancelled sending this email."];
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            
            [SVProgressHUD showErrorWithStatus:@"Mail failed:  An error occurred when trying to compose this email."];
            break;
        default:
            // NSLog(@"An error occurred when trying to compose this email");
            
            [SVProgressHUD showErrorWithStatus:@"An error occurred when trying to compose this email."];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
