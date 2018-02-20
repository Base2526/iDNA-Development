//
//  ViewImageView.h
//  Heart
//
//  Created by Somkid on 12/23/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface ViewImageView : UIViewController
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImage;

@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) UIImage *image;
- (IBAction)onClose:(id)sender;

@end
