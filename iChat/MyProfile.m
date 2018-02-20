//
//  MyProfile.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "MyProfile.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "ListClasss.h"
#import "UpdatePictureProfileThread.h"
#import "UpdateMyProfileThread.h"
#import "UpdatePictureBGThread.h"
#import "ListClasss.h"
#import "TopAlignedLabel.h"
#import "HJManagedImageV.h"
#import "EditDisplayName.h"
#import "Profiles.h"
#import "EditStatusMessage.h"
#import "EditAddress.h"
#import "ListPhone.h"
#import "ListEmail.h"
#import "Gender.h"
#import "Birthday.h"
#import "SetMyID.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MyFacebook.h"
#import "MyQRCode.h"

@interface MyProfile ()<FBSDKLoginButtonDelegate>{
    FBSDKLoginButton *loginButton;
    NSMutableDictionary *profiles;
    
    FIRDatabaseReference *ref;
}
@end

@implementation MyProfile
//@synthesize imageV, imageV_QRCode, imageV_bg, ref, txtFName, lblEmail, txtFStatus;
@synthesize imagePicker, isMenu;
//@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref         = [[FIRDatabase database] reference];
    [self fb];
    
    if (isMenu != nil) {
        UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Close"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(closeView:)];
        self.navigationItem.leftBarButtonItem = flipButton;
        // [flipButton release];
    }
}

