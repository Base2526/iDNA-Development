//
//  Comment.h
//  iDNA
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Comment : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *tvText;

@property (strong, nonatomic) NSString *app_id, *post_id, *is_edit, *object_id, *message;
- (IBAction)onSave:(id)sender;
@end
