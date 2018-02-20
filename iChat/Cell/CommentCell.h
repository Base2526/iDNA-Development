//
//  ViewPostCommentCell.h
//  Heart
//
//  Created by Somkid on 1/20/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "TopAlignedLabel.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *hjmImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet TopAlignedLabel *labelDetail;

@end
