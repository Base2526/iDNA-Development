//
//  SignUp.h
//  Heart-Basic
//
//  Created by somkid simajarn on 9/4/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"

#import "SVProgressHUD.h"
#import "SignUpThread.h"

//#import <Parse/Parse.h>

@interface SignUp : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TxtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *TxtFieldName;
- (IBAction)onSignup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@end
