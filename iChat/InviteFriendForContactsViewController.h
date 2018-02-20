//
//  InviteFriendForContactsViewController.h
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendForContactsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
- (IBAction)onClose:(id)sender;

@end
