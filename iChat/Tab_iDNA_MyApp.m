//
//  Tab_iDNA_MyApp.m
//  iDNA
//
//  Created by Somkid on 10/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_iDNA_MyApp.h"
#import "Configs.h"
#import "Cell_H_TabiDNA.h"
#import "Cell_H_S_TabiDNA.h"
#import "Cell_Item_TabiDNA.h"
#import "Cell_Item_Following_TabiDNA.h"
#import "RecipeViewCell.h"
#import "AppDelegate.h"
#import "CreateMyApplication.h"
#import "MyApp.h"
#import "MyApplicationsRepo.h"
#import "MyApplications.h"

@interface Tab_iDNA_MyApp (){
    NSMutableArray *sectionTitleArray;
    NSMutableDictionary *DNA;
    MyApplicationsRepo* myapplicationRepo;
}
@end

@implementation Tab_iDNA_MyApp
- (void)viewDidLoad {
    [super viewDidLoad];
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
    if (!sectionTitleArray) {
        sectionTitleArray = [NSMutableArray arrayWithObjects: @"My Application", @"Following", nil];
    }
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._collection setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
    myapplicationRepo =[[MyApplicationsRepo alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(reloadData:)
                                              name:RELOAD_DATA_MY_APPLICATIONS
                                            object:nil];
    [self reloadData:nil];
}
 
-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_MY_APPLICATIONS object:nil];
}

- (void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *_DNA = [[NSMutableDictionary alloc] init];
        
        // profile
        // [_DNA setValue:[[NSMutableDictionary alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
        
        // my application
        [_DNA setValue:[[NSMutableDictionary alloc] init] forKey:[sectionTitleArray objectAtIndex:0]];
        
        NSDictionary*data =  [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"my_applications"];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSString* key in data){
            // [items setObject:[data objectForKey:key] forKey:key];
            
            [items addObject:[data objectForKey:key]];
        }
        
        [items addObject:@{@"item_id":@"0"}];
        
        NSArray *sortedArray = [items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([[obj1 valueForKey:@"item_id"] integerValue] < [[obj2 valueForKey:@"item_id"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([[obj1 valueForKey:@"item_id"] integerValue] > [[obj2 valueForKey:@"item_id"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        // [_DNA setValue:sortedArray forKey:[sectionTitleArray objectAtIndex:0]];
        
        
        // ดึงข้อมูลจาก Database My Application
        /*
         #import "MyApplicationsRepo.h"
         #import "MyApplications.h"
         */
        
        NSMutableArray *allMyApp = [myapplicationRepo getMyApplicationAll];
        [_DNA setValue:allMyApp forKey:[sectionTitleArray objectAtIndex:0]];
       
        [DNA removeAllObjects];
        DNA = _DNA;
        
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [DNA count];
}

/* จำนวน item ของแต่ละ section */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    @try {
        NSArray * tmp = [DNA valueForKey:[sectionTitleArray objectAtIndex:section]];
        switch (section) {
            case 0:
            {
                return [tmp count] + 1;
            }
                break;
            case 1:
            {
                if ([tmp count] == 0) {
                    return 0;
                }else{
                    return [tmp count];
                }
            }
                break;
            default:
                break;
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
    }
    
    return 0;
}

//  section inset, spacing margins
/*
 โดย section 0 คือ profile เราจะให้ pading 0 ทั้งหมดเพราะไม่ต้องการให้มี ขอบ
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// ความสูงของแต่ Section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 00);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    RecipeViewCell *cell = nil;
    
    NSLog(@"%d", indexPath.section);
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                RecipeViewCell* cell = (RecipeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:nil];
                
                
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-white.png"]];
                cell.backgroundView.layer.cornerRadius = cell.backgroundView.frame.size.width / 2;
                cell.backgroundView.clipsToBounds = YES;
                
                // set border
                cell.backgroundView.layer.borderWidth = 3.0f;
                cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
                // set border
                
                cell.labelText.text = @"+";
                
                return cell;
            }else{
                
                Cell_Item_TabiDNA* cell = (Cell_Item_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_TabiDNA" forIndexPath:indexPath];
                
                NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:0]];
                NSMutableArray *_item = [_items objectAtIndex:indexPath.row - 1];
                /****/
                
                NSData *data =  [[_item objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                if (data == nil) {
                    return  cell;
                }
                
                NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                /***/
                cell.labelName.text = [f objectForKey:@"name"];
                if ([f objectForKey:@"image_url"]) {
                    [cell.hjmImage clear];
                    [cell.hjmImage showLoadingWheel]; // API_URL
                    [cell.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
                }else{
                    [cell.hjmImage clear];
                }
                return cell;
            }
        }
            break;
        case 1:{
            NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
            
            NSDictionary *_item = [_items objectAtIndex:indexPath.row];
            
            Cell_Item_Following_TabiDNA* cell = (Cell_Item_Following_TabiDNA *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Item_Following_TabiDNA" forIndexPath:indexPath];
            
            cell.labelName.text = [_item objectForKey:@"name"];
            // [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
            
            if ([[_item valueForKey:@"picture"] isKindOfClass:[NSDictionary class]]) {
                
                NSMutableDictionary *picture = [_item valueForKey:@"picture"];
                [cell.hjmImage clear];
                if ([picture count] > 0 ) {
                    [cell.hjmImage showLoadingWheel];
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [cell.hjmImage setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
                }else{
                    [cell.hjmImage setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
                }
            }
            if ([_item objectForKey:@"isNew"]) {
                if ([[_item objectForKey:@"isNew"] isEqualToString:@"1"]) {
                    cell.labelNew.hidden = FALSE;
                }else{
                    cell.labelNew.hidden = TRUE;
                }
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (indexPath.row == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CreateMyApplication *createMyApplication = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyApplication"];
                    [self.navigationController pushViewController:createMyApplication animated:YES];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:0]];
                    NSMutableArray *_item   = [_items objectAtIndex:indexPath.row - 1];
                    
                    NSString *app_id =  [_item objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
                    
                    MyApp *myApp    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
                    myApp.app_id  = app_id;
                    [self.navigationController pushViewController:myApp animated:YES];
                    
                });
            }
        }
            break;
            
        case 1:{
            // Following
            /*
             NSMutableArray * _items = [DNA valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
             
             NSDictionary *_item = [_items objectAtIndex:indexPath.row];
             
             UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             MyApp *v    = [storybrd instantiateViewControllerWithIdentifier:@"MyApp"];
             v.owner_id  = [[Configs sharedInstance] getUIDU];
             v.item_id   = [_item objectForKey:@"item_id"];
             v.category  = [_item objectForKey:@"category"];
             [self.navigationController pushViewController:v animated:YES];
             */
        }
            break;
        default:
            break;
    }
}


@end

