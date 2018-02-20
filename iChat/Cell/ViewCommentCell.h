//
//  ViewCommentCell.h
//  Heart
//
//  Created by Somkid on 4/14/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopAlignedLabel.h"

@interface ViewCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TopAlignedLabel *text;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@end
