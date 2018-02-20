//
//  Tab_iDNA_MyApp.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_iDNA_Following.h"
#import "Configs.h"
#import "Cell_H_TabiDNA.h"
#import "Cell_H_S_TabiDNA.h"
#import "Cell_Item_TabiDNA.h"
#import "Cell_Item_Following_TabiDNA.h"
#import "RecipeViewCell.h"
#import "AppDelegate.h"
#import "CreateMyApplication.h"
#import "MyApp.h"
#import "FollowingRepo.h"
#import "Following.h"

#import "CenterRepo.h"
#import "Center.h"

#import "Tab_Center_Detail.h"

@interface Tab_iDNA_Following (){
    CenterRepo *centerRepo;
    FollowingRepo* followingRepo;
    NSMutableDictionary *data;
}
@end

@implementation Tab_iDNA_Following

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     #1 Register: Cell Header คือส่วนหัวของ Tab idna
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_H_TabiDNA" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"Cell_H_TabiDNA"];
    
    /*
     #2 Register: Cell Header Section
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_H_S_TabiDNA" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"Cell_H_S_TabiDNA"];
    
    /*
     #3 Register: Cell Item
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_Item_TabiDNA" bundle:nil] forCellWithReuseIdentifier:@"Cell_Item_TabiDNA"];
    
    /*
     #3 Register: Cell Item Following
     */
    [self._collection registerNib:[UINib nibWithNibName:@"Cell_Item_Following_TabiDNA" bundle:nil] forCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA"];

    
    // ชื่อ Section
//    if (!sectionTitleArray) {
//        sectionTitleArray = [NSMutableArray arrayWithObjects: @"Following", nil];
//    }
    
    data = [[NSMutableDictionary alloc] init];
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._collection setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
    centerRepo = [[CenterRepo alloc] init];
    followingRepo =[[FollowingRepo alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_FOLLOWING
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_FOLLOWING object:nil];
}

- (void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *follow_all = [followingRepo getFollowingAll];
        
        [data removeAllObjects];
        for (int i = 0; i < [follow_all count]; i++) {
            NSMutableArray *_item = [follow_all objectAtIndex:i];
            
            NSData *follow_data =  [[_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * fol = [NSJSONSerialization JSONObjectWithData:follow_data options:0 error:nil];
            if ([[fol objectForKey:@"status"] isEqualToString:@"0"]) {
                continue;
            }
            
            NSString *item_id = [_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
            
            NSArray * l = [centerRepo get:item_id];
            if (l != nil) {
                NSData *center_data =  [[[centerRepo get:item_id] objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                [data setObject:[NSJSONSerialization JSONObjectWithData:center_data options:0 error:nil] forKey:item_id];
            }else{
                [data setObject:@"" forKey:item_id];
            }
        }
        [self._collection reloadData];
    });
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

/* จำนวน section */
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return [allFollowing count];
//}

/* จำนวน item ของแต่ละ section */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [data count];
}

//  section inset, spacing margins
/*
 โดย section 0 คือ profile เราจะให้ pading 0 ทั้งหมดเพราะไม่ต้องการให้มี ขอบ
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// ความสูงของแต่ Section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    /*
    NSMutableArray *_item = [data objectAtIndex:indexPath.row];
    CenterRepo *centerRepo = [[CenterRepo alloc] init];
    
    NSArray *lll = [centerRepo getCenterAll];
    NSArray *item_ct =  [centerRepo get:[_item objectAtIndex:[followingRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]]];
    
    NSData *data_ct =  [[item_ct objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data_ct options:0 error:nil];
    */
    
    NSArray *keys = [data allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    NSMutableDictionary *f = [data objectForKey:aKey];
    
    Cell_Item_Following_TabiDNA* cell = (Cell_Item_Following_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA" forIndexPath:indexPath];
    
    cell.labelName.text = [f objectForKey:@"name"];
    if ([f objectForKey:@"image_url"]) {
        [cell.hjmImage clear];
        [cell.hjmImage showLoadingWheel];
        
        [cell.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *keys = [data allKeys];
    NSString* app_id = [keys objectAtIndex:indexPath.row];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tab_Center_Detail *tab_Center_Detail    = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Center_Detail"];
    tab_Center_Detail.app_id   = app_id;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:tab_Center_Detail animated:YES];
    });
}
@end

