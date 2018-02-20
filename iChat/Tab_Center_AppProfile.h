//
//  Tab_Center_AppProfile.h
//  iDNA
//
//  Created by Somkid on 25/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;
#import "TopAlignedLabel.h"

@interface Tab_Center_AppProfile : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

// @property (strong, nonatomic) NSString *owner_id, *item_id;

@property(strong, nonatomic) NSString *app_id;
@property (strong, nonatomic) NSMutableDictionary *data ;

@property (nonatomic) BOOL isOwner;
@end

