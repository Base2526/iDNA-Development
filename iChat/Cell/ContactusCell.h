//
//  ContactusCell.h
//  Heart-Basic
//
//  Created by somkid simajarn on 9/5/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;

@end
