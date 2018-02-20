//
//  FriendRequestCell.h
//  iDNA
//
//  Created by Somkid on 9/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface FriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteRequest;

@end
