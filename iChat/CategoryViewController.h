//
//  CategoryViewController.h
//  MyID-UI
//
//  Created by Somkid on 12/12/2559 BE.
//  Copyright © 2559 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *category;

@end
