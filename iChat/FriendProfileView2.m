//
//  FriendProfile.m
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "FriendProfileView2.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UpdatePictureProfileThread.h"
#import "UpdateMyProfileThread.h"
#import "FriendProfileRepo.h"
#import "SelectFriendClasss.h"
#import "Classs.h"
#import "ClasssRepo.h"
#import "FriendsRepo.h"

@interface FriendProfileView2 (){
    FriendProfileRepo *friendPRepo;
    FriendsRepo *friendsRepo;
}
@end

@implementation FriendProfileView2
@synthesize imageV, ref, txtFName, lblEmail, txtFStatus, txtIsFavorite, btnClasss;

// new
@synthesize friend_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    friendsRepo = [[FriendsRepo alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    [self reloadData:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"Tab_Contacts_reloadData"
                                               object:nil];
   
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{

    // new
    friendPRepo = [[FriendProfileRepo alloc] init];
    
    NSArray *fprofile = [friendPRepo get:friend_id];
    NSData *data =  [[fprofile objectAtIndex:[friendPRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // imageV.userInteractionEnabled = YES;
    // [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([profiles objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }
    
    txtFName.text =[profiles objectForKey:@"name"];
    txtFName.enabled = NO;
    lblEmail.text =[profiles objectForKey:@"mail"];
    lblEmail.enabled = NO;
    
    txtFStatus.enabled = NO;
    if ([profiles objectForKey:@"status_message"]) {
        txtFStatus.text =[profiles objectForKey:@"status_message"];
    }
    
    
    
    // NSMutableArray * fs = [friendsRepo getFriendsAll];
    
    NSMutableArray * fs = [friendsRepo get:friend_id];
        
    NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:[[fs objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // txtIsFavorite
    // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    
    // NSDictionary * friend = [friends objectForKey:friend_id];
    txtIsFavorite.enabled = NO;
    txtIsFavorite.text = @"NO";
    if ([friend objectForKey:@"favorite"]) {
        if ([[friend objectForKey:@"favorite"] isEqualToString:@"1"]) {
            txtIsFavorite.text = @"YES";
        }
    }
    
    /*
    NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
    NSMutableDictionary *local_friend  = [local_friends objectForKey:friend_id];
    // [friend setValue:class forKey:@"classs"];
    */
    NSArray *val =  [friendsRepo get:friend_id];
    
    NSDictionary* fc = [NSJSONSerialization JSONObjectWithData:[[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    if ([fc objectForKey:@"classs"]) {
        ClasssRepo * classsRepo = [[ClasssRepo alloc] init];
        NSArray *class = [classsRepo get:[fc objectForKey:@"classs"]];
        
        NSData *class_data =  [[class objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *tmp = [NSJSONSerialization JSONObjectWithData:class_data options:0 error:nil];
        
        [btnClasss setTitle:[tmp objectForKey:@"name"] forState:UIControlStateNormal];
    }else{
        [btnClasss setTitle:@"ยังไม่ได้กำหนดคลาส" forState:UIControlStateNormal];
    }
}

- (IBAction)onSelectClasss:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SelectFriendClasss* selectFriendClasss = [storybrd instantiateViewControllerWithIdentifier:@"SelectFriendClasss"];
    selectFriendClasss.friend_id = friend_id;
    [self.navigationController pushViewController:selectFriendClasss animated:YES];
}
@end

