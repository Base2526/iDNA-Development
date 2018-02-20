//
//  BackgroundCard.m
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "BackgroundCard.h"

@interface BackgroundCard ()
{
    NSDictionary *all_data;
}
@end

@implementation BackgroundCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    all_data = @{
                                @"Defualt" : @"bg-card-heart.png",
                                @"Sea" : @"bg-card-sea.png",
                                @"Sands" : @"bg-card-sands.png"
                                };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 10;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [all_data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    NSArray *keys = [all_data allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *photo = (UIImageView *)[cell viewWithTag:10];
    UILabel *name = (UILabel *)[cell viewWithTag:11];
    UIImageView *iconCheck = (UIImageView *)[cell viewWithTag:12];
    
    [photo setImage:[UIImage imageNamed:[all_data valueForKey:aKey]]];
    [name setText:aKey];
    
    iconCheck.hidden = YES;
    if (self.select != nil) {
        if ([self.select isEqualToString:[NSString stringWithFormat:@"%d", indexPath.row]]) {
            iconCheck.hidden = NO;
        }
    }else{
        if (indexPath.row == 0) {
            iconCheck.hidden = NO;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"");
    
    self.select = [NSString stringWithFormat:@"%d", indexPath.row];
    
    [self._collection reloadData];
    
    NSArray *keys = [all_data allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];

    
    
    NSDictionary* sCategory = @{@"index": [NSString stringWithFormat:@"%d", indexPath.row], @"value" : aKey};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBG" object:self userInfo:sCategory];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
