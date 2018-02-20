//
//  ListEmail.h
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Friend_ListEmail : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (strong, nonatomic) NSString *friend_id;
@end
