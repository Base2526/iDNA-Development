//
//  Follower.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "Follower.h"
#import "FollowerCell.h"
#import "AppConstant.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "GetProfilesThread.h"
#import "MyApplicationsRepo.h"
#import "MyApplications.h"
#import "FriendProfileRepo.h"
#import "FriendProfile.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Follower () {
    NSMutableArray *follower;
    UIActivityIndicatorView *activityIndicator;
    MyApplicationsRepo *myapplicationsRepo;
    FriendProfileRepo *friendProfileRepo;
    
    FIRDatabaseReference *ref;
}
@end

@implementation Follower
@synthesize app_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    follower = [[NSMutableArray alloc] init];
    [self._table registerNib:[UINib nibWithNibName:@"FollowerCell" bundle:nil] forCellReuseIdentifier:@"FollowerCell"];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    myapplicationsRepo = [[MyApplicationsRepo alloc] init];
    friendProfileRepo = [[FriendProfileRepo alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_MY_APPLICATIONS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_CENTER
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_MY_APPLICATIONS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CENTER object:nil];
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [follower count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"FollowerCell";
    FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([[follower objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *f = [follower objectAtIndex:indexPath.row];
        
        cell.labelName.text = [f objectForKey:@"name"];
        if ([f objectForKey:@"image_url"]) {
            [cell.imageV clear];
            [cell.imageV showLoadingWheel]; // API_URL
            [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
        }else{
            [cell.imageV clear];
        }
    }else{
        // Observers
        NSString *child = [NSString stringWithFormat:@"%@%@/profiles", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [follower objectAtIndex:indexPath.row]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@ -> %@", snapshot.key, snapshot.value, snapshot.ref);
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfileFriend:snapshot.key :snapshot.value];
            
            NSMutableDictionary *f = snapshot.value;
            
            cell.labelName.text = [f objectForKey:@"name"];
            if ([f objectForKey:@"image_url"]) {
                [cell.imageV clear];
                [cell.imageV showLoadingWheel]; // API_URL
                [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
            }else{
                [cell.imageV clear];
            }
        }];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self reloadData:nil];
}

-(void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [follower removeAllObjects];
        
        NSData *data =  [[[myapplicationsRepo get:app_id] objectAtIndex:[myapplicationsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary* _fl = [f objectForKey:@"follows"];
        
        for (NSString* key in _fl) {
            NSDictionary* value = [_fl objectForKey:key];
            
            if([[value objectForKey:@"status"] isEqualToString:@"1"]){
                NSArray*friend =  [friendProfileRepo get:[value objectForKey:@"uid"]];
                if (friend != nil) {
                    NSData *data =  [[friend objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [follower addObject:f];
                }else{
                    [follower addObject:[value objectForKey:@"uid"]];
                }
            }
        }
        
        [self._table reloadData];
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    });
}
@end

