//
//  EditEmail.h
//  Heart
//
//  Created by Somkid on 1/24/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNameMAProfile : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) NSString *fction/* เป็นตัวบอกว่า เพิ่มหรือ แก้ไข */, *item_id, *name;

- (IBAction)onSave:(id)sender;
@end
