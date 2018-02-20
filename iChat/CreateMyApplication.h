//
//  AddNewMyApplication.h
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface CreateMyApplication : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, GKImagePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCreate;

- (IBAction)onCreate:(id)sender;
- (IBAction)onClose:(id)sender;
@end
