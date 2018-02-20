//
//  ForgotPassword.h
//  Heart-Basic
//
//  Created by somkid simajarn on 9/5/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TxtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

- (IBAction)onForgotPassword:(id)sender;

@end
