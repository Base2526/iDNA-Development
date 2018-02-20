//
//  SetMyID.h
//  Heart
//
//  Created by Somkid on 12/29/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMyID : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldMessage;
- (IBAction)onSave:(id)sender;

@property (strong, nonatomic) NSString *message;
@end
