//
//  ManageGroup.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageGroup.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UpdatePictureGroupThread.h"
#import "GroupMembers.h"
#import "GroupInvite.h"
#import "UserDataUIAlertView.h"
#import "GroupChatRepo.h"
#import "ChatViewController.h"

@interface ManageGroup (){
    NSDictionary *group_data;
    NSArray *array_group;
    GroupChatRepo *groupChatRepo;
}
@end

@implementation ManageGroup

@synthesize group_id;
@synthesize imageV, ref;
@synthesize imagePicker;
@synthesize popoverController;
@synthesize txtGroupName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref = [[FIRDatabase database] reference];
    groupChatRepo  = [[GroupChatRepo alloc] init];
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_GROUP
                                               object:nil];
    
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_GROUP object:nil];
}

// กรณีเปิด จะมีการ hide Tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        array_group    = [groupChatRepo get:group_id];
        
        if(array_group != nil){
            NSString *data  = [array_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
            
            group_data = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
            if ([group_data objectForKey:@"image_url"]) {
                [imageV clear];
                [imageV showLoadingWheel]; // API_URL
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [group_data objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
            }else{
                [imageV clear];
            }
            txtGroupName.text = [group_data objectForKey:@"name"];
            
            NSDictionary *members = [group_data objectForKey:@"members"];
            self.title = [NSString stringWithFormat:@"Manage Group(%d)", [members count] ];
            NSLog(@"");
            
            [self.btnManageMembers setTitle:[NSString stringWithFormat:@"Manage Members(%d)", [members count] ] forState:UIControlStateNormal];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
        }
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

-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:/*@"Take Photo",*/ @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            /*
        case 0:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;*/
        case 0:{
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

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

/*
 กรณีเลือกรูปจาก gallery ในเครื่อง
 */
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    [self UpdatePicture:image];
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSLog(@"");
}

/*
 กรณีถ่ายรูปจาก camera
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self UpdatePicture:image];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {

    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    
    NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
    [tgroup addEntriesFromDictionary:group_data];
    
    if ([tgroup objectForKey:@"name"]) {
        [tgroup removeObjectForKey:@"name"];
    }
    [tgroup setObject:txtGroupName.text forKey:@"name"];
    
    
    NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU], group_id];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@", child]: tgroup};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
        
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateGroup:group_id :tgroup];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[error description]];
        }
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
    }];
}

- (IBAction)onManageMembers:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMembers *members = [storybrd instantiateViewControllerWithIdentifier:@"GroupMembers"];
    members.group_id = group_id;
    
    [self.navigationController pushViewController:members animated:YES];
}

- (IBAction)onInviteMember:(id)sender {
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupInvite *invite = [storybrd instantiateViewControllerWithIdentifier:@"GroupInvite"];
    invite.group_id = group_id;
    
    [self.navigationController pushViewController:invite animated:YES];
}

- (IBAction)onChat:(id)sender {
    NSLog(@"onChat");
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *cV = [storybrd instantiateViewControllerWithIdentifier:@"ChatViewController"];
    cV.type = @"Groups";
    cV.friend_id = group_id;
    [self.navigationController pushViewController:cV animated:YES];
}

- (IBAction)onDeleteGroup:(id)sender {
    
    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Are you sure delete group?"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:@"Delete", nil];
    
    alert.userData = @"";
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                // Delete
                NSString *child = [NSString stringWithFormat:@"%@%@/groups/%@/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], group_id];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            /*
                             เช็ดก่อนว่ามี group_id นี้หรือเปล่าเพราะบางที่อาจโดนลบไปแล้ว ก็ได้จาก main control (firebase อาจ return มาเร็วมาก)
                             */
                            if ([groupChatRepo get:key] != nil){
                                BOOL sv = [groupChatRepo deleteGroup:key];
                            }
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }];
            }
            break;
        }
    }
}

-(void)UpdatePicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureGroupThread *updatePictureGroupThread = [[UpdatePictureGroupThread alloc] init];
    [updatePictureGroupThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // ดึงข้อมูลจาก local มาเพื่อเราจะมา update field image_url
                NSArray *_group = [groupChatRepo get:group_id];
                NSString *data = [_group objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]];
                
                NSMutableDictionary *items = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                
                NSMutableDictionary *tgroup = [[NSMutableDictionary alloc] init];
                [tgroup addEntriesFromDictionary:items];
                
                if ([tgroup objectForKey:@"image_url"]) {
                    [tgroup removeObjectForKey:@"image_url"];
                }
                
                [tgroup setObject:jsonDict[@"image_url"] forKey:@"image_url"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateGroup:group_id :tgroup];
            });
        
            [self reloadData:nil];
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update Erorr."];
        }
        
    }];
    
    [updatePictureGroupThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updatePictureGroupThread start:group_id : image];
}

@end
