//
//  CreateClass.h
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"

@interface CreateClass : UIViewController<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageProfile;
@property (weak, nonatomic) IBOutlet UITextField *textfieldName;

@property (strong, nonatomic) NSString *fction, *item_id;

- (IBAction)onCreate:(id)sender;
@end
