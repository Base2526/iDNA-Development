//
//  InviteFriendByEmail.h
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendByEmail : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

- (IBAction)onSend:(id)sender;
- (IBAction)onClose:(id)sender;

@end
