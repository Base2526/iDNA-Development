//
//  BlockFriends.h
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockFriends : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
