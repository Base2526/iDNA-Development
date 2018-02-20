//
//  AddPost.h
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "UIPlaceHolderTextView.h"

@interface AddPost : UIViewController
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImage;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (strong, nonatomic) NSDictionary *edit_data;

@property(strong, nonatomic)NSString*app_id, *is_edit, *post_id, *category_id;

- (IBAction)onSave:(id)sender;
- (IBAction)onClose:(id)sender;

@end
