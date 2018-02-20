//
//  MyID2.h
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MyID : UITableViewController<UIActionSheetDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onShare:(id)sender;
@end
