//
//  CategoryViewController.m
//  MyID-UI
//
//  Created by Somkid on 12/12/2559 BE.
//  Copyright © 2559 klovers.org. All rights reserved.
//

#import "SubcategoryViewController.h"
#import "ApplicationCategoryThread.h"
#import "Configs.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "AppConstant.h"

@interface SubcategoryViewController (){
    NSDictionary *children; //  = @[@"1", @"2", @"3", @"4", @"5"];
    
    NSMutableArray * sortedKeys;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation SubcategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//
//    activityIndicator.center=self.view.center;
//    [activityIndicator startAnimating];
//    [self.view addSubview:activityIndicator];
    
    // all_data = [[NSDictionary alloc] init];
    
    // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    children = [[[[Configs sharedInstance] loadData:_CATEGORY_APPLICATION] objectForKey:self.category] objectForKey:@"children"];
    
    // key    NSTaggedPointerString *    @"children"    0xa0039504228500b8
    NSLog(@"");
    /*
    if ([all_data count] == 0){
        ApplicationCategoryThread *categoryThread = [[ApplicationCategoryThread alloc] init];
        [categoryThread setCompletionHandler:^(NSString * data) {
        
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {

                all_data = jsonDict[@"data"];
            
                [[Configs sharedInstance] saveData:_CATEGORY_APPLICATION :all_data];
            
            
                sortedKeys = [[all_data allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
                
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];

                [self reloadData];
            }else{
     
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }
        
        }];
        [categoryThread setErrorHandler:^(NSString * error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
    
        [categoryThread start];
    }else{
        sortedKeys = [[all_data allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews {
//    activityIndicator.center = self.view.center;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HJManagedImageV *im = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *text = (UILabel *)[cell viewWithTag:10];
    
    // [im setImage:[UIImage imageNamed:@"ic-green.png"]];
    // [text setText:[all_data objectAtIndex:indexPath.row]];
    
    NSArray *keys = [children allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    NSDictionary* item = [children objectForKey:key];
    
    [text setText:[item objectForKey:@"name"]];
    
    if ([item objectForKey:@"field_image"]) {
        [im clear];
        [im showLoadingWheel]; // API_URL
        [im setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"field_image"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:im ];
    }else{
        [im clear];
    }
    
    if (self.subcategory != nil) {
        if ([self.subcategory isEqualToString: key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keys = [children allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    NSDictionary* item = [children objectForKey:key];

    NSDictionary* sCategory = @{@"index": key, @"value" : [item objectForKey:@"name"]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectSubcategory" object:self userInfo:sCategory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) reloadData
{
    [self._table reloadData];
}

@end
