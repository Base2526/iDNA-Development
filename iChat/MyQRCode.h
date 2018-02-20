//
//  MyQRCode.h
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface MyQRCode : UIViewController
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjhQR;

- (IBAction)onSettings:(id)sender;

@end
