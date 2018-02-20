//
//  CreateMyCardSelectEmail.m
//  Heart
//
//  Created by Somkid on 1/13/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "CreateMyCardSelectEmail.h"

@interface CreateMyCardSelectEmail () {
    NSMutableArray *fieldSelected;
    
    NSArray *all_data;
}

@end

@implementation CreateMyCardSelectEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fieldSelected = [NSMutableArray array];
    
    all_data = @[@"android.somkid@gmail.com", @"mr.simajarn@gmail.com", @"somkid@openserve.co.th"];
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
    
    
    // cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    
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
}

-(void) reloadData
{
    [self._table reloadData];
}

@end
