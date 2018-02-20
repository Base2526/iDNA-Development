//
//  MyCardPhotoCell.h
//  Heart
//
//  Created by Somkid on 1/15/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface MyCardPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmPhoto;

@end
