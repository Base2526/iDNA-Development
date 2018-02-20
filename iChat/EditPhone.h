//
//  EditPhone.h
//  Heart
//
//  Created by Somkid on 12/22/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhone : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
- (IBAction)onSave:(id)sender;

@property (strong, nonatomic) NSString *fction/* เป็นตัวบอกว่า เพิ่มหรือ แก้ไข */, *item_id, *number;

@end
