//
//  ListFriends.m
//  Heart
//
//  Created by Somkid on 11/28/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AddFriend.h"
#import "AddListFriendsThread.h"
#import "AddFriendThread.h"
#import "InviteFriendForContactsViewController.h"
#import "ScanQRCodeViewController.h"
#import "InviteFriendBySMS.h"
#import "InviteFriendByEmail.h"
#import "ResultSearchFriend.h"
#import "PeopleYouMayKnowThread.h"
#import "AppConstant.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "Configs.h"
#import "AddByIDViewController.h"

#import "ProfilesRepo.h"

@interface AddFriend ()<UIActionSheetDelegate>{
    ProfilesRepo *profilesRepo;
    NSMutableDictionary *profiles;
}

@property(nonatomic,retain) ZXCapture* zxcapture;
@end

@implementation AddFriend{
    NSMutableArray *all_data;
    
    UIActivityIndicatorView *activityIndicator;
}

@synthesize zxcapture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    all_data = [[NSMutableArray alloc] init];
    
    activityIndicator = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    PeopleYouMayKnowThread *peopleThread = [[PeopleYouMayKnowThread alloc] init];
    [peopleThread setCompletionHandler:^(NSString *data) {
        
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            // all_data = jsonDict[@"data"];
            
            NSLog(@"");
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
        }else{
            
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
        
        [self._table reloadData];
    }];
    
    [peopleThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
    }];
    [peopleThread start];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    
    
    profilesRepo = [[ProfilesRepo alloc] init];
    
    NSArray *pf = [profilesRepo get];
    NSData *data =  [[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"");
}

// กรณีเปิด จะมีการ hide Tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
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

     switch (indexPath.row) {
         case 0:
             return 60;
         case 1:
             return 25;
         default:
             return 100;
     }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return [all_data count];
    
    return 2 + [all_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // HeartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartCell" forIndexPath:indexPath];
    // NSString *CellIdentifier = [listItems objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-Add" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            // UIImageView *imgV = (UIImageView *)[cell viewWithTag:10];
            // UILabel *label = (UILabel *)[cell viewWithTag:11];
            
            UIButton *btnInvite = (UIButton *)[cell viewWithTag:10];
            UIButton *btnQRCode = (UIButton *)[cell viewWithTag:11];
            UIButton *btnID = (UIButton *)[cell viewWithTag:12];
            UIButton *btnShare = (UIButton *)[cell viewWithTag:13];
            
            btnInvite.tag = indexPath.row;
            [btnInvite addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnInviteTapped:)]];
            
            btnQRCode.tag = indexPath.row;
            [btnQRCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnQRCodeTapped:)]];

            btnID.tag = indexPath.row;
            [btnID addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnIDTapped:)]];

            btnShare.tag = indexPath.row;
            [btnShare addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnShareTapped:)]];
            

            
            
            //    label.tag = indexPath.row;
            //    label.userInteractionEnabled = YES;
            //    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
            
            // [label setText:[[all_data objectAtIndex:indexPath.row] valueForKey:@"name"]];
            
            // btn.tag = indexPath.row;
            // [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapped:)]];
            
            
            //    NSArray *keys = [all_data allKeys];
            //    id aKey = [keys objectAtIndex:indexPath.row];
            // id anObject = [dict objectForKey:aKey];
            
            // NSLog(@"%@", [[all_data objectForKey:aKey] valueForKey:@"name"]);
            
            // [[all_data objectAtIndex:indexPath.row] valueForKey:@""]
            
            return cell;
        
        }
            break;
            
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell-FR" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            // UIImageView *imgV = (UIImageView *)[cell viewWithTag:10];
            // UILabel *label = (UILabel *)[cell viewWithTag:11];
            
