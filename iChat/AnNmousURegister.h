//
//  AnNmousURegister.h
//  Heart
//
//  Created by Somkid on 1/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnNmousURegister : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UITextField *txtfieldEmail;

- (IBAction)onShow:(id)sender;
- (IBAction)onHide:(id)sender;

- (IBAction)onOK:(id)sender;
- (IBAction)onClose:(id)sender;
@end
