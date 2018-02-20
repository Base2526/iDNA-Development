//
//  Tab_Home.m
//  iDNA
//
//  Created by Somkid on 4/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_Home.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UserDataUIAlertView.h"
#import "AddByID.h"
#import "MyProfile.h"
#import "Profiles.h"

@interface Tab_Home (){
    NSMutableDictionary *profile;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

#define kWIDTH          UIScreen.mainScreen.bounds.size.width
@end

@implementation Tab_Home
@synthesize imageProfile, labelName, labelEmail, imageBG, imageV_edit, imageV_qrcode, labelSMessage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)reloadData:(NSNotification *) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        profile = [[Configs sharedInstance] getUserProfiles];
        
        if ([profile objectForKey:@"image_url"]) {
            [imageProfile clear];
            [imageProfile showLoadingWheel];
            [imageProfile setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profile objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageProfile];
        }else{}
        
        labelName.text = [NSString stringWithFormat:@"Name : %@", [profile objectForKey:@"name"]];
        labelEmail.text = [NSString stringWithFormat:@"Email : %@", [profile objectForKey:@"mail"]];
        
        if ([profile objectForKey:@"status_message"]) {
            labelSMessage.text = [NSString stringWithFormat:@"SM : %@", [profile objectForKey:@"status_message"]];
        }else{
            labelSMessage.text = @"SM :";
        }
        
        // BG
        if ([profile objectForKey:@"bg_url"]) {
            
            imageBG.callbackOnSetImage = (id)self;
            [imageBG clear];
            [imageBG showLoadingWheel];
            [imageBG setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profile objectForKey:@"bg_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageBG];
        }else{}
        
        if ([profile objectForKey:@"url_my_qrcode"]) {
            [imageV_qrcode clear];
            [imageV_qrcode showLoadingWheel];
            [imageV_qrcode setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profile objectForKey:@"url_my_qrcode"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_qrcode ];
        }
        
        /* recreate qrcode แก้ปัญหา  user เก่าๆ qrcode ยังผิดอยู่เราจำเป้นต้อง recreate qrcode ให้ใหม่ */
        UITapGestureRecognizer *qrcodeTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleQRCodeTap:)];
        
        imageV_qrcode.userInteractionEnabled = YES;
        [imageV_qrcode addGestureRecognizer:qrcodeTap];
        
        /* recreate qrcode แก้ปัญหา  user เก่าๆ qrcode ยังผิดอยู่เราจำเป้นต้อง recreate qrcode ให้ใหม่ */
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        imageV_edit.userInteractionEnabled = YES;
        [imageV_edit addGestureRecognizer:singleFingerTap];
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (IBAction)onAddFriend:(id)sender {
//    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
//                                                       message:nil
//                                                      delegate:self
//                                             cancelButtonTitle:nil
//                                             otherButtonTitles:@"QRCode", @"By ID", @"Close", nil];
//
//    // alert.userData = section;
//    alert.tag = 1;
//    [alert show];
//}

- (IBAction)onSettings:(id)sender {
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
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
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) managedImageSet:(HJManagedImageV*)mi{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        NSLog(@"");
        
        switch (buttonIndex) {
            case 0:{
                // QRCode
            }
                break;
                
            case 1:{
                // By ID
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AddByID *changeFN = [storybrd instantiateViewControllerWithIdentifier:@"AddByID"];
                
                // changeFN.friend_id = [sortedKeys objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:changeFN animated:YES];
            }
                break;
            case 2:{
                
            }
                break;
        }
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    //    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    Tab_Home* tabHome = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Home"];
    //    UINavigationController* navTabHome = [[UINavigationController alloc] initWithRootViewController:tabHome];
    //    navTabHome.navigationBar.topItem.title = @"My Profile";
    //    [self presentViewController:navTabHome animated:YES completion:nil];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // if (indexPath.section == 0) {
    MyProfile* profile = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
    [self.navigationController pushViewController:profile animated:YES];
    // }
}

-(void)handleQRCodeTap:(UITapGestureRecognizer *)recognizer{
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [Configs sharedInstance].API_URL, [Configs sharedInstance].RECREATE_QRCODE ]];
    
    NSMutableURLRequest *request = [[Configs sharedInstance] setURLRequest_HTTPHeaderField:url];
    // NSLog(@"%@", [request allHTTPHeaderFields]);
    /*
     NSString *dataToSend = [[NSString alloc] initWithFormat:@"uid=%@&platform=%@&bundleidentifier=%@", [[Configs sharedInstance] getUIDU], @"ios", [[Configs sharedInstance] getBundleIdentifier] ];
     [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
     */
    
    NSDictionary *jsonBodyDict = @{@"uid":[[Configs sharedInstance] getUIDU]};
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if (error == nil) {
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                [newProfiles addEntriesFromDictionary:profile];

                if ([newProfiles objectForKey:@"url_my_qrcode"]) {
                    [newProfiles removeObjectForKey:@"url_my_qrcode"];
                }
                
                [newProfiles setValue:jsonDict[@"url_my_qrcode"] forKey:@"url_my_qrcode"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
            
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error."];
        }
    }];
    
    [postDataTask resume];
}

@end
