//
//  MyID2.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "MyID.h"
#import "MyIDHeaderCell.h"
#import "HJManagedImageV.h"
#import "AppConstant.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "GKImagePicker.h"
#import "EditDisplayName.h"
#import "MyQRCode.h"
#import "SVProgressHUD.h"
#import "UpdatePictureProfileThread.h"
#import "EditPhone.h"
#import "ViewImageView.h"
#import "EditStatusMessage.h"
#import "SetMyID.h"
#import "AnNmousURegister.h"
#import "AnNmousUVerify.h"
#import "Utility.h"
#import "ListEmail.h"
#import "ListPhone.h"

@interface MyID ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSArray *all_data;
    UIImage *img;
    
    NSMutableArray *childObservers;
    NSMutableDictionary *profile;
}

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) NSUserDefaults *preferences;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation MyID
@synthesize ref;
@synthesize preferences;
@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    all_data = [[NSArray alloc] initWithObjects:@"Cell-DisplayName", @"Cell-Email", @"Cell-MyID", @"Cell-Phone", @"Cell-MyQRCode", @"Cell-Status", nil];
    
    preferences = [NSUserDefaults standardUserDefaults];
    ref = [[FIRDatabase database] reference];
    childObservers = [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
    
    // http://stackoverflow.com/questions/26022245/removeallobservers-observer-not-removed/27329738#27329738
    //for (FIRDatabaseReference *ref in childObservers) {
    //    [ref removeAllObservers];
    // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData:(NSNotification *) notification
{
    profile = [[Configs sharedInstance] loadData:_DATA];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [all_data count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyIDHeaderCell" owner:self options:nil];
    UIView *view = [viewArray objectAtIndex:0];
    HJManagedImageV *hjmPicture = [view viewWithTag:100];

    if ([profile objectForKey:@"picture"]) {
        if (img != nil) {
            [UIView transitionWithView:hjmPicture
                              duration:5.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                hjmPicture.image = img;
                                
                                img = nil;
                            } completion:nil];
        }else{
            NSDictionary *picture = [profile objectForKey:@"picture"];
            NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 
  
            [hjmPicture clear];
            [hjmPicture showLoadingWheel];
            [hjmPicture setUrl:[NSURL URLWithString:url]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmPicture ];
        }
    }else{
        [hjmPicture setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
    }
    
    hjmPicture.userInteractionEnabled = YES;
    [hjmPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[all_data objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:{
            UILabel *label = (UILabel *)[cell viewWithTag:101];
            label.text = [profile objectForKey:@"display_name"];//[_dict objectForKey:@"user"][@"name"];
            
            break;
        }
        case 1:{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *label = (UILabel *)[cell viewWithTag:102];

            if ([profile objectForKey:@"mails"]) {
                NSDictionary *mails = [profile objectForKey:@"mails"];
                label.text = [NSString stringWithFormat:@"%d Email", [mails count]];
            }else{
                label.text = @"Not Set";
            }
            
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mailTapped:)]];
            
            break;
        }
        case 2:{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            UILabel *label = (UILabel *)[cell viewWithTag:103];

            if ([profile objectForKey:@"my_id"]) {
                label.text = [profile objectForKey:@"my_id"];
            }else{
                label.text = @"Not Set";
            }
            
            break;
        }
        case 3:{
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UILabel *label = (UILabel *)[cell viewWithTag:104];
            
            if ([profile objectForKey:@"phones"]) {
                NSDictionary *phones = [profile objectForKey:@"phones"];
                
                label.text = [NSString stringWithFormat:@"%d Number", [phones count]];
            }else{
                label.text =@"Not Set";
            }
            
            break;
        }
            
        case 5:{
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UITextView *textView = (UITextView *)[cell viewWithTag:105];
            
            textView.userInteractionEnabled = NO;
            // [textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

            if ([profile objectForKey:@"status_message"]) {
                [textView setText:[profile objectForKey:@"status_message"]];
            }else{
                [textView setText:@"Not Set"];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv     contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 3:{
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ListPhone *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPhone"];
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [self reloadData:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    // NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    
    if ([segue.identifier isEqualToString:@"DisplayName"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        EditDisplayName* v = segue.destinationViewController;
        // v.name = [profile objectForKey:@"display_name"];
        // v.isfriend = @"0";
        
    }else if ([segue.identifier isEqualToString:@"MyQRCode"]) {
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MyQRCode* v = segue.destinationViewController;
        
        NSString * BI =[[[Configs sharedInstance] getBundleIdentifier] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        
        NSString *filename = [[[[profile objectForKey:@"qr"] objectForKey:@"ios"] objectForKey:BI] objectForKey:@"filename"];
        
        // v.uri = [[NSString stringWithFormat:@"%@/sites/default/files/qrcode/%@", [Configs sharedInstance].API_URL, filename] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
    }else if([segue.identifier isEqualToString:@"StatusMessage"]){
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        EditStatusMessage* v = segue.destinationViewController;
        if ([profile objectForKey:@"status_message"]) {
            v.message = [profile objectForKey:@"status_message"];
        }else{
            v.message = @"";
        }
        
    }else if([segue.identifier isEqualToString:@"SetMyID"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SetMyID* v = segue.destinationViewController;
                
        if ([profile objectForKey:@"my_id"]) {
            v.message = [profile objectForKey:@"my_id"];
        }else{
            v.message = @"";
        }
    }
}


-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    /*
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
        
    if ([profile2_img count] > 0) {
     
        if ([[_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0] isKindOfClass:[NSDictionary class]]) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"View Picture", @"Edit Picture", nil];
            
            actionSheet.tag = 100;
            [actionSheet showInView:self.view];
        }else{
            
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Take Photo", @"Library", nil];
            
            actionSheet.tag = 101;
            [actionSheet showInView:self.view];
        }
            
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Edit Picture", nil];
        
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
    }
    */
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
                // View Picture
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
//                if (![self.profile_picture isEqualToString:@""]) {
//                    v.uri = self.profile_picture;
//                }
                
                /*
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
                
                NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
                
                if ([profile2_img count] > 0) {
                    NSLog(@"%@", [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]);
                    
                    NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]];
                    
                    v.uri = url;
                }
                */
                
                // v.name = self.name_friend;
                // [self.navigationController pushViewController:v animated:YES];
                
                UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
                
                [self presentViewController:navV animated:YES completion:nil];
                
                break;
            }
                
                // Edit Picture
            case 1:{
                
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
                
                break;
            }
            default:
                break;
        }
    }
    else if (actionSheet.tag == 101){
        
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
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }
    else if (actionSheet.tag == 102){
        
        // switch (buttonIndex) {
        
        switch (buttonIndex) {
            case 0:
            {

                // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
                NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
                // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
                NSArray * applicationActivities = nil;
                NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
                                                 UIActivityTypeMessage,
                                                 UIActivityTypeMail,
                                                 UIActivityTypePrint,
                                                 UIActivityTypeCopyToPasteboard,
                                                 UIActivityTypeAssignToContact,
                                                 UIActivityTypeSaveToCameraRoll,
                                                 UIActivityTypeAddToReadingList,
                                                 UIActivityTypePostToFlickr,
                                                 UIActivityTypePostToVimeo,
                                                 UIActivityTypePostToTencentWeibo,
                                                 UIActivityTypeAirDrop];
                
                
                /*
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
                
                
                NSString *text = [NSString stringWithFormat:@"HEART from %@ get the HEART app it's cool", [_dict objectForKey:@"user"][@"name"]];//;
                NSURL *url = [NSURL URLWithString:@"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1184807478/testflight/external"];
                
                UIImage *image = [UIImage imageNamed:@"bcc59e573a289.png"];
                
                UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:applicationActivities];
                activityController.excludedActivityTypes = excludeActivities;
                
                [self presentViewController:activityController animated:YES completion:nil];
                */
            }
                break;
            case 1:
            {

            }
                break;
                
            default:
                break;
        }
        
       

    }
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
    
    UpdatePictureProfileThread *uPicture = [[UpdatePictureProfileThread alloc] init];
    [uPicture setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
       
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
            [self reloadData:nil];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uPicture setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uPicture start:image];

    img = image;
    [self hideImagePicker];
    
    [self reloadData:nil];
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    img = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    [self reloadData:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [SVProgressHUD showWithStatus:@"Update."];
    
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [self reloadData:nil];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:chosenImage];
    
    img = chosenImage;
    // [self hideImagePicker];
    
    [self reloadData:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)mailTapped:(UITapGestureRecognizer *)gestureRecognizer{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListEmail *v = [storybrd instantiateViewControllerWithIdentifier:@"ListEmail"];
    
    [self.navigationController pushViewController:v animated:YES];
}

-(void)AnNmousURegisterRESULT:(NSNotification *)notice{
    NSString *email = [notice object];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AnNmousUVerify *anNmousUVerify =[storybrd instantiateViewControllerWithIdentifier:@"AnNmousUVerify"];
    anNmousUVerify.email = email;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:anNmousUVerify] animated:YES completion:nil];
}

- (IBAction)onShare:(id)sender {
    // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
    // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
                                     UIActivityTypeMessage,
                                     UIActivityTypeMail,
                                     UIActivityTypePrint,
                                     UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeAssignToContact,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypeAddToReadingList,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePostToVimeo,
                                     UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    
    NSString *text = [NSString stringWithFormat:@"HEART from %@ get the HEART app it's cool", [_dict objectForKey:@"user"][@"name"]];//;
    NSURL *url = [NSURL URLWithString:@"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1184807478/testflight/external"];
    
    UIImage *image = [UIImage imageNamed:@"bcc59e573a289.png"];
    
    ////
    UIImage *iProfile = nil;
    if ([profile objectForKey:@"picture"]) {
        NSDictionary *picture = [profile objectForKey:@"picture"];
        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        iProfile = [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]]];
    }else{
        iProfile = [UIImage imageNamed:@"ic-profile-defualt.png"];
    }
    
    ////
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[@"-My ID-", [NSURL URLWithString:[NSString stringWithFormat:@"%@/profile-main/%@", [Configs sharedInstance].API_URL, [Configs sharedInstance].getUIDU ]], iProfile] applicationActivities:applicationActivities];
    
    /*
       UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:[NSString stringWithFormat:@"%@/profile-main/%@", [Configs sharedInstance].API_URL, [Configs sharedInstance].getUIDU ]]  ] applicationActivities:applicationActivities];
     */
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

@end
