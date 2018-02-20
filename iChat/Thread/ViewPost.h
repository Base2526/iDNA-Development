//
//  ViewPost.h
//  Heart
//
//  Created by Somkid on 1/19/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "TopAlignedLabel.h"
#import "KeyboardBar.h"

@interface ViewPost : UITableViewController<KeyboardBarDelegate>
@property (strong, nonatomic) NSString *owner_id/* เป้น uid ของเจ้าของ my application */, *nid, *nid_item;
@property (strong, nonatomic) NSMutableDictionary *data_item;

@end
