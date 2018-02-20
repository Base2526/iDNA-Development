//
//  FieldDisplayMyApplication.h
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldDisplayMyApplication : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCreate;

@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSString *name, *category;

- (IBAction)onCreate:(id)sender;


@end
