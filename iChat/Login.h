//
//  Login.h
//  Heart-Basic
//
//  Created by somkid simajarn on 9/3/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"

@interface Login : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TxtEmail;
@property (weak, nonatomic) IBOutlet UITextField *TxtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

- (IBAction)onLogin:(id)sender;

@end