//            UIButton *btnInvite = (UIButton *)[cell viewWithTag:10];
//            UIButton *btnQRCode = (UIButton *)[cell viewWithTag:11];
//            UIButton *btnID = (UIButton *)[cell viewWithTag:12];
//            
//            btnInvite.tag = indexPath.row;
//            [btnInvite addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnInviteTapped:)]];
//            
//            btnQRCode.tag = indexPath.row;
//            [btnQRCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnQRCodeTapped:)]];
//            
//            btnID.tag = indexPath.row;
//            [btnID addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnIDTapped:)]];
            
            
            //    label.tag = indexPath.row;
            //    label.userInteractionEnabled = YES;
            //    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
            
            // [label setText:[[all_data objectAtIndex:indexPath.row] valueForKey:@"name"]];
            
            // btn.tag = indexPath.row;
            // [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapped:)]];
            
            
            //    NSArray *keys = [all_data allKeys];
            //    id aKey = [keys objectAtIndex:indexPath.row];
            // id anObject = [dict objectForKey:aKey];
            
            // NSLog(@"%@", [[all_data objectForKey:aKey] valueForKey:@"name"]);
            
            // [[all_data objectAtIndex:indexPath.row] valueForKey:@""]
            
            return cell;
        
            break;
        }
            
        default:{
        
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            HJManagedImageV *imgV = (HJManagedImageV *)[cell viewWithTag:10];
            UILabel *label = (UILabel *)[cell viewWithTag:11];
            
            UIButton *btn = (UIButton *)[cell viewWithTag:12];
            //    imgV.tag = indexPath.row;
            //    imgV.userInteractionEnabled = YES;
            //    [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
            
            //    label.tag = indexPath.row;
            //    label.userInteractionEnabled = YES;
            //    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
            
            [imgV clear];
            if (![[[all_data objectAtIndex:indexPath.row - 2] valueForKey:@"url_image"] isEqualToString:@""]) {
                [imgV showLoadingWheel];
                [imgV setUrl:[NSURL URLWithString:[[all_data objectAtIndex:indexPath.row - 2] valueForKey:@"url_image"]]];
                // [img setImage:[UIImage imageWithData:fileData]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imgV ];
            }else{
                [imgV setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
            }
            
            [label setText:[[all_data objectAtIndex:indexPath.row - 2 /* เพราะว่าเว้น cell 2 จะนำ 2 มาลบ */ ] valueForKey:@"name"]];
            
            btn.tag = indexPath.row - 2; // เพราะว่าเว้น cell 2 จะนำ 2 มาลบ
            [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAddFriendTapped:)]];
            
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor blueColor].CGColor;
            
            //    NSArray *keys = [all_data allKeys];
            //    id aKey = [keys objectAtIndex:indexPath.row];
            // id anObject = [dict objectForKey:aKey];
            
            // NSLog(@"%@", [[all_data objectForKey:aKey] valueForKey:@"name"]);
            
            // [[all_data objectAtIndex:indexPath.row] valueForKey:@""]
            
            return cell;
        }
            break;
    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    
//    // UIImageView *imgV = (UIImageView *)[cell viewWithTag:10];
//    UILabel *label = (UILabel *)[cell viewWithTag:11];
//    
//    UIButton *btn = (UIButton *)[cell viewWithTag:12];
////    imgV.tag = indexPath.row;
////    imgV.userInteractionEnabled = YES;
////    [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
//    
////    label.tag = indexPath.row;
////    label.userInteractionEnabled = YES;
////    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVTapped:)]];
//    
//    // [label setText:[[all_data objectAtIndex:indexPath.row] valueForKey:@"name"]];
//    
//    btn.tag = indexPath.row;
//    [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapped:)]];
//
//    
////    NSArray *keys = [all_data allKeys];
////    id aKey = [keys objectAtIndex:indexPath.row];
//    // id anObject = [dict objectForKey:aKey];
//    
//    // NSLog(@"%@", [[all_data objectForKey:aKey] valueForKey:@"name"]);
//    
//    // [[all_data objectAtIndex:indexPath.row] valueForKey:@""]
//
//    return cell;
}


// btnInviteTapped, btnQRCodeTapped, btnIDTapped

-(void)btnAddFriendTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    __block NSString* uid_friend = [[all_data objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"uid"];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Add Friend"];
    
    AddFriendThread *afThread = [[AddFriendThread alloc] init];
    [afThread setCompletionHandler:^(NSData *str) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:str  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSMutableArray *tmp = [all_data mutableCopy];
            for(id item in tmp) {
                if ([[item objectForKey:@"uid"] isEqualToString:uid_friend]){
                    [tmp removeObject:item];
                    break;
                }
            }
            
            all_data = tmp;
        
            [self._table reloadData];
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Add Friend Success"];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
    }];
    
    [afThread setErrorHandler:^(NSString *error) {
        
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [afThread start:uid_friend];
}

-(void)btnInviteTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    /*
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InviteFriendForContactsViewController *mtc = [storybrd instantiateViewControllerWithIdentifier:@"InviteFriendForContactsViewController"];
    // [self presentViewController:mtc animated:YES completion:nil];
    
    // [self.navigationController pushViewController:mtc animated:YES];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:mtc];
    
    [self presentViewController:nav animated:YES completion:nil];
     */
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"SMS", @"Email", nil];
    
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
            // SMS
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InviteFriendBySMS *ivSMS = [storybrd instantiateViewControllerWithIdentifier:@"InviteFriendBySMS"];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivSMS];
                
                [self presentViewController:nav animated:YES completion:nil];
           
                break;
            }
            
            // Email
            case 1:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InviteFriendByEmail *ivEmail = [storybrd instantiateViewControllerWithIdentifier:@"InviteFriendByEmail"];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivEmail];
                
                [self presentViewController:nav animated:YES completion:nil];
               
                break;
            }
            default:
                break;
        }
    }
    else if (actionSheet.tag == 200){
        NSLog(@"The Delete confirmation action sheet.");
    }
    else{
        NSLog(@"The Color selection action sheet.");
    }
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)btnQRCodeTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ScanQRCodeViewController *mtc = [storybrd instantiateViewControllerWithIdentifier:@"ScanQRCodeViewController"];
    // [self presentViewController:mtc animated:YES completion:nil];
    
    // [self.navigationController pushViewController:mtc animated:YES];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:mtc];
    
    
    // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
    // get register to fetch notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QRCodeResult:)
                                                 name:@"QRCODE_RESULT" object:nil];

    
    [self presentViewController:nav animated:YES completion:nil];
    
}

