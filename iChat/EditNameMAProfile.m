//
//  EditEmail.m
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "EditNameMAProfile.h"
#import "Configs.h"
#import "EditEmailThread.h"
#import "AppConstant.h"

@interface EditNameMAProfile ()

@end

@implementation EditNameMAProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSave.enabled = NO;
    self.textFieldEmail.delegate = self;
    
    if (![self.fction isEqualToString:@"add"]) {
        self.title = @"Edit Name";
        [self.textFieldEmail setText:self.name];
    }else{
        self.title = @"Add Name";
    }
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
        
        EditEmailThread *editPhone = [[EditEmailThread alloc] init];
        [editPhone setCompletionHandler:^(NSData *data) {
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"");
//                NSError *jsonError;
//                NSData *objectData = [jsonDict[@"values"] dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *values = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&jsonError];
//                
//                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
//                [self.navigationController popViewControllerAnimated:YES];
                
                if ([jsonDict[@"is_edit"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    /*
                    // add new phone number
                    NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                    
                    NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                    // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                    
                    NSMutableDictionary*mails = [[NSMutableDictionary alloc] init];
                    if ([profile objectForKey:@"mails"]) {
                        mails =  [[profile objectForKey:@"mails"] mutableCopy];
                    }
                    
                    [mails setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                    
                    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                    [newProfile addEntriesFromDictionary:profile];
                    [newProfile removeObjectForKey:@"mails"];
                    [newProfile setObject:mails forKey:@"mails"];
                    
                    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                    [newData addEntriesFromDictionary:data];
                    [newData removeObjectForKey:@"profile"];
                    [newData setObject:newProfile forKey:@"profile"];
                    
                    [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
                    */
                }else{
                    /*
                    // edit phone number
                    NSMutableDictionary*data =  [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"data"] mutableCopy];
                    
                    NSMutableDictionary*profile =  [[data objectForKey:@"profile"] mutableCopy];
                    // NSMutableDictionary*profile =  [[profile objectForKey:@"phones"] mutableCopy];
                    
                    NSMutableDictionary*mails = [[profile objectForKey:@"mails"] mutableCopy];
                    
                    [mails removeObjectForKey:jsonDict[@"item_id"]];
                    [mails setObject:jsonDict[@"data"] forKey:jsonDict[@"item_id"]];
                    
                    NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
                    [newProfile addEntriesFromDictionary:profile];
                    [newProfile removeObjectForKey:@"mails"];
                    [newProfile setObject:mails forKey:@"mails"];
                    
                    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                    [newData addEntriesFromDictionary:data];
                    [newData removeObjectForKey:@"profile"];
                    [newData setObject:newProfile forKey:@"profile"];
                    
                    [[Configs sharedInstance] saveData:_DATA :@{@"data": newData}];
                     */
                }
                
                [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
        }];
        
        [editPhone setErrorHandler:^(NSString *error) {
            NSLog(@"%@", error);
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        // self.number
        [editPhone start:self.fction :self.item_id : _email];
    }
}
@end
