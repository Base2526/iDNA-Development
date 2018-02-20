//
//  ViewComment.h
//  Heart
//
//  Created by Somkid on 4/14/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewComment_Center : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (strong, nonatomic) NSString *app_id, *post_id;

- (IBAction)onAddComment:(id)sender;
@end
