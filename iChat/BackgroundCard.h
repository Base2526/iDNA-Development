//
//  BackgroundCard.h
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundCard : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;


@property (strong, nonatomic) NSString *select;
@end
