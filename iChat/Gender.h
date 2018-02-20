//
//  Gender.h
//  iDNA
//
//  Created by Somkid on 5/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Gender : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *item_id;
@end
