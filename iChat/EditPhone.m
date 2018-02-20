//
//  EditPhone.m
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditPhone.h"
#import "EditPhoneThread.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"
#import "Configs.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface EditPhone (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}
@end

@implementation EditPhone
@synthesize fction, item_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref         = [[FIRDatabase database] reference];
    
    self.btnSave.enabled = NO;
    self.textFieldName.delegate = self;
    
    if (![fction isEqualToString:@"add"]) {
        self.title =@"Edit Phone";
        [self.textFieldName setText:self.number];
    }else{
        self.title =@"Add Phone";
    }
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles = [[Configs sharedInstance] getUserProfiles];
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
    NSString *text = [self.textFieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([text isEqualToString:@""] || [[Configs sharedInstance] NSStringIsValidPhone:text]) {
        [SVProgressHUD showErrorWithStatus:@"Phone is Empty or Invalid."];
    }else {
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
        
        if ([fction isEqualToString:@"add"]) {
            // Add
            EditPhoneThread *eThread = [[EditPhoneThread alloc] init];
            [eThread setCompletionHandler:^(NSData *data) {
                
                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([profiles objectForKey:@"phones"]) {
                        NSMutableDictionary * phones = [[profiles objectForKey:@"phones"] mutableCopy];
                        
                        if (![phones objectForKey:jsonDict[@"item_id"]]) {
                            
                            [phones setValue:jsonDict[@"value"] forKey:jsonDict[@"item_id"]];
                            
                            NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                            [newProfile addEntriesFromDictionary:profiles];
                            [newProfile removeObjectForKey:@"phones"];
                            [newProfile setObject:phones forKey:@"phones"];
                       
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfile];
                        }
                    }else{
                        NSMutableDictionary * phones = [[NSMutableDictionary alloc] init];
                        
                        [phones setValue:jsonDict[@"value"] forKey:jsonDict[@"item_id"]];
                        
                        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                        [newProfile addEntriesFromDictionary:profiles];
                        // [newProfile removeObjectForKey:@"phones"];
                        [newProfile setObject:phones forKey:@"phones"];
                        
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
            
            [eThread setErrorHandler:^(NSString *message) {
                [[Configs sharedInstance] SVProgressHUD_Dismiss];
                
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:message];
            }];
            // self.number
            [eThread start:fction :item_id : text];
        }else{
            // Edit
            if ([profiles objectForKey:@"phones"]) {
                NSMutableDictionary *phones = [profiles objectForKey:@"phones"];
                
                NSMutableDictionary *newPhones = [[NSMutableDictionary alloc] init];
                [newPhones addEntriesFromDictionary:phones];
                // [newPhones removeObjectForKey:self.item_id];
                
                NSMutableDictionary *phone  = [phones objectForKey:item_id];
                NSMutableDictionary *newPhone = [[NSMutableDictionary alloc] init];
                [newPhone addEntriesFromDictionary:phone];
                [newPhone removeObjectForKey:@"name"];
                [newPhone setValue:text forKey:@"name"];
                
                [newPhones removeObjectForKey:item_id];
                [newPhones setValue:newPhone forKey:item_id];
                
                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                [newProfiles addEntriesFromDictionary:profiles];
                [newProfiles removeObjectForKey:@"phones"];
                [newProfiles setValue:newPhones forKey:@"phones"];
                
                
                
                NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
                
                [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    NSLog(@"%@", ref.key);
                    if (error == nil) {
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:NO];
                        });
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update phone."];
                    }
                }];
            }
        }
    }
}
@end
