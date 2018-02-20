//
//  SelectFriendClasss.h
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendClasss : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) NSString*friend_id;
@end
