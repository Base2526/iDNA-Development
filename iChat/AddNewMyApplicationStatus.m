//
//  AddNewMyApplicationStatus.m
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AddNewMyApplicationStatus.h"

@interface AddNewMyApplicationStatus ()

@end

@implementation AddNewMyApplicationStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    /*
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
    */
    //
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-Public" forIndexPath:indexPath];
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:10];
            UILabel *labelName = (UILabel *)[cell viewWithTag:11];
            
            [im setImage:[UIImage imageNamed:@"ic-green.png"]];
            
            if ([self.status isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-Private" forIndexPath:indexPath];
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:12];
            UILabel *labelName = (UILabel *)[cell viewWithTag:13];
            
            [im setImage:[UIImage imageNamed:@"ic-green.png"]];
            
            if ([self.status isEqualToString:@"1"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
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
    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
    //    if ([all_data count] == indexPath.row + 1) {
    //    }else{
    
    /*
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
    //    }
    [self reloadData];
    */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setStatus" object:nil userInfo:nil];
    
    // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    // [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
