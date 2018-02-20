//
//  ForgotPassword.m
//  Heart-Basic
//
//  Created by somkid simajarn on 9/5/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "ForgotPassword.h"
//#import <Quickblox/Quickblox.h>

#import "SVProgressHUD.h"
#import "Configs.h"
#import "AppConstant.h"
#import "ForgotPasswordThread.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword
@synthesize btnOK;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:_EMAIL_LAST] != nil){
        self.TxtEmail.text = [preferences objectForKey:_EMAIL_LAST];
    }
    
    btnOK.layer.cornerRadius = 5;
    btnOK.layer.borderWidth = 1;
    btnOK.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onForgotPassword:(id)sender {
    
    NSString *strEmail = [self.TxtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;//self.TxtEmail.text;
    
    if ([strEmail isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Email is Empty."];
    }else if (![[Configs sharedInstance] NSStringIsValidEmail:strEmail]) {
        [SVProgressHUD showErrorWithStatus:@"Email is Invalid."];
    }else{
        
        [SVProgressHUD showWithStatus:@"Please Wait"];
        
        ForgotPasswordThread *forgotThread = [[ForgotPasswordThread alloc] init];
        [forgotThread setCompletionHandler:^(NSString * data) {
        
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showSuccessWithStatus:@"Please check email."];

            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [forgotThread setErrorHandler:^(NSString * data) {
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showErrorWithStatus:data];
        }];
        
        [forgotThread start:strEmail];
    }
}
@end
