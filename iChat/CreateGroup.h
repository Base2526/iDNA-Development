//
//  CreateGroup.h
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"


@interface CreateGroup : UIViewController<UITableViewDataSource,UITableViewDelegate, GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet HJManagedImageV *ImageVGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *fction, *item_id;

- (IBAction)onCreateGroup:(id)sender;
@end
