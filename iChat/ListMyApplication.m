//
//  ListMyApplication.m
//  iDNA
//
//  Created by Somkid on 8/2/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "ListMyApplication.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "MyApplicationsRepo.h"
#import "CreateMyApplication.h"
#import "MyAppProfile.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ListMyApplication (){
    FIRDatabaseReference *ref;
    MyApplicationsRepo* myapplicationRepo;
    NSMutableArray* data_all;

}
@end

@implementation ListMyApplication

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref             = [[FIRDatabase database] reference];
    myapplicationRepo = [[MyApplicationsRepo alloc] init];
    data_all    = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_MY_APPLICATIONS
                                               object:nil];
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_MY_APPLICATIONS object:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        data_all = [myapplicationRepo getMyApplicationAll];
        
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    
    NSString *item_id = [value objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
    NSData *data =  [[value objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName    =(UILabel *)[cell viewWithTag:101];
    UILabel *lblMembers =(UILabel *)[cell viewWithTag:102];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], item_id] ;
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        
    }
    
    //    NSMutableDictionary *local_friends = [[[Configs sharedInstance] loadData:_DATA] valueForKey:@"friends"];
    //
    //    int count = 0;
    //    for (NSString* key in local_friends) {
    //        NSDictionary* value = [local_friends objectForKey:key];
    //        // do stuff
    //
    //        if ([value objectForKey:@"classs"]) {
    //            NSString *classs = [value objectForKey:@"classs"];
    //
    //            if ([classs isEqualToString:item_id]) {
    //                count++;
    //            }
    //        }
    //    }
    //    lblMembers.text =[NSString stringWithFormat:@"%d Users", count];
    
    /*
    int count = 0;
    // NSMutableArray * local_friends = [friendsRepo getFriendsAll];
    // for (NSString* key in local_friends) {
    for (NSString* key in  friends) {
        NSMutableDictionary *ff = [friends objectForKey:key];//[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([ff objectForKey:@"classs"]) {
            NSString *classs = [ff objectForKey:@"classs"];
            
            if ([classs isEqualToString:item_id]) {
                count++;
            }
        }
        NSLog(@"");
    }
    
    lblMembers.text =[NSString stringWithFormat:@"%d Users", count];
    */
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {    
    NSArray *value = [data_all objectAtIndex:indexPath.row];
    NSString *app_id = [value objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyAppProfile *myAppProfile = [storybrd instantiateViewControllerWithIdentifier:@"MyAppProfile"];
        
        myAppProfile.app_id = app_id;
        [self.navigationController pushViewController:myAppProfile animated:YES];
    });
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSArray *value = [data_all objectAtIndex:indexPath.row];
        NSString *app_id = [value objectAtIndex:[myapplicationRepo.dbManager.arrColumnNames indexOfObject:@"app_id"]];
        
        NSString *child = [NSString stringWithFormat:@"%@%@/my_applications/%@", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH],[[Configs sharedInstance] getUIDU], app_id];
        
        [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            if (error == nil) {
                // จะได้ classs id
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* key = [ref key];
                    // ลบ classs
                    BOOL rs= [myapplicationRepo deleteMyApplication:app_id];
                    [self reloadData:nil];
                });
            }
        }];
    }];
    btnDelete.backgroundColor = [UIColor redColor];
    
    return @[btnDelete];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return NO;
            
        default:
            break;
    }
    return YES;
}
@end
