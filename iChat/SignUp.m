//
//  SignUp.m
//  Heart-Basic
//
//  Created by somkid simajarn on 9/4/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SignUp.h"
#import "Configs.h"

#import "SVProgressHUD.h"

@interface SignUp ()

@end

@implementation SignUp
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

-(NSString*) decodeHtmlUnicodeCharactersToString:(NSString*)str
{
    NSMutableString* string = [[NSMutableString alloc] initWithString:str];  // #&39; replace with '
    NSString* unicodeStr = nil;
    NSString* replaceStr = nil;
    int counter = -1;
    
    for(int i = 0; i < [string length]; ++i)
    {
        unichar char1 = [string characterAtIndex:i];
        for (int k = i + 1; k < [string length] - 1; ++k)
        {
            unichar char2 = [string characterAtIndex:k];
            
            if (char1 == '&'  && char2 == '#' )
            {
                ++counter;
                unicodeStr = [string substringWithRange:NSMakeRange(i + 2 , 2)];
                // read integer value i.e, 39
                replaceStr = [string substringWithRange:NSMakeRange (i, 5)];     //     #&39;
                [string replaceCharactersInRange: [string rangeOfString:replaceStr] withString:[NSString stringWithFormat:@"%c",[unicodeStr intValue]]];
                break;
            }
        }
    }
    // [string autorelease];
    
    if (counter > 1)
        return  [self decodeHtmlUnicodeCharactersToString:string];
    else
        return string;
}

- (IBAction)onSignup:(id)sender {
    
    /*
     if([strEmail isEqualToString:@""]){
     [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email is Empty."];
     }else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
     [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email is Invalid."];
     }else{
     
     
     */
    
    NSString* strUsername   = [self.TxtFieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* strEmail      = [self.TxtFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strUsername isEqualToString:@""] || [strEmail isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Display Name & Email Empty."];
    }else if ([strUsername isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Display Name Empty."];
    }else if ([strEmail isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email Empty."];
    }else if(![[Configs sharedInstance] NSStringIsValidEmail:strEmail]){
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email is Invalid."];
    }else{

        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        
        SignUpThread *loginThread = [[SignUpThread alloc] init];
        [loginThread setCompletionHandler:^(NSString * str) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            //        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
            //        [self dismissViewControllerAnimated:YES completion:nil];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
            
            /*
             {"id":"Zye-y9A3mV5mEI4dmMrSXuJ1i82yA5ep_Ii9NRJuMrk","name":"SESSd7da75db715e9ec489582517601f380b"}
             */
            
            NSLog(@"%@", jsonDict);
            
            if ([jsonDict objectForKey:@"form_errors"]) {
                // contains object
                NSLog(@"%@", [jsonDict objectForKey:@"form_errors"]);
                
                // [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict objectForKey:@"form_errors"]];
                
                NSMutableString *errorString = [[NSMutableString alloc] init];
                
                for (NSString *key in [[jsonDict objectForKey:@"form_errors"] allKeys]) {

                    // now you have both the key (frameName) and the value (frame) to work with
                    
                    
                    [errorString appendString:[NSString stringWithFormat:@"%@ ",[[jsonDict objectForKey:@"form_errors"] objectForKey:key]]];
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }else{
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setObject:strEmail forKey:_EMAIL_LAST];
                [preferences synchronize];
                
                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Please check email."];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [loginThread setErrorHandler:^(NSString * error) {
            NSLog(@"%@", error);
            
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [loginThread start:strUsername :strEmail];
    }

}



- (void)registerForRemoteNotifications
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}
@end
