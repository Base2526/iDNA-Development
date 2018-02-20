//
//  AnNmousURegister.m
//  Heart
//
//  Created by Somkid on 1/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AnNmousURegister.h"
#import "AnNmousURegisterThread.h"
#import "Configs.h"

#import "AnNmousUVerify.h"

@interface AnNmousURegister ()

@end

@implementation AnNmousURegister
@synthesize btnOk;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    btnOk.layer.cornerRadius = 5;
    btnOk.layer.borderWidth = 1;
    btnOk.layer.borderColor = [UIColor blueColor].CGColor;
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

- (IBAction)onOK:(id)sender {
    
    NSString *strEmail = [self.txtfieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strEmail isEqualToString:@""]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email is Empty."];
    }else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email is Invalid."];
    }else{

        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        
        AnNmousURegisterThread *anNThread = [[AnNmousURegisterThread alloc] init];
        [anNThread setCompletionHandler:^(NSString * data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            // homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
            // homeViewController.title = @"Home";
            // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            NSLog(@"+ %@ +", jsonDict);
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Check Verify for email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                
                alertView.tag = 45;
                alertView.delegate = self;
                [alertView show];
            }else{
                /*
                  email นี้มีการ register แล้ว
                 */
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
        [anNThread setErrorHandler:^(NSString * error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [anNThread start:strEmail];
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:nil];
    switch (alertView.tag) {
        case 45:
            if (buttonIndex == 0)
            {
                //raise notification about dismiss
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AnNmousURegister_RESULT" object:[self.txtfieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            break;
        default:
            break;
    }
}
@end

