//
//  Tab_iDNA_MyApp.h
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab_iDNA_MyApp : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *_collection;
- (void) reloadData:(NSNotification *) notification;
@end
