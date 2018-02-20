//
//  CreateMyCard.h
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMyCard : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCreate;

- (IBAction)onClose:(id)sender;
- (IBAction)onCreate:(id)sender;
@end
