//
//  MyAppCell.h
//  Heart
//
//  Created by Somkid on 1/18/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "TopAlignedLabel.h"

@interface MyAppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *btnPopup;
@property (weak, nonatomic) IBOutlet TopAlignedLabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

@property (weak, nonatomic) IBOutlet UIButton *btnComment;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end
