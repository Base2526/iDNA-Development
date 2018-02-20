//
//  SetMyID.m
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "SetMyID.h"
#import "AppConstant.h"
#import "Configs.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface SetMyID (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}
@end

@implementation SetMyID
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
        
        [self.textFieldMessage setText:@""];
        //    if ([profiles objectForKey:@"my_id"]) {
        //        [self.textFieldMessage setText:[profiles objectForKey:@"my_id"]];
        //    }
        
        if ([profiles objectForKey:@"my_id"]) {
            /*
             NSDictionary *my_id = [profiles objectForKey:@"my_id"];
             if ([[my_id objectForKey:@"is_edit"] isEqualToString:@"1"]) {
             [self.textFieldMessage setText:[my_id objectForKey:@"value"]];
             }*/
            
            NSDictionary *my_id = [profiles objectForKey:@"my_id"];
            for (NSString* key in my_id) {
                NSDictionary* value = [my_id objectForKey:key];
                
                if ([[value objectForKey:@"is_edit"] isEqualToString:@"1"]) {
                    [self.textFieldMessage setText:[value objectForKey:@"value"]];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:NO];
                    });
                }
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
    NSString *strMyId = [self.textFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([strMyId isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty."];
    }else {
        /*
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        NSMutableDictionary *newMyID = [[NSMutableDictionary alloc] init];
        [newMyID setValue:strMyId forKey:@"value"];
        [newMyID setValue:@"0" forKey:@"is_edit"];
        
        NSMutableDictionary *newProfile = [[NSMutableDictionary alloc] init];
        [newProfile addEntriesFromDictionary:profiles];
        [newProfile removeObjectForKey:@"my_id"];
        [newProfile setValue:newMyID forKey:@"my_id"];
        
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
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update My ID."];
            }
        }];
        */
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update."];
        
        NSMutableDictionary *my_ids = [profiles objectForKey:@"my_id"];
        
        NSMutableDictionary *newMyids = [[NSMutableDictionary alloc] init];
        [newMyids addEntriesFromDictionary:my_ids];
        
        for (NSString* key in my_ids) {
            NSDictionary* value = [my_ids objectForKey:key];
            
            NSMutableDictionary *newMyid = [[NSMutableDictionary alloc] init];
            [newMyid addEntriesFromDictionary:value];
            [newMyid removeObjectForKey:@"value"];
            [newMyid setValue:strMyId forKey:@"value"];
            [newMyid setValue:@"0" forKey:@"is_edit"];
            
            [newMyids removeObjectForKey:key];
            [newMyids setValue:newMyid forKey:key];
            
            NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
            [newProfiles addEntriesFromDictionary:profiles];
            [newProfiles removeObjectForKey:@"my_id"];
            [newProfiles setValue:newMyids forKey:@"my_id"];
        
            
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
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update My ID."];
                }
            }];
            
        }
    }
}
@end
