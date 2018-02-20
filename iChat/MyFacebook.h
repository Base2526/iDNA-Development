//
//  MyFacebook.h
//  iDNA
//
//  Created by Somkid on 17/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MyFacebook : UIViewController
@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
- (IBAction)onOpenMyFacebook:(id)sender;
- (IBAction)onLogout:(id)sender;
    
@end
