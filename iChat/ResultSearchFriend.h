//
//  ResultSearchFriend.h
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

#import "AddFriendThread.h"

@interface ResultSearchFriend : UIViewController

@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImg;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;


@property (strong, nonatomic) NSDictionary *queryStringDictionary;
@property (strong, nonatomic) NSString *isQR; /* 0= มาจาก id, 1 = เป็นการ Scan QRCode  */ 


- (IBAction)onAddFriend:(id)sender;


- (IBAction)onClose:(id)sender;
@end
