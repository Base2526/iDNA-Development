//
//  ListPeopleLike.m
//  Heart
//
//  Created by Somkid on 4/14/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ListPeopleLike.h"
#import "PeopleLikeCell.h"
#import "AppConstant.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "GetProfilesThread.h"

@interface ListPeopleLike (){
    NSMutableArray *data;
    
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation ListPeopleLike
@synthesize application_id, post_id, category;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    data = [[NSMutableArray alloc] init];
    [self._table registerNib:[UINib nibWithNibName:@"PeopleLikeCell" bundle:nil] forCellReuseIdentifier:@"PeopleLikeCell"];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    [self reloadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
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

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PeopleLikeCell";
    
    PeopleLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.labelName.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    NSMutableDictionary *picture = [[data objectAtIndex:indexPath.row] valueForKey:@"picture"];
    [cell.imageV clear];
    if ([picture count] > 0 ) {
        [cell.imageV showLoadingWheel];
        
        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.imageV setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        cell.imageV.layer.cornerRadius = 5;
        cell.imageV.clipsToBounds = YES;
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV ];
    }else{
        [cell.imageV setImage:[UIImage imageNamed:@"ic-bizcards.png"]];
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
    
    //    }
    [self reloadData:nil];
}

-(void) reloadData:(NSNotification *) notification{
    NSArray *_center =  [[Configs sharedInstance] loadData:_CENTER];
    
    NSDictionary * items_application = [[_center objectAtIndex:[category integerValue]] objectForKey:application_id];
    
    if ([items_application objectForKey:post_id]) {
        NSArray*keys = [[[items_application objectForKey:post_id] objectForKey:@"like"] allKeys];
    
        NSMutableArray *uids = [[NSMutableArray alloc] init];
        
        NSDictionary *_itms = [[items_application objectForKey:post_id] objectForKey:@"like"];
        for (NSString* _kitm in _itms) {
            NSDictionary *_itm  = [_itms objectForKey:_kitm];
            if ([[_itm objectForKey:@"isLike"] isEqualToString:@"1"]) {
                [uids addObject:_kitm];
            }
        }

        GetProfilesThread *pThread = [[GetProfilesThread alloc] init];
        [pThread setCompletionHandler:^(NSString *str) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                data = jsonDict[@"data"];
                
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
            [self._table reloadData];
        }];
        
        [pThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [pThread start:uids];
        
        NSLog(@"");
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    /*
    if ([external objectForKey:@"follower"]) {
        NSMutableArray *uids = [[NSMutableArray alloc] init];
        NSArray*keys=[[external objectForKey:@"follower"] allKeys];
        
        
        NSDictionary *_itms = [[external objectForKey:@"follower"] objectForKey:item_id];
        for (NSString* _kitm in _itms) {
            NSDictionary *_itm  = [_itms objectForKey:_kitm];
            if ([[_itm objectForKey:@"status"] isEqualToString:@"1"]) {
                [uids addObject:_kitm];
            }
        }
        
        
        GetProfilesThread *pThread = [[GetProfilesThread alloc] init];
        [pThread setCompletionHandler:^(NSString *str) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                data = jsonDict[@"data"];
                
                NSLog(@"");
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
            }
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
            [self._table reloadData];
        }];
        
        [pThread setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        
        [pThread start:uids];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    */
    
}
@end

