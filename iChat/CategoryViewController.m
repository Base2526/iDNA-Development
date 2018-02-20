//
//  CategoryViewController.m
//  MyID-UI
//
//  Created by Somkid on 12/12/2559 BE.
//  Copyright © 2559 klovers.org. All rights reserved.
//

#import "CategoryViewController.h"
#import "ApplicationCategoryThread.h"
#import "Configs.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "AppConstant.h"

@interface CategoryViewController (){
    NSDictionary *all_data; //  = @[@"1", @"2", @"3", @"4", @"5"];
    
    NSMutableArray * sortedKeys;
    
    
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activityIndicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    // all_data = [[NSDictionary alloc] init];
    
    // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    
    all_data = [[Configs sharedInstance] loadData:_CATEGORY_APPLICATION];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}

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
    return [all_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HJManagedImageV *im = (HJManagedImageV *)[cell viewWithTag:9];
    UILabel *text = (UILabel *)[cell viewWithTag:10];
    
    // [im setImage:[UIImage imageNamed:@"ic-green.png"]];
    // [text setText:[all_data objectAtIndex:indexPath.row]];
    
    
    id key = [sortedKeys objectAtIndex:indexPath.row];
    
    // items_post
//    NSArray *keys = [all_data allKeys];
//    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [all_data objectForKey:key];

    [text setText:[anObject objectForKey:@"name"]];
    
    
    NSString *field_image= [anObject objectForKey:@"field_image"];
    if (![field_image isEqualToString:@""]) {
        
//        NSDictionary *tags_image =  [anObject objectForKey:@"field_image"];
//        NSLog(@"%@", [tags_image objectForKey:@"filename"]);
//
//        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [tags_image objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:
//                         NSUTF8StringEncoding];
        
        [im clear];
        [im showLoadingWheel];
        [im setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,field_image]]];

        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:im ];
    }
    
    if (self.category != nil) {
        if ([self.category isEqualToString: key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [sortedKeys objectAtIndex:indexPath.row];
    
    NSDictionary* sCategory = @{@"index": key, @"value" : [[all_data objectForKey:key] objectForKey:@"name"]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCategory" object:self userInfo:sCategory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) reloadData
{
    [self._table reloadData];
}

@end
