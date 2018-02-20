//
//  MyAppHeaderCell.h
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface MyAppHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *btnFollower;
//@property (weak, nonatomic) IBOutlet UILabel *labelFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;

@end
