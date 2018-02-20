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

@interface AddComment : UIViewController

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;

@property (strong, nonatomic) NSString *is_add, *application_id , *post_id;

- (IBAction)onSave:(id)sender;

@end
