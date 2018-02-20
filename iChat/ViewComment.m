//
//  ViewComment.m
//  Heart
//
//  Created by Somkid on 4/14/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ViewComment_Center.h"
#import "ViewCommentCell.h"
#import "AddComment.h"

#import "CenterRepo.h"
#import "Center.h"
#import "Configs.h"

@interface ViewComment_Center (){
    NSDictionary *data;
    UIActivityIndicatorView *activityIndicator;
    
    CenterRepo* centerRepo;
}
@end

@implementation ViewComment_Center
@synthesize app_id, post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [[NSDictionary alloc] init];
    centerRepo = [[CenterRepo alloc] init];
    
    [self._table registerNib:[UINib nibWithNibName:@"ViewCommentCell" bundle:nil] forCellReuseIdentifier:@"ViewCommentCell"];
    
    self._table.estimatedRowHeight = 400.0;
    self._table.rowHeight = UITableViewAutomaticDimension;
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._table setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
    
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
                                                 name:RELOAD_DATA_CENTER
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CENTER object:nil];
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
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;//[data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ViewCommentCell";
    
    ViewCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.text.text = @"ViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCellViewCommentCell";
    
    // cell.btnEdit.enabled    = false;
    // cell.btnDelete.enabled  = false;
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapped:)]];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapped:)]];

    /*
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
    */
    
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

- (IBAction)onAddComment:(id)sender {
    NSLog(@"");
    
    AddComment *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddComment"];
    // v.owner_id = owner_id;
    /*
     NSDictionary *post = [all_data objectForKey:@"post"];
     NSArray *keys = [post allKeys];
     id nid_item = [keys objectAtIndex:[btn tag]];
     
     v.nid  = item_id;
     v.nid_item = nid_item;
     v.data_item =[[all_data objectForKey:@"post"] objectForKey:nid_item];
     */
    
    [self.navigationController pushViewController:v animated:YES];
}

-(void)editTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
}


-(void)deleteTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
}

-(void) reloadData:(NSNotification *) notification{
    
    if (notification == nil) {
        NSMutableArray*_t_myApp =  [centerRepo get:app_id];
        NSData *_t_myApp_data =  [[_t_myApp objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *app_data   = [NSJSONSerialization JSONObjectWithData:_t_myApp_data options:0 error:nil];
        NSDictionary *post_data = [[app_data objectForKey:@"posts"] objectForKey:post_id];
        
        if ([post_data objectForKey:@"comments"]) {
        }
        
        NSLog(@"");
    }

    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    [self._table reloadData];
}
@end
