//
//  EditDisplayName.h
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface EditDisplayName : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
- (IBAction)onSave:(id)sender;

//@property (strong, nonatomic) NSString *name, *isfriend, *uid_friend;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (strong, nonatomic) NSString *uid;

@end
