//
//  MyFacebook.m
//  iDNA
//
//  Created by Somkid on 17/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "MyFacebook.h"
#import "ProfilesRepo.h"
#import "AppDelegate.h"
#import "Configs.h"

@interface MyFacebook (){
    NSMutableDictionary *profiles;
    ProfilesRepo *profileRepo;
    
    FIRDatabaseReference *ref;
}

@end

@implementation MyFacebook
@synthesize imageV, labelName, labelEmail;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    profileRepo = [[ProfilesRepo alloc] init];
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
    NSArray *pf = [profileRepo get];
    NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if([profiles objectForKey:@"facebook"]){
        NSDictionary *facebook = [profiles objectForKey:@"facebook"];
        
        if([facebook objectForKey:@"name"]){
            [labelName setText:[facebook objectForKey:@"name"]];
        }
        
        if([facebook objectForKey:@"email"]){
            [labelEmail setText:[facebook objectForKey:@"email"]];
        }
        
        if([facebook objectForKey:@"picture"]){
            NSDictionary *picture = [facebook objectForKey:@"picture"];
            
            if ([picture objectForKey:@"data"]) {
                [imageV clear];
                [imageV showLoadingWheel];
                
                [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[picture objectForKey:@"data"] objectForKey:@"url"]  ]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            }
        }
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onOpenMyFacebook:(id)sender {
    
    NSDictionary *facebook = [profiles objectForKey:@"facebook"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [facebook objectForKey:@"link"] ]];
    [[UIApplication sharedApplication] openURL:url];
//    if([facebook objectForKey:@"link"]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[facebook objectForKey:@"link"]]];
//    }
    
    // https://www.facebook.com/next.station.5
    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
//
//        NSString* encodedUrl = [[facebook objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:
//                                NSUTF8StringEncoding];
//        //Ndom%20Nuon
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", @"Ndom%20Nuon"]];
//        [[UIApplication sharedApplication] openURL:url];
//
//
//        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/573395209427571"]];
//    }
//    else {
//
//    }
    
    
    
}
    
- (IBAction)onLogout:(id)sender {
    
    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/facebook", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU]];
    
    [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error == nil) {
            // จะได้ friend_id
            NSString* key = [ref key];
            
            if (error == nil) {
                NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
                [newProfiles addEntriesFromDictionary:profiles];
                
                if([newProfiles objectForKey:@"facebook"]){
                    [newProfiles removeObjectForKey:@"facebook"];
                }
               
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
            }
        }
    }];
}
    @end
