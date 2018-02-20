//
//  FriendID_Menu.h
//  Heart
//
//  Created by Somkid on 2/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendID_Menu : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *row ;


@end
