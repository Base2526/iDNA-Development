//
//  AnNmousUVerify.h
//  Heart
//
//  Created by Somkid on 1/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnNmousUVerify : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *texfieldCodeVerify;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (strong, nonatomic) NSString *email;
- (IBAction)onOK:(id)sender;
- (IBAction)onClose:(id)sender;
@end
