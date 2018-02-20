//
//  ListMyApplication.h
//  iDNA
//
//  Created by Somkid on 8/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListMyApplication : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void) reloadData:(NSNotification *) notification;

@end
