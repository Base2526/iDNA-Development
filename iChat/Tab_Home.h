//
//  Tab_Home.h
//  iDNA
//
//  Created by Somkid on 4/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"


@interface Tab_Home : UIViewController

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelSMessage;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV_qrcode;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageBG;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_edit;


- (IBAction)onSettings:(id)sender;
- (IBAction)onClose:(id)sender;


@end
