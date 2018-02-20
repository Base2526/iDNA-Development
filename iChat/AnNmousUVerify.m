//
//  AnNmousUVerify.m
//  Heart
//
//  Created by Somkid on 1/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AnNmousUVerify.h"
#import "AnNmousUVerifyThread.h"
#import "Configs.h"

@interface AnNmousUVerify ()

@end

@implementation AnNmousUVerify
@synthesize btnOK;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (IBAction)onOK:(id)sender {
    NSString *strCodeVerify = [self.texfieldCodeVerify.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strCodeVerify isEqualToString:@""]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Code Verify is Empty."];
    }else{
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        
        AnNmousUVerifyThread *anVThread = [[AnNmousUVerifyThread alloc] init];
        [anVThread setCompletionHandler:^(NSString * data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
                [self dismissViewControllerAnimated:NO completion:nil];
            }else{
                /*
                 email นี้มีการ register แล้ว
                 */
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        }];
        
        [anVThread setErrorHandler:^(NSString * error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [anVThread start:self.email :strCodeVerify];
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
