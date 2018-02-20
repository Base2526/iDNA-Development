//
//  FriendProfile.h
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "TopAlignedLabel.h"
@interface FriendProfileView2 : UIViewController

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
//@property (weak, nonatomic) IBOutlet UITextField *txtFEmail;
@property (weak, nonatomic) IBOutlet TopAlignedLabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtIsFavorite;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UIButton *btnClasss;

- (IBAction)onSelectClasss:(id)sender;
// new
@property(nonatomic)NSString *friend_id;
@end

