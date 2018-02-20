//
//  MyCard.h
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MyCard : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *row, *key ;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSUserDefaults *preferences;

- (IBAction)onPreview:(id)sender;
@end
