//
//  TabStoreCell.h
//  Heart
//
//  Created by Somkid on 4/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface TabStoreCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjImageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end
