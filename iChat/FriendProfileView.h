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
#import "TopAlignedLabel.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface FriendProfileView : UIViewController<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property(nonatomic)NSString *friend_id;

- (IBAction)onChat:(id)sender;

@end
