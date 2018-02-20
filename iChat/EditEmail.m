//
//  EditEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "EditEmail.h"
#import "Configs.h"
#import "EditEmailThread.h"
#import "AppConstant.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface EditEmail (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}
@end

@implementation EditEmail
@synthesize fction, item_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref         = [[FIRDatabase database] reference];
    
    self.btnSave.enabled = NO;
    self.textFieldEmail.delegate = self;
    
    if (![fction isEqualToString:@"add"]) {
        self.title = @"Edit Email";
        [self.textFieldEmail setText:self.email];
    }else{
        self.title = @"Add Email";
    }
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles =[[Configs sharedInstance] getUserProfiles];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    NSLog(@"%@", textField.text);
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {
    NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    if (newLength > 0) {
        self.btnSave.enabled = YES;
    }else{
        self.btnSave.enabled = NO;
    }
    return YES;
}

- (IBAction)onSave:(id)sender {
    
    NSString *_email = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![[Configs sharedInstance] NSStringIsValidEmail:_email]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Email Invalid"];
    }else{
    
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
        
        if ([fction isEqualToString:@"add"]) {
            EditEmailThread *editPhone = [[EditEmailThread alloc] init];
            [editPhone setCompletionHandler:^(NSData *data) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([profiles objectForKey:@"mails"]) {
                        NSMutableDictionary * mails = [[profiles objectForKey:@"mails"] mutableCopy];
                        
                        if (![mails objectForKey:jsonDict[@"item_id"]]) {
                            
                            [mails setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                            
                            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                            [newProfile addEntriesFromDictionary:profiles];
                            
                            if ([newProfile objectForKey:@"mails"]) {
                                [newProfile removeObjectForKey:@"mails"];
                            }
                            [newProfile setObject:mails forKey:@"mails"];
                            
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfile];
                        }
                    }else {
                        NSMutableDictionary * mails = [[NSMutableDictionary alloc] init];
                        
                        [mails setValue:jsonDict[@"item"] forKey:jsonDict[@"item_id"]];
                        
                        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                        [newProfile addEntriesFromDictionary:profiles];
                        [newProfile setObject:mails forKey:@"mails"];
                        
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfile];
                    }
                    
                    [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
                }
            }];
            
            [editPhone setErrorHandler:^(NSString *error) {
                NSLog(@"%@", error);
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
            }];
            // self.number
            [editPhone start:self.fction :self.item_id : _email];
        }else{
            // Edit
            if ([profiles objectForKey:@"mails"]) {
                NSMutableDictionary *mails = [profiles objectForKey:@"mails"];
                
                NSMutableDictionary *newMails = [[NSMutableDictionary alloc] init];
                [newMails addEntriesFromDictionary:mails];
                // [newPhones removeObjectForKey:self.item_id];
                
                NSMutableDictionary *mail  = [mails objectForKey:item_id];
                NSMutableDictionary *newMail = [[NSMutableDictionary alloc] init];
                [newMail addEntriesFromDictionary:mail];
                [newMail removeObjectForKey:@"name"];
                [newMail setValue:_email forKey:@"name"];
                
                [newMails removeObjectForKey:item_id];
                [newMails setValue:newMail forKey:item_id];
                
                NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                [newProfile addEntriesFromDictionary:profiles];
                [newProfile removeObjectForKey:@"mails"];
                [newProfile setValue:newMails forKey:@"mails"];
        
                NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfile};
                
                [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    if (error == nil) {
                        
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfile];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:NO];
                        });
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update email."];
                    }
                }];
            }
        }
    }
}
@end
