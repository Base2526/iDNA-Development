//
//  AddNewMyApplicationStatus.h
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewMyApplicationStatus : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *status; // 0 = public, 1 = private
@end
