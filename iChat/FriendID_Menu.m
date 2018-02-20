//
//  FriendID_Menu.m
//  Heart
//
//  Created by Somkid on 2/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "FriendID_Menu.h"

@interface FriendID_Menu (){
    NSArray *all_data;
}

@end

@implementation FriendID_Menu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    all_data = @[@"edit", @"delete"];
    self._table.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // self.preferredContentSize=self._table.contentSize;
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
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [all_data count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *name = (UILabel *)[cell viewWithTag:10];
    name.text = [all_data objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* data = @{@"row": self.row, @"index": [NSString stringWithFormat:@"%d", indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendID_Menu" object:self userInfo:data];
}

-(void) reloadData
{
    [self._table reloadData];
}

@end
