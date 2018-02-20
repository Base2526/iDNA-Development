//
//  ListPeopleLike.h
//  Heart
//
//  Created by Somkid on 4/14/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPeopleLike : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@property (strong, nonatomic) NSString *application_id, *post_id, *category;
@end