-(IBAction)closeView:(id)sender
{
    //Your code here
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /*
         จะ call ทุกครั้งที refresh ซึงไม่ถูกแต่ทำงานได้ เอาแบบนี้ไม่ก่อน วิธีการที่ถูกต้อง check ว่าข้อมูลเปลียมแปลงหรือเปล่าค่อย เรียก
         */
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab_Contacts_reloadData" object:self userInfo:@{}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

// กรณีเปิด จะมีการ hide Tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

// ------------- fb
-(void)fb{
    // https://stackoverflow.com/questions/35160329/custom-facebook-login-button-ios/35160568
    loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    // loginButton.center = self.view.center;
    loginButton.hidden = YES;
    
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    
    // [self.view addSubview:loginButton];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
}
    
- (void)  loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error{
    //use your custom code here
    //redirect after successful login
    
    if (error){
        // Process error
        NSLog(@"");
    }
    else if (result.isCancelled){
        // Handle cancellations
        NSLog(@"");
    }
    else{
        NSLog(@"User ID: %@",[FBSDKAccessToken currentAccessToken]);
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        if ([result.grantedPermissions containsObject:@"email"])
        {
            NSLog(@"result is:%@",result);
            [self fetchUserInfo];
        }
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    //use your custom code here
    //redirect after successful logout
    NSLog(@"");
}
    
-(void)fetchUserInfo {
    
    // [FBSDKAccessToken setCurrentAccessToken:@""];
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 
                 NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                 [newProfiles addEntriesFromDictionary:profiles];
                 
                 if([newProfiles objectForKey:@"facebook"]){
                     [newProfiles removeObjectForKey:@"facebook"];
                 }
                 [newProfiles setValue:result forKey:@"facebook"];
                 
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                 
                 NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                 NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
                 
                 [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                     
                     [[Configs sharedInstance] SVProgressHUD_Dismiss];
                     if (error == nil) {
                         FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                         [loginManager logOut];
                         
                         [FBSDKAccessToken setCurrentAccessToken:nil];
                         
                         [self reloadData:nil];
                     }else{
                         [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update name."];
                     }
                 }];
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
    }
}
// ------------- fb

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles = [[Configs sharedInstance] getUserProfiles];
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"cell_picture_profile"];
            
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            UILabel *label1         = [cell viewWithTag:10];
            HJManagedImageV *imageV = [cell viewWithTag:11];
            
            if ([profiles objectForKey:@"image_url"]) {
                [imageV clear];
                [imageV showLoadingWheel];
                
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            }
            
            return cell;
        }
            break;
            
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"ชื่อ :"];
        
            [label2 setText:[profiles objectForKey:@"name"]];
            return cell;
        }
             break;
            
            // my id
        case 2:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"My ID :"];
            
            if ([profiles objectForKey:@"my_id"]) {
                
                NSDictionary *my_id = [profiles objectForKey:@"my_id"];
                
                for (NSString* key in my_id) {
                    NSDictionary* value = [my_id objectForKey:key];
                    [label2 setText:[value objectForKey:@"value"]];
                    
                    if ([[value objectForKey:@"is_edit"] isEqualToString:@"1"]) {
                        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.accessoryType  = UITableViewCellAccessoryNone;
                    }
                }
            }else{
                [label2 setText:[profiles objectForKey:@"-"]];
            }
            return cell;
        }
            break;
            
            // Status message
        case 3:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"ข้อความ :"];
            
            // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            
            if ([profiles objectForKey:@"status_message"]) {
                [label2 setText:[profiles objectForKey:@"status_message"]];
            }else{
                [label2 setText:[profiles objectForKey:@"-"]];
            }
            
            return cell;
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_address"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextView *textAddress = [cell viewWithTag:10];
                    
            if ([profiles objectForKey:@"address"]) {
                [textAddress setText:[profiles objectForKey:@"address"]];
            }else{
                [textAddress setText:[profiles objectForKey:@"-"]];
            }
            
            return cell;
        }
            break;
            
        case 5:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Emails :"];
            
            if ([profiles objectForKey:@"mails"]) {
                NSDictionary *mails = [profiles objectForKey:@"mails"];
                label2.text =[NSString stringWithFormat:@"%d", [mails count]]  ;
            }else{
                label2.text = @"not email";
            }
            
            return cell;
        }
            
        case 6:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Phones :"];
            
            if ([profiles objectForKey:@"phones"]) {
                NSDictionary *phones = [profiles objectForKey:@"phones"];
                label2.text = [NSString stringWithFormat:@"%d", [phones count]];
            }else{
                label2.text = @"not phones";
            }
            
            return cell;
        }
            
        case 7:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_picture_profile"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            HJManagedImageV *imageV = [cell viewWithTag:11];
            
            [label1 setText:@"BG :"];
            
            // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            if ([profiles objectForKey:@"bg_url"]) {
                [imageV clear];
                [imageV showLoadingWheel];
                
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"bg_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            }
            return cell;
        }
            
        case 8:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Gender :"];
            
            if ([profiles objectForKey:@"gender"]) {
                
                NSDictionary* gd = [[Configs sharedInstance] loadData:_GENDER];
                // NSString* key = [sortedKeys objectAtIndex:indexPath.row];
                id anObject = [gd objectForKey:[profiles objectForKey:@"gender"]];
                
                // [labelName setText:[anObject objectForKey:@"name"]];
                [label2 setText:[anObject objectForKey:@"name"]];
            }else{
                [label2 setText:@""];
            }
            return cell;
        }
            
        case 9:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Age :"];
            [label2 setText:@""];
            
            if ([profiles objectForKey:@"birthday"]) {
                // selectedIndex = [profiles objectForKey:@"birthday"];
                
                NSTimeInterval timestamp = [[profiles objectForKey:@"birthday"] doubleValue];
                NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
                
                label2.text = [[self getDateFormatter]  stringFromDate:lastUpdate];
            }
            return cell;
        }
            
        case 10:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"School :"];
            [label2 setText:@""];
            
            if ([profiles objectForKey:@"school"]) {
                [label2 setText:[profiles objectForKey:@"school"]];
            }else{
                [label2 setText:@""];
            }
            return cell;
        }
            
        case 11:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Company :"];
            // [label2 setText:@""];
            
            if ([profiles objectForKey:@"company"]) {
                [label2 setText:[profiles objectForKey:@"company"]];
            }else{
                [label2 setText:@""];
            }
            return cell;
        }
        
        case 12:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_facebook"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            
            UILabel *subtext        = [cell viewWithTag:10];
            HJManagedImageV *imageV = [cell viewWithTag:11];
            UILabel *nametext       = [cell viewWithTag:12];
            UILabel *emailtext      = [cell viewWithTag:13];
            
            [subtext setText:@"Facebook :"];
            [nametext setText:@""];
            [emailtext setText:@""];
            
            [imageV clear];
            
            if ([profiles objectForKey:@"facebook"]) {
                NSDictionary *facebook = [profiles objectForKey:@"facebook"];
                
                if([facebook objectForKey:@"name"]){
                    [nametext setText:[facebook objectForKey:@"name"]];
                }else{
                    [nametext setText:@""];
                }
                
                if([facebook objectForKey:@"email"]){
                    [emailtext setText:[facebook objectForKey:@"email"]];
                }else{
                    [emailtext setText:@""];
                }
                
                if([facebook objectForKey:@"picture"]){
                    NSDictionary *picture = [facebook objectForKey:@"picture"];
                    
                    if ([picture objectForKey:@"data"]) {
                        [imageV clear];
                        [imageV showLoadingWheel];
                        
                        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[picture objectForKey:@"data"] objectForKey:@"url"]  ]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
                    }
                }else{
                    
                }
            }else{
                [nametext setText:@"not facebook"];
            }
            
            return cell;
        }
        
            break;
            
        // qrcode
        case 13:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"QRCode :"];
            [label2 setText:@""];
            
