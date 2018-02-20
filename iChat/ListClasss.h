//
//  ManageClass.h
//  iDNA
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListClasss : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void) reloadData:(NSNotification *) notification;
@end
