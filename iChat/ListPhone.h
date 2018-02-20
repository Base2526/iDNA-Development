//
//  ListPhone.h
//  Heart
//
//  Created by Somkid on 1/23/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ListPhone : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@end