//            if ([profiles objectForKey:@"my_id"]) {
//                [label2 setText:[profiles objectForKey:@"my_id"]];
//            }else{
//                [label2 setText:[profiles objectForKey:@"-"]];
//            }
            return cell;
        }
            break;
            
        case 14:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_text"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label1 = [cell viewWithTag:10];
            UILabel *label2 = [cell viewWithTag:11];
            
            [label1 setText:@"Line ID :"];
            [label2 setText:@""];
            
            if ([profiles objectForKey:@"line_id"]) {
                [label2 setText:[profiles objectForKey:@"line_id"]];
            }else{
                [label2 setText:[profiles objectForKey:@"-"]];
            }
            return cell;
        }
            break;
        default:{
            
        }
            break;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:/*@"Take Photo", */ @"Library", nil];
            
            actionSheet.tag = 101;
            [actionSheet showInView:self.view];
                
            }
            break;
            
        case 1:{
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                 EditDisplayName* ed = [storybrd instantiateViewControllerWithIdentifier:@"EditDisplayName"];
                 ed.uid = [[Configs sharedInstance] getUIDU];
                 [self.navigationController pushViewController:ed animated:YES];
             });
        }
            break;
            
        case 2:{            
            
            if ([profiles objectForKey:@"my_id"]) {
                /*
                NSDictionary *my_id = [profiles objectForKey:@"my_id"];
                if ([[my_id objectForKey:@"is_edit"] isEqualToString:@"1"]) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                         SetMyID* ed = [storybrd instantiateViewControllerWithIdentifier:@"SetMyID"];
                         [self.navigationController pushViewController:ed animated:YES];
                     });
                }
                */
                
                NSDictionary *my_id = [profiles objectForKey:@"my_id"];
                for (NSString* key in my_id) {
                    NSDictionary* value = [my_id objectForKey:key];
                    
                    if ([[value objectForKey:@"is_edit"] isEqualToString:@"1"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            SetMyID* ed = [storybrd instantiateViewControllerWithIdentifier:@"SetMyID"];
                            [self.navigationController pushViewController:ed animated:YES];
                        });
                    }
                }
            }
        }
            break;
            
        case 3:{
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 EditStatusMessage* editStatusMessage = [storybrd instantiateViewControllerWithIdentifier:@"EditStatusMessage"];
                 
                 if ([profiles objectForKey:@"status_message"]) {
                     editStatusMessage.message = [profiles objectForKey:@"status_message"];
                 }else{
                     editStatusMessage.message = @"";
                 }
                 [self.navigationController pushViewController:editStatusMessage animated:YES];
             });
        }
            break;
            
        case 4:{
            // NSLog(@"Address");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"address";
                [self.navigationController pushViewController:editAddress animated:YES];
            });
        }
            break;
            
        case 5:{
            // Email
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ListEmail *v = [storybrd instantiateViewControllerWithIdentifier:@"ListEmail"];
                [self.navigationController pushViewController:v animated:YES];
            });
        }
            break;
            
        case 6:{
            // Phone
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                ListPhone *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPhone"];
                [self.navigationController pushViewController:v animated:YES];
            });
        }
            break;
        
        case 7:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles: /*@"Take Photo",*/ @"Library", nil];
            
            actionSheet.tag = 102;
            [actionSheet showInView:self.view];
        }
            break;
            
        case 8:{
            // Gender
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                Gender *v = [storybrd instantiateViewControllerWithIdentifier:@"Gender"];
                [self.navigationController pushViewController:v animated:YES];
            });
        }
            break;
            
        case 9:{
            // Birthday
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                Birthday *v = [storybrd instantiateViewControllerWithIdentifier:@"Birthday"];
                [self.navigationController pushViewController:v animated:YES];
            });
        }
            break;
            
            
        case 10:{
            // School
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"school";
                [self.navigationController pushViewController:editAddress animated:YES];
            });
        }
            break;
            
        case 11:{
            // Company
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"company";
                [self.navigationController pushViewController:editAddress animated:YES];
            });
        }
            break;
        
        case 12:{
            // facebook
            
            if ([profiles objectForKey:@"facebook"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MyFacebook* myFacebook = [storybrd instantiateViewControllerWithIdentifier:@"MyFacebook"];
                    [self.navigationController pushViewController:myFacebook animated:YES];
                });
            }else{
                [loginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
            }
        }
        break;
            
        case 13:{
            // MyQRCode
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MyQRCode* qrcode = [storybrd instantiateViewControllerWithIdentifier:@"MyQRCode"];
                [self.navigationController pushViewController:qrcode animated:YES];
            });
        }
            break;
            
        case 14:{
            // Line ID
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EditAddress* editAddress = [storybrd instantiateViewControllerWithIdentifier:@"EditAddress"];
                editAddress.type = @"line_id";
                [self.navigationController pushViewController:editAddress animated:YES];
            });
        }
            break;
            
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
                /*
            case 0:{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                */
            case 0:{
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                    });
                }
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (buttonIndex) {
                /*
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                */
            case 0:
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                    });
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
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            
            if ([newProfiles objectForKey:@"image_url"]) {
                [newProfiles removeObjectForKey:@"image_url"];
            }
            [newProfiles setValue:jsonDict[@"url"] forKey:@"image_url"];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
            
            [self reloadData:nil];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:image];
}

-(void)updateBGPicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureBGThread *updateBGThread = [[UpdatePictureBGThread alloc] init];
    [updateBGThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
           
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            
            if ([newProfiles objectForKey:@"bg_url"]) {
                [newProfiles removeObjectForKey:@"bg_url"];
            }
            
            [newProfiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
           
            [self reloadData:nil];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [updateBGThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updateBGThread start:image];
}

-(NSDateFormatter *)getDateFormatter{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormat;
}

- (IBAction)onShare:(id)sender {
    
    NSString *textToShare = @"iDNA iOS Developers!";
    // @"http://188.166.208.70/profile-main/729"
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/profile-main/%@", [Configs sharedInstance].API_URL, [[Configs sharedInstance] getUIDU] ] ];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });
}
@end
