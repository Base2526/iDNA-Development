//
//  TabBarHome.h
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KASlideShow.h"

@interface Tab_Center : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, KASlideShowDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;
@property (strong, nonatomic) NSUserDefaults *preferences;

@end
