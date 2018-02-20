//
//  FriendProfile.m
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//
#import "FriendProfileView.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UpdatePictureProfileThread.h"
#import "UpdateMyProfileThread.h"
#import "FriendProfileRepo.h"
#import "SelectFriendClasss.h"
#import "Classs.h"
#import "ClasssRepo.h"
#import "FriendsRepo.h"
#import "ProfilesRepo.h"
#import "Friend_ListEmail.h"
#import "Friend_ListPhone.h"
#import "ChatViewController.h"

@interface FriendProfileView (){
    FriendProfileRepo *friendProfileRepo;
    FriendsRepo *friendRepo;
    
    NSMutableDictionary *friend_profile;
}
@end

@implementation FriendProfileView
@synthesize imagePicker, ref, friend_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref = [[FIRDatabase database] reference];
    friendProfileRepo = [[FriendProfileRepo alloc] init];
    friendRepo        = [[FriendsRepo alloc] init];
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

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    NSArray *fprofile = [friendProfileRepo get:friend_id];
    NSData *data =  [[fprofile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    friend_profile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            case 0:{
                UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"cell_picture_profile"];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle     = UITableViewCellSelectionStyleNone;
                UILabel *label1         = [cell viewWithTag:10];
                HJManagedImageV *imageV = [cell viewWithTag:11];
                
                if ([friend_profile objectForKey:@"image_url"]) {
                    [imageV clear];
                    [imageV showLoadingWheel];
                    
                    [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[friend_profile objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
                }
                
                return cell;
            }
            break;
            
            case 1:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *label1 = [cell viewWithTag:10];
                UILabel *label2 = [cell viewWithTag:11];
                
                [label1 setText:@"ชื่อ :"];
                
                [label2 setText:[friend_profile objectForKey:@"name"]];
                return cell;
            }
            break;
            
            case 2:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *label1 = [cell viewWithTag:10];
                UILabel *label2 = [cell viewWithTag:11];
                
                [label1 setText:@"Emails :"];
                
                //            NSArray *pf = [profilesRepo get];
                //            NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                //
                //            profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([friend_profile objectForKey:@"mails"]) {
                    NSDictionary *mails = [friend_profile objectForKey:@"mails"];
                    label2.text =[NSString stringWithFormat:@"%d", [mails count]]  ;
                }else{
                    label2.text = @"not email";
                }
                
                return cell;
            }
            
            case 3:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *label1 = [cell viewWithTag:10];
                UILabel *label2 = [cell viewWithTag:11];
                
                [label1 setText:@"Phones :"];
                
                if ([friend_profile objectForKey:@"phones"]) {
                    NSDictionary *phones = [friend_profile objectForKey:@"phones"];
                    label2.text = [NSString stringWithFormat:@"%d", [phones count]];
                }else{
                    label2.text = @"not phones";
                }
                
                return cell;
            }
            
        case 4:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Classs :"];
            
            NSArray *val =  [friendRepo get:friend_id];
            NSDictionary* fc = [NSJSONSerialization JSONObjectWithData:[[val objectAtIndex:[friendRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
             label2.text = @"not classs";
            if ([fc objectForKey:@"classs"]) {
                ClasssRepo * classsRepo = [[ClasssRepo alloc] init];
                NSArray *class = [classsRepo get:[fc objectForKey:@"classs"]];
                
                NSData *class_data =  [[class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                if (class_data == nil) {
                    NSLog(@"");
                    
                }else{
                NSMutableDictionary *tmp = [NSJSONSerialization JSONObjectWithData:class_data options:0 error:nil];
                
                label2.text = [tmp objectForKey:@"name"];
                }
            }
            
            return cell;
        }
            
        case 5:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Line ID :"];

            if ([friend_profile objectForKey:@"line_id"]) {
            
                [label2 setText:[friend_profile objectForKey:@"line_id"]];;
            }else{
                label2.text = @"not line id";
            }
            
            return cell;
        }
            
        case 6:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Facebook :"];
            
            if ([friend_profile objectForKey:@"facebook"]) {
                
                NSDictionary *facebook = [friend_profile objectForKey:@"facebook"];
                [label2 setText:[facebook objectForKey:@"name"]];;
            }else{
                label2.text = @"not facebook";
            }
            
            return cell;
        }
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            return cell;
        }
            break;
    }
    
    return nil;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            case 2:{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                Friend_ListEmail* friendListEmail = [storybrd instantiateViewControllerWithIdentifier:@"Friend_ListEmail"];
                friendListEmail.friend_id = friend_id;
                [self.navigationController pushViewController:friendListEmail animated:YES];
            }
            break;
            
            case 3:{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                Friend_ListPhone* friendListPhone = [storybrd instantiateViewControllerWithIdentifier:@"Friend_ListPhone"];
                friendListPhone.friend_id = friend_id;
                [self.navigationController pushViewController:friendListPhone animated:YES];
            }
            break;
            
            case 4:{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                SelectFriendClasss* selectFriendClasss = [storybrd instantiateViewControllerWithIdentifier:@"SelectFriendClasss"];
                selectFriendClasss.friend_id = friend_id;
                [self.navigationController pushViewController:selectFriendClasss animated:YES];
            }
            break;
            
            case 5:{
                
                if ([friend_profile objectForKey:@"line_id"]) {
                    
                    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://line.me/ti/p/~%@", [friend_profile objectForKey:@"line_id"]]];
                    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
                        [[UIApplication sharedApplication] openURL: appURL];
                    }
                    else { //如果使用者沒有安裝，連結到App Store
                        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
                        [[UIApplication sharedApplication] openURL:itunesURL];
                    }
                }else{
                    
                }
            }
            break;
            
            case 6:{
                if ([friend_profile objectForKey:@"facebook"]) {
                    NSDictionary *facebook = [friend_profile objectForKey:@"facebook"];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [facebook objectForKey:@"link"] ]];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            break;
            default:{
                
            }
            break;
    }
    /*
    switch (indexPath.row) {
            case 0:{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancel"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Take Photo", @"Library", nil];
                
                actionSheet.tag = 101;
                [actionSheet showInView:self.view];
                
            }
            break;
            
            case 1:{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                EditDisplayName* ed = [storybrd instantiateViewControllerWithIdentifier:@"EditDisplayName"];
                ed.uid = [[Configs sharedInstance] getUIDU];
                [self.navigationController pushViewController:ed animated:YES];
            }
            break;
            
            case 2:{
                // NSLog(@"My ID");
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SetMyID* ed = [storybrd instantiateViewControllerWithIdentifier:@"SetMyID"];
                // ed.uid = [[Configs sharedInstance] getUIDU];
                [self.navigationController pushViewController:ed animated:YES];
            }
            break;
            
            case 3:{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditStatusMessage* editStatusMessage = [storybrd instantiateViewControllerWithIdentifier:@"EditStatusMessage"];
                
                if ([profiles objectForKey:@"status_message"]) {
                    editStatusMessage.message = [profiles objectForKey:@"status_message"];
                }else{
                    editStatusMessage.message = @"";
                }
                [self.navigationController pushViewController:editStatusMessage animated:YES];
            }
            break;
            
            case 4:{
                // NSLog(@"Address");
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"address";
                [self.navigationController pushViewController:editAddress animated:YES];
            }
            break;
            
            case 5:{
                // Email
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ListEmail *v = [storybrd instantiateViewControllerWithIdentifier:@"ListEmail"];
                [self.navigationController pushViewController:v animated:YES];
            }
            break;
            
            case 6:{
                // Phone
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ListPhone *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPhone"];
                [self.navigationController pushViewController:v animated:YES];
            }
            break;
            
            case 7:{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancel"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Take Photo", @"Library", nil];
                
                actionSheet.tag = 102;
                [actionSheet showInView:self.view];
            }
            break;
            
            case 8:{
                // Gender
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                Gender *v = [storybrd instantiateViewControllerWithIdentifier:@"Gender"];
                [self.navigationController pushViewController:v animated:YES];
            }
            break;
            
            case 9:{
                // Birthday
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                Birthday *v = [storybrd instantiateViewControllerWithIdentifier:@"Birthday"];
                [self.navigationController pushViewController:v animated:YES];
            }
            break;
            
            
            case 10:{
                // School
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"school";
                [self.navigationController pushViewController:editAddress animated:YES];
            }
            break;
            
            case 11:{
                // Company
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"company";
                [self.navigationController pushViewController:editAddress animated:YES];
            }
            break;
            
        default:
            break;
    }
    */
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
                case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
                case 1:
            {
                NSLog(@"");
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                self.imagePicker._tag = @"profile";
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (buttonIndex) {
                case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
                case 1:
            {
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                self.imagePicker._tag = @"bg";
                
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                            inView:self.view
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"%@", imagePicker._tag);
    
    if ([imagePicker._tag isEqualToString:@"profile"]) {
        [self updateProfilePicture:image];
    }else{
        
        [self updateBGPicture:image];
    }
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        // [self.popoverController dismissPopoverAnimated:YES];
        
        [self.popoverController dismissPopoverAnimated:NO];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)updateProfilePicture:(UIImage *)image{
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSArray *pf = [profileRepo get];
            NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"image_url"];
            [newProfiles setValue:jsonDict[@"url"] forKey:@"image_url"];
            
            Profiles *pfs = [[Profiles alloc] init];
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
            pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            pfs.update    = [timeStampObj stringValue];
            
            BOOL sv = [profileRepo update:pfs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData:nil];
            });
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:image];
    */
}

-(void)updateBGPicture:(UIImage *)image{
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureBGThread *updateBGThread = [[UpdatePictureBGThread alloc] init];
    [updateBGThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSArray *pf = [profileRepo get];
            NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"bg_url"];
            [newProfiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            Profiles *pfs = [[Profiles alloc] init];
            NSError * err;
            NSData * jsonData    = [NSJSONSerialization dataWithJSONObject:newProfiles options:0 error:&err];
            pfs.data   = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            pfs.update    = [timeStampObj stringValue];
            
            BOOL sv = [profileRepo update:pfs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData:nil];
            });
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [updateBGThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updateBGThread start:image];
    */
}

-(NSDateFormatter *)getDateFormatter{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormat;
}

- (IBAction)onChat:(id)sender {
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *cV = [storybrd instantiateViewControllerWithIdentifier:@"ChatViewController"];
    cV.type      = @"private";
    cV.friend_id = friend_id;
    [self.navigationController pushViewController:cV animated:YES];
}
@end

