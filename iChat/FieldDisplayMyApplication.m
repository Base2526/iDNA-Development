//
//  FieldDisplayMyApplication.m
//  Heart
//
//  Created by Somkid on 1/11/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "FieldDisplayMyApplication.h"

#import "CreateMyApplicationThread.h"
#import "Configs.h"
#import "AddNewMyApplicationStatus.h"

@interface FieldDisplayMyApplication ()
{
    NSArray *all_data;
    NSMutableArray *fieldSelected;
}

@end

@implementation FieldDisplayMyApplication
@synthesize photo, name, category;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fieldSelected = [NSMutableArray array];
    all_data = @[@"email", @"phone", @"heart", @"facebook", @"google+", @"line", @"ig", @"Status"];
    
    self.btnCreate.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
     NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
    
    // APstatus
    
    if ([segue.identifier isEqualToString:@"APstatus"]) {
        
        // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
        // get register to fetch notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setStatus:)
                                                     name:@"setStatus" object:nil];
        
        AddNewMyApplicationStatus* v = segue.destinationViewController;
        // v.category = indexCategory;
        
        if ([fieldSelected containsObject:indexPath])
        {
            // cell.accessoryType = UITableViewCellAccessoryCheckmark;
           //  [labelStatus setText:@"Private"];
            v.status = @"1";
        }
        else
        {
            // cell.accessoryType = UITableViewCellAccessoryNone;
           //  [labelStatus setText:@"Public"];
            
            v.status = @"0";
        }
    }
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [all_data count];//[[contact allKeys] count]-3;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
    if ([all_data count] == indexPath.row + 1) {
    
        static NSString *CellIdentifier = @"Cell-Public";
        
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-Public" forIndexPath:indexPath];
        
        UIImageView *icon = (UIImageView *)[cell viewWithTag:11];
        UILabel *labelName = (UILabel *)[cell viewWithTag:12];
        UILabel *labelStatus = (UILabel *)[cell viewWithTag:13];
        
        
        [icon setImage:[UIImage imageNamed:@"ic-green.png"]];
        [labelName setText:[all_data objectAtIndex:indexPath.row]];
        
        
        if ([fieldSelected containsObject:indexPath])
        {
            // cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [labelStatus setText:@"Private"];
        }
        else
        {
            // cell.accessoryType = UITableViewCellAccessoryNone;
            [labelStatus setText:@"Public"];
        }
        
    }else{
    
        static NSString *CellIdentifier = @"Cell";
        
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//        }
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UIImageView *icon = (UIImageView *)[cell viewWithTag:9];
        UILabel *label = (UILabel *)[cell viewWithTag:10];
        [label setText:[all_data objectAtIndex:indexPath.row]];
        
        [icon setImage:[UIImage imageNamed:@"ic-green.png"]];
        
        if ([fieldSelected containsObject:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);

    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
    if ([all_data count] == indexPath.row + 1) {
    }else{
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
        //self.selectedIndexPath = indexPath;
    
        //the below code will allow multiple selection
        if ([fieldSelected containsObject:indexPath])
        {
            [fieldSelected removeObject:indexPath];
        }
        else
        {
            [fieldSelected addObject:indexPath];
        }
    }
    [self reloadData];
}

-(void)setStatus:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[all_data count]-1 inSection:0];
    
    if ([fieldSelected containsObject:indexPath])
    {
        [fieldSelected removeObject:indexPath];
    }
    else
    {
        [fieldSelected addObject:indexPath];
    }
    
    // [[NSNotificationCenter defaultCenter] removeObserver:someObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setStatus" object:nil];
    
    [self reloadData];
}

-(void)reloadData
{
    if([fieldSelected count] > 0){
        self.btnCreate.enabled = YES;
    }else{
        self.btnCreate.enabled = NO;
    }
    [self._table reloadData];
}

- (IBAction)onCreate:(id)sender {
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    CreateMyApplicationThread *createAppThread = [[CreateMyApplicationThread alloc] init];
    [createAppThread setCompletionHandler:^(NSData * data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        // homeViewController.urlString = @"https://www.facebook.com/samosornpatumwan";
        // homeViewController.title = @"Home";
        // UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        
        NSLog(@"+ %@ +", jsonDict);
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Check Verify for email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//            
//            alertView.tag = 45;
//            alertView.delegate = self;
//            [alertView show];
            
            
        }else{
            /*
             email นี้มีการ register แล้ว
             */
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
        }
       //  [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissAddNewMyApplication" object:nil userInfo:nil];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [createAppThread setErrorHandler:^(NSString * error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    // [anNThread start:strEmail];
    // [createAppThread start:photo :name :category :fieldSelected];
    
}
@end
