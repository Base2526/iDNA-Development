//
//  ListGroup.h
//  iDNA
//
//  Created by Somkid on 1/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListGroup : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) reloadData:(NSNotification *) notification;
@end
