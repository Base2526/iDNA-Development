//
//  MyApp.h
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MyApp : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property(strong, nonatomic) NSString *app_id;

@property (nonatomic)BOOL is_following;
@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onSettings:(id)sender;
@end
