//
//  Tab_Chats.h
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab_Chats : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
