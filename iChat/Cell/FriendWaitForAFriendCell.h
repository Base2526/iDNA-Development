//
//  FriendWaitForAFriendCell.h
//  iDNA
//
//  Created by Somkid on 18/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface FriendWaitForAFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelRequest;
@end

