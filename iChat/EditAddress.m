//
//  EditAddress.m
//  iDNA
//
//  Created by Somkid on 4/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "EditAddress.h"
#import "Configs.h"

@interface EditAddress (){
    NSMutableDictionary *profiles;
}

@end

@implementation EditAddress
@synthesize ref, type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
        if ([type isEqualToString:@"address"]) {
            self.title = @"Address";
            if ([profiles objectForKey:@"address"]) {
                self.textAddress.text = [profiles objectForKey:@"address"];
            }
        }else if([type isEqualToString:@"school"]){
            self.title = @"School";
            if ([profiles objectForKey:@"school"]) {
                self.textAddress.text = [profiles objectForKey:@"school"];
            }
        }else if([type isEqualToString:@"company"]){
            self.title = @"Company";
            if ([profiles objectForKey:@"company"]) {
                self.textAddress.text = [profiles objectForKey:@"company"];
            }
        }else if([type isEqualToString:@"line_id"]){
            self.title = @"Line ID";
            if ([profiles objectForKey:@"line_id"]) {
                self.textAddress.text = [profiles objectForKey:@"line_id"];
            }
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

- (IBAction)onSave:(id)sender {
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    NSString *strName = [self.textAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
    [newProfiles addEntriesFromDictionary:profiles];
    
    if ([type isEqualToString:@"address"]) {
        if ([newProfiles objectForKey:@"address"]) {
            [newProfiles removeObjectForKey:@"address"];
        }
        
        [newProfiles setValue:strName forKey:@"address"];
    }else if([type isEqualToString:@"school"]){
        if ([newProfiles objectForKey:@"school"]) {
            [newProfiles removeObjectForKey:@"school"];
        }
        
        [newProfiles setValue:strName forKey:@"school"];
    }else if([type isEqualToString:@"company"]){
        if ([newProfiles objectForKey:@"company"]) {
            [newProfiles removeObjectForKey:@"company"];
        }
        
        [newProfiles setValue:strName forKey:@"company"];
    }else if([type isEqualToString:@"line_id"]){
        if ([newProfiles objectForKey:@"line_id"]) {
            [newProfiles removeObjectForKey:@"line_id"];
        }
        
        [newProfiles setValue:strName forKey:@"line_id"];
    }
    
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
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update address."];
            }
    }];
}
@end
