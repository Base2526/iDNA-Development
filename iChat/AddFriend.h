//
//  ListFriends.h
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

@interface AddFriend : UIViewController<UITableViewDelegate, UITableViewDataSource, ZXCaptureDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_table;

@end
