//
//  AddByIDViewController.h
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface AddByIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textfID;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV_friend;
@property (weak, nonatomic) IBOutlet UITextView *textView_message;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;

- (IBAction)onFind:(id)sender;
- (IBAction)onAddFriend:(id)sender;
@end
