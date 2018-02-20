//
//  EditStatusMessage.m
//  Heart
//
//  Created by Somkid on 12/27/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "EditStatusMessage.h"

#import "EditStatusMessageThread.h"
#import "Configs.h"
// #import "SVProgressHUD.h"
#import "AppConstant.h"

#import "ProfilesRepo.h"

@interface EditStatusMessage ()
{
    NSMutableDictionary *profiles;
}
@end

@implementation EditStatusMessage
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnSave.enabled = NO;
    self.textFieldMessage.delegate = self;
    
    ref         = [[FIRDatabase database] reference];
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        profiles = [[Configs sharedInstance] getUserProfiles];
        
        [self.textFieldMessage setText:@""];
        
        if ([profiles objectForKey:@"status_message"]) {
            [self.textFieldMessage setText:[profiles objectForKey:@"status_message"]];
        }
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
    
    NSString *strName = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strName isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
                
        NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
        [newProfiles addEntriesFromDictionary:profiles];
        
        if ([newProfiles objectForKey:@"status_message"]) {
            [newProfiles removeObjectForKey:@"status_message"];
        }
        [newProfiles setValue:strName forKey:@"status_message"];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
        
        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            if (error == nil) {
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:NO];
                });
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update name."];
            }
        }];
    }
}
@end
