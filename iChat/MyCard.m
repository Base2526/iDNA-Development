//
//  MyCard.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MyCard.h"

#import "MCCardPickerCollectionViewController.h"
#import "MCSampleCardCollectionViewCell.h"
#import "AppConstant.h"
#import "Configs.h"

static NSString *const kCellIdentifier = @"MCSampleCell";


@interface MyCard ()<MCCardPickerCollectionViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{

    NSMutableArray *fieldSelected;
    
    NSArray *all_data;
    
    NSMutableDictionary *dictMyID;
}
@property (nonatomic, strong) MCCardPickerCollectionViewController *cardViewController;

@end

@implementation MyCard
@synthesize preferences;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // dictMyID = [[Configs sharedInstance] loadData:_USER_MY_ID];
    
    
    // NSDictionary * tmp = [dictMyID valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
    
    fieldSelected = [NSMutableArray array];
    
    all_data = @[@"Cell-Name", @"Cell-Photo", @"Cell-Email", @"Cell-Phone", @"Cell-BG", @"Cell-Delete"];
    
    self.cardViewController = [[MCCardPickerCollectionViewController alloc] init];
    self.cardViewController.delegate = self;
    [self.cardViewController.collectionView registerClass:[MCSampleCardCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    
    preferences = [NSUserDefaults standardUserDefaults];
    
    self.ref = [[FIRDatabase database] reference];
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/my-id/", [[Configs sharedInstance] getUIDU]];
    
    [[self.ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"");
        // dictMyID = [[Configs sharedInstance] loadData:_USER_MY_ID];
        [self reloadData];
    }];
    
    NSString *child_delete = [NSString stringWithFormat:@"heart-id/user-login/%@/my-id/my-card/%@/", [[Configs sharedInstance] getUIDU], self.row];

    [[self.ref child:child_delete] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    NSLog(@"");
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

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 100;
    }
    
    if ([all_data count] == indexPath.row + 1) {
        return 60;
    }
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [all_data count];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:[all_data objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    /*
     UILabel *name = (UILabel *)[cell viewWithTag:10];
     
     [name setText:[all_data objectAtIndex:indexPath.row]];
     
     
     if ([fieldSelected containsObject:indexPath])
     {
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     // [im setImage:[UIImage imageNamed:@"ic-check.png"]];
     }
     else
     {
     cell.accessoryType = UITableViewCellAccessoryNone;
     // [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
     }
     */
    
    
    // cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary * tmp = [[dictMyID valueForKey:self.key] objectForKey:self.row];
    
    
    switch (indexPath.row) {
        case 0:
        {
            UILabel *name = (UILabel *)[cell viewWithTag:10];
            name.text = [tmp objectForKey:@"name"];
        }
            break;
            
        case 2:
        {
            UILabel *email = (UILabel *)[cell viewWithTag:10];
            
            if ([tmp objectForKey:@"phone"]) {
            
                NSMutableString* theString = [NSMutableString string];
            
                for (id object in [tmp objectForKey:@"email"]) {
                    [theString appendString:[NSString stringWithFormat:@"%@, ", object]];
                }
                email.text = theString;
            }else{
                email.text = @"Not set";
            }
        }
            break;
            
        case 3:
        {
            UILabel *phone = (UILabel *)[cell viewWithTag:10];
            
            
            if ([tmp objectForKey:@"phone"]) {
                NSMutableString* theString = [NSMutableString string];
                
                for (id object in [tmp objectForKey:@"phone"]) {
                    [theString appendString:[NSString stringWithFormat:@"%@, ", object]];
                }
                phone.text = theString;
            }else{
                phone.text = @"Not set";
            }
           
        }
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);
    
    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
    //    if ([all_data count] == indexPath.row + 1) {
    //    }else{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
    //self.selectedIndexPath = indexPath;
    
    
    
    //the below code will allow multiple selection
    /*
    if ([fieldSelected containsObject:indexPath])
    {
        [fieldSelected removeObject:indexPath];
    }
    else
    {
        [fieldSelected addObject:indexPath];
    }
     */
    //    }
    [self reloadData];
}

-(void) reloadData
{
    [self._table reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCSampleCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.cardRadius = 4.0;
    cell.label.text = @"User";
    return cell;
}

#pragma mark - MCCardPickerCollectionViewControllerDelegate

- (void)cardPickerCollectionViewController:(MCCardPickerCollectionViewController *)cardPickerCollectionViewController preparePresentingView:(UIView *)presentingView fromSelectedCell:(UICollectionViewCell *)cell
{
    // Let the MCCardPickerCollectionViewController take care of scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.delegate = cardPickerCollectionViewController;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 900, CGRectGetWidth(self.view.frame)-40, 30);
    [button setTitle:@"Choose Me :)" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0.15 green:0.65 blue:0.69 alpha:1]];
    [scrollView addSubview:button];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(button.frame)+100)];
    [presentingView addSubview:scrollView];
    
    UIImage *blurImage = [(MCSampleCardCollectionViewCell *)cell blurImage];
    presentingView.layer.contents = (id)blurImage.CGImage;
}

- (IBAction)onPreview:(id)sender {
    // [self.cardViewController presentInViewController:self];
    
    [self presentViewController:self.cardViewController animated:YES completion:nil];
}
@end

