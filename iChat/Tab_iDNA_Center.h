//
//  Tab_iDNA_Center.h
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface Tab_iDNA_Center : UIViewController
#import "KASlideShow.h"

@interface Tab_iDNA_Center : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, KASlideShowDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;
@property (strong, nonatomic) NSUserDefaults *preferences;

- (void) reloadData:(NSNotification *) notification;
- (void) reloadDataCenterSlide:(NSNotification *) notification;
@end
