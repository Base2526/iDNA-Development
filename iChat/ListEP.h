//
//  ListEP.h
//  Heart
//
//  Created by Somkid on 4/17/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ListEP : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UILabel *emptyMessage;

@property (strong, nonatomic) NSString *item_id, *category;
@property (nonatomic) BOOL isYes; // เป็น flag บอกว่า เป็น mail(TRUE) หรือ phone(FALSE)


@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
