//
//  IDReusableView.h
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface IDReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet HJManagedImageV *photo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITextView *tvStatus;

@end
