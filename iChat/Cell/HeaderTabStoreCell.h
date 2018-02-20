//
//  HeaderTabStoreCell.h
//  Heart
//
//  Created by Somkid on 4/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface HeaderTabStoreCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet KASlideShow *ksView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
