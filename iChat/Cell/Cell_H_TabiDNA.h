//
//  Cell_H_TabiDNA.h
//  iChat
//
//  Created by Somkid on 10/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface Cell_H_TabiDNA : UICollectionReusableView
@property (weak, nonatomic) IBOutlet HJManagedImageV *photo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITextView *tvStatus;

@end
