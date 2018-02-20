//
//  MyProfile.h
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "TopAlignedLabel.h"

@interface MyProfile : UIViewController<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (IBAction)onShare:(id)sender;

/*
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
//@property (weak, nonatomic) IBOutlet UITextField *txtFEmail;
@property (weak, nonatomic) IBOutlet TopAlignedLabel *lblEmail;


@property (weak, nonatomic) IBOutlet UITextField *txtFStatus;
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV_QRCode;
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV_bg;

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onSave:(id)sender;
*/

/*
 1 : แสดงว่าถูกเรียกจากเมนู
 */
@property (strong, nonatomic) NSString *isMenu;
@end
