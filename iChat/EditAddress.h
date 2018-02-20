//
//  EditAddress.h
//  iDNA
//
//  Created by Somkid on 4/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface EditAddress : UIViewController
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextView *textAddress;

@property (weak, nonatomic) NSString *type;

- (IBAction)onSave:(id)sender;


@end