// --> Now create method in parent class as;
// Now create yourNotificationHandler: like this in parent class
-(void)QRCodeResult:(NSNotification *)notice{
    NSString *text = [notice object];

    if ([text length] < 1) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"ID Empty."];
    }else{
        
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [text componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            
            [queryStringDictionary setObject:value forKey:key];
        }
        
        if ([queryStringDictionary objectForKey:@"bii"]) {
            // contains object
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            
            if ([text isEqualToString: [[Configs sharedInstance] getUIDU]]) {
                
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"You cannot add yourself as a friend."];
            }else{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ResultSearchFriend *ivFriend = [storybrd instantiateViewControllerWithIdentifier:@"ResultSearchFriend"];
                ivFriend.queryStringDictionary = queryStringDictionary;
                ivFriend.isQR = @"1";
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ivFriend];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(ResultSearchFriend:)
                                                             name:@"ResultSearchFriend" object:nil];
                
                [self presentViewController:nav animated:YES completion:nil];
            }
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"You cannot add friend."];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QRCODE_RESULT" object:nil];
}

-(void)ResultSearchFriend:(NSNotification *)notice{

    NSDictionary *userInfo = notice.userInfo;
    
    if ([userInfo objectForKey:@"uid_friend"]) {
        NSMutableArray *items = [all_data mutableCopy];
        for (id object in items) {
            // do something with object
            if ([[object objectForKey:@"uid"] isEqualToString:[userInfo objectForKey:@"uid_friend"]]) {
                [items  removeObject:object];
                
                all_data = items;
                
                [self reloadData];
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResultSearchFriend" object:nil];
}

-(void)btnIDTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ResultSearchFriend:)
                                                 name:@"ResultSearchFriend" object:nil];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddByIDViewController *v = [storybrd instantiateViewControllerWithIdentifier:@"ByID"];
    [self.navigationController pushViewController:v animated:YES];
}

// btnShareTapped
-(void)btnShareTapped:(UITapGestureRecognizer *)gestureRecognizer{
//    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
//
//    // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
//    NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
//    // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
//    NSArray * applicationActivities = nil;
//    NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
//                                     UIActivityTypeMessage,
//                                     UIActivityTypeMail,
//                                     UIActivityTypePrint,
//                                     UIActivityTypeCopyToPasteboard,
//                                     UIActivityTypeAssignToContact,
//                                     UIActivityTypeSaveToCameraRoll,
//                                     UIActivityTypeAddToReadingList,
//                                     UIActivityTypePostToFlickr,
//                                     UIActivityTypePostToVimeo,
//                                     UIActivityTypePostToTencentWeibo,
//                                     UIActivityTypeAirDrop];
//
//
//
//    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
//
//
//    NSString *text = [NSString stringWithFormat:@"iDNA from %@ get the iDNA app it's cool", [profiles objectForKey:@"name"]];//;
//    NSURL *url = [NSURL URLWithString:@"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1184807478/testflight/external"];
//
//    UIImage *image = [UIImage imageNamed:@"bcc59e573a289.png"];
//
//    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:applicationActivities];
//    activityController.excludedActivityTypes = excludeActivities;
//
//    [self presentViewController:activityController animated:YES completion:nil];
    
    NSString *textToShare = @"iDNA iOS Developers!";
    // @"http://188.166.208.70/profile-main/729"
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/profile-main/%@", [Configs sharedInstance].API_URL, [[Configs sharedInstance] getUIDU] ] ];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)btnTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    /*
    NSLog(@"name = %@", [[all_data objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"uid"]);
    
    [SVProgressHUD showWithStatus:@"Add Friend"];
    
    AddFriendThread *addFriendsThread = [[AddFriendThread alloc] init];
    [addFriendsThread setCompletionHandler:^(NSString *data) {
        
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//
//        all_data = jsonDict[@"data"];
//        
        NSLog(@"%@", all_data);
        
        all_data = [self removeObjectFromArray:all_data withIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag];
        
        NSLog(@"%@", all_data);
        
        [SVProgressHUD dismiss];
        
        [self._table reloadData];
        
        [SVProgressHUD showSuccessWithStatus:@"Add Friend Success"];
    }];
    
    [addFriendsThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
    }];
    [addFriendsThread start:[[all_data objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"uid"]];
    */
}

-(NSArray *) removeObjectFromArray:(NSArray *) array withIndex:(NSInteger) index {
    NSMutableArray *modifyableArray = [[NSMutableArray alloc] initWithArray:array];
    [modifyableArray removeObjectAtIndex:index];
    return [[NSArray alloc] initWithArray:modifyableArray];
}

-(void)reloadData
{
    [self._table reloadData];
}
@end
