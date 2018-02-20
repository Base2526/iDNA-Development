//
//  MyProfile.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "MyProfile2.h"

#import "Configs.h"
#import "AppDelegate.h"
#import "ListClasss.h"
#import "UpdatePictureProfileThread.h"
#import "UpdateMyProfileThread.h"
#import "UpdatePictureBGThread.h"

@interface MyProfile2 ()

@end

@implementation MyProfile2
@synthesize imageV, imageV_QRCode, imageV_bg, ref, txtFName, lblEmail, txtFStatus;
@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfileImage:)]];
    
    
    imageV_bg.userInteractionEnabled = YES;
    [imageV_bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBGImage:)]];
    

    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([profiles objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }
    
    //
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([profiles objectForKey:@"bg_url"]) {
        [imageV_bg clear];
        [imageV_bg showLoadingWheel];
        
        [imageV_bg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"bg_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_bg ];
    }
    
    if ([profiles objectForKey:@"url_my_qrcode"]) {
        [imageV_QRCode clear];
        [imageV_QRCode showLoadingWheel];
        [imageV_QRCode setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"url_my_qrcode"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_QRCode ];
    }
    
    txtFName.text =[profiles objectForKey:@"name"];
    lblEmail.text =[profiles objectForKey:@"mail"];
    
    // txtFStatus
    if ([profiles objectForKey:@"status_message"]) {
        txtFStatus.text =[profiles objectForKey:@"status_message"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
////    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+500);
//    
//    scrollView.showsVerticalScrollIndicator=YES;
//    scrollView.scrollEnabled=YES;
//    scrollView.userInteractionEnabled=YES;
//    // [self.view addSubview:scrollview];
//    scrollView.contentSize = CGSizeMake(500,1200);
    
    // scrollView.contentSize = CGSizeMake(320, 800);
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
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

-(void)selectProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)selectBGImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 102;
    [actionSheet showInView:self.view];
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
                NSLog(@"");
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

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    // img = image;

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    // [self reloadData:nil];
    
    NSLog(@"");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSString *data) {

        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];

        [[Configs sharedInstance] SVProgressHUD_Dismiss];

        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [imageV clear];
            [imageV showLoadingWheel];
            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            
            [self updateURI:jsonDict[@"url"]];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];

    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:chosenImage];
    */
    
    
    // NSLog(@"%@", imagePicker._id);
    [self updateProfilePicture:image];
//
//    img = chosenImage;
//    // [self hideImagePicker];
//
//    [self reloadData:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {
    // UpdateMyProfileThread
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdateMyProfileThread *uMPThread = [[UpdateMyProfileThread alloc] init];
    [uMPThread setCompletionHandler:^(NSString *data) {
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:txtFName.text forKey:@"name"];
            [profiles setValue:txtFStatus.text forKey:@"status_message"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    [uMPThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uMPThread start:txtFName.text :txtFStatus.text];
    */
    
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/profiles/", [[Configs sharedInstance] getUIDU]];
    
    [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *values = snapshot.value;
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:values];
        [newDict removeObjectForKey:@"name"];
        [newDict removeObjectForKey:@"status_message"];
        
        [newDict setValue:txtFName.text forKey:@"name"];
        [newDict setValue:txtFStatus.text forKey:@"status_message"];
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newDict};
        
        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error == nil) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                [self.navigationController popViewControllerAnimated:NO];
            }else{
            }
        }];
    }];
    */
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    
    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:profiles];
    [newDict removeObjectForKey:@"name"];
    [newDict removeObjectForKey:@"status_message"];
    
    [newDict setValue:txtFName.text forKey:@"name"];
    [newDict setValue:txtFStatus.text forKey:@"status_message"];
    
    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newDict};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            [self.navigationController popViewControllerAnimated:NO];
        }else{
        }
    }];
}

-(void)updateURI:(NSString *)uri{
    
    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    [profiles setValue:uri forKey:@"image_url"];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
    //  ลบข้อมูล key profiles ออกไป
    [newDict removeObjectForKey:@"profiles"];
    
    [newDict setObject:profiles forKey:@"profiles"];
    
    [[Configs sharedInstance] saveData:_DATA :newDict];
}

-(void)updateProfilePicture:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [imageV clear];
                [imageV showLoadingWheel];
                [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,jsonDict[@"url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            });
            // [self updateURI:jsonDict[@"url"]];
            
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:jsonDict[@"url"] forKey:@"image_url"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            //  ลบข้อมูล key profiles ออกไป
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [imageV_bg clear];
                [imageV_bg showLoadingWheel];
                [imageV_bg setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
                
                [imageV_bg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,jsonDict[@"url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_bg ];
            });
            // [self updateURI:jsonDict[@"url"]];
            
            NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
            [profiles setValue:jsonDict[@"url"] forKey:@"bg_url"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            // เราต้อง addEntriesFromDictionary ก่อน ถึงจะสามารถลบได้ แ้วค่อย update ข้อมูล
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            //  ลบข้อมูล key profiles ออกไป
            [newDict removeObjectForKey:@"profiles"];
            
            [newDict setObject:profiles forKey:@"profiles"];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [updateBGThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [updateBGThread start:image];
}
@end
