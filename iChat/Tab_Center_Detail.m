//
//  Tab_Center_Detail.m
//  iDNA
//
//  Created by Somkid on 25/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_Center_Detail.h"
#import "MyAppHeaderCell.h"
#import "HJManagedImageV.h"
#import "Tab_Center_AppProfile.h"
#import "Follower.h"
#import "TopAlignedLabel.h"
#import "Configs.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AddPost.h"
#import "MyAppMyPostHeaderCell.h"
#import "MenuMyApp.h"
#import "WYPopoverController.h"
#import "MyAppCell.h"
#import "CustomAlertView.h"
#import "DeletePostThread.h"
#import "ViewPost.h"
#import "GetAppDetailThread.h"
#import "CustomUIActionSheet.h"
#import "ListPeopleLike.h"
#import "ViewComment_Center.h"
#import "AddPostThread.h"
#import "CenterRepo.h"
#import "Center.h"
#import "ChatViewController.h"
#import "FollowingRepo.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Tab_Center_Detail ()<WYPopoverControllerDelegate>{
    WYPopoverController *settingsPopoverController;
    NSMutableDictionary*data;
    NSMutableArray *center;
    UIActivityIndicatorView *activityIndicator;
    CenterRepo* centerRepo;
    
    FollowingRepo *followingRepo;
    
    FIRDatabaseReference *ref;
}
@end

@implementation Tab_Center_Detail
@synthesize app_id;
@synthesize is_following;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    
    centerRepo = [[CenterRepo alloc] init];
    followingRepo = [[FollowingRepo alloc] init];
    
    // Do any additional setup after loading the view.
    [self._table registerNib:[UINib nibWithNibName:@"MyAppCell" bundle:nil] forCellReuseIdentifier:@"MyAppCell"];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=self.view.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    // [self reloadData:nil];
    
    CGFloat bottom =  self.tabBarController.tabBar.frame.size.height;
    NSLog(@"%f",bottom);
    [self._table setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -bottom, 0)];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_CENTER
                                               object:nil];
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CENTER object:nil];
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void):(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            break;
        case 1:{
            if ([data objectForKey:@"posts"]) {
                // contains object
                if ([[data objectForKey:@"posts"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* posts = [data objectForKey:@"posts"];
                    return [posts count];
                }
            }
            return 0;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 120;
        }
            break;
            
        case 1:{
            return 30;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppHeaderCell" owner:self options:nil];
            MyAppHeaderCell *view = [viewArray objectAtIndex:0];
        
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMyAppProfile:)]];
            [view.btnFollower addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFollower:)]];
         
            if ([data objectForKey:@"image_url"]) {
                [view.hjmPhoto clear];
                [view.hjmPhoto showLoadingWheel]; // API_URL
                [view.hjmPhoto setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [data objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:view.hjmPhoto ];
            }else{
                [view.hjmPhoto clear];
            }
            
            [view.labelName setText:[data objectForKey:@"name"]];
            
            if ([self isOwner]) {
                view.btnFollow.hidden = YES;
                view.btnChat.hidden = YES;
                view.btnFollower.hidden = NO;
        
                if([data objectForKey:@"follows"]){
                    NSDictionary *follows =[data objectForKey:@"follows"];
                    
                    int count =0;
                    for (NSString* key in follows) {
                        NSDictionary* value = [follows objectForKey:key];

                        if ([value objectForKey:@"status"]) {
                            if([[value objectForKey:@"status"] isEqualToString:@"1"]){
                                count++;
                            }
                        }
                    }
                    
                    [view.btnFollower setTitle:[NSString stringWithFormat:@"Followers(%d)", count] forState:UIControlStateNormal];
                }
            }else{
                view.btnFollow.hidden   = NO;
                view.btnChat.hidden     = NO;
                view.btnFollower.hidden = YES;
                
                if ([self isFollowing]) {
                     [view.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                }else{
                    [view.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                }
                
                // กดติดตาม my application
                [view.btnFollow addTarget:self action:@selector(onFollow:) forControlEvents:UIControlEventTouchDown];
                [view.btnChat addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChatView:)]];
            }
            
            return view;
        }
            break;
            
        case 1:{
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppMyPostHeaderCell" owner:self options:nil];
            MyAppMyPostHeaderCell *view = [viewArray objectAtIndex:0];
            
            
            /*
             NSString *textMyPost = [NSString stringWithFormat:@"My Post"];
             if ([all_data objectForKey:@"post"]) {
             // contains object
             NSDictionary* post = [all_data objectForKey:@"post"];
             // return [post count];
             
             textMyPost = [NSString stringWithFormat:@"My Post (%d)", [post count]];
             }
             
             view.labelName.text = textMyPost;
             */
            
            return view;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (data == nil) {
        NSLog(@"");
    }
    
    // items_post
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    //    NSMutableDictionary *picture = [anObject valueForKey:@"picture"];
    //    if ([picture count] > 0 ) {
    //        [cell.hjmImage clear];
    //        [cell.hjmImage showLoadingWheel];
    //
    //        NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //        [cell.hjmImage setUrl:[NSURL URLWithString:url]];
    //        // [img setImage:[UIImage imageWithData:fileData]];
    //        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    //    }else{
    //    }
    
    //  NSMutableDictionary *posts = [data objectForKey:@"posts"];
    if ([anObject objectForKey:@"image_url"]) {
        [cell.hjmImage clear];
        [cell.hjmImage showLoadingWheel];
        [cell.hjmImage setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[anObject objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    }else{}
    
    cell.title.text = [NSString stringWithFormat:@"%@-%@", [anObject objectForKey:@"title"], aKey];
    cell.labelMessage.text = [anObject objectForKey:@"message"];
    
    // Buttom Comment
    cell.btnComment.tag   = indexPath.row;
    //
    [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchDown];
    
    if ([anObject objectForKey:@"comments"]) {
        NSDictionary *comments = [anObject objectForKey:@"comments"];
        [cell.btnComment setTitle:[NSString stringWithFormat:@"Comments(%d)", [comments count]] forState:UIControlStateNormal];
    }else{
        [cell.btnComment setTitle:[NSString stringWithFormat:@"Comment"] forState:UIControlStateNormal];
    }
    
    if ([[[Configs sharedInstance] getUIDU] isEqualToString:[data objectForKey:@"owner_id"]]) {
        
        cell.btnEdit.hidden     = NO;
        cell.btnDelete.hidden   = NO;
    
        //    cell.btnEdit
        //    cell.btnDelete
        cell.btnEdit.tag      = indexPath.row;
        [cell.btnEdit addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchDown];
    
        cell.btnDelete.tag      = indexPath.row;
        [cell.btnDelete addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchDown];
    }else{
        cell.btnEdit.hidden = YES;
        cell.btnDelete.hidden = YES;
    }
    
    NSDictionary *like = [self getLike:aKey];
    
    if ([[like objectForKey:@"is_like"] isEqualToString:@"1"]) {
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Unlike(%@)", [like objectForKey:@"count"]] forState:UIControlStateNormal];
    }else{
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Like(%@)", [like objectForKey:@"count"]] forState:UIControlStateNormal];
    }
    
    // getLike
    cell.btnLike.tag = indexPath.row;
    [cell.btnLike addTarget:self action:@selector(onClickLike:) forControlEvents:UIControlEventTouchDown];

    // share post
    cell.btnShare.tag = indexPath.row;
    [cell.btnShare addTarget:self action:@selector(onSharePost:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);
    
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
    
    /*
     ViewPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPost"];
     
     NSDictionary *post = [all_data objectForKey:@"post"];
     NSArray *keys = [post allKeys];
     id nid_item = [keys objectAtIndex:indexPath.row];
     
     v.nid  = item_id;
     v.nid_item = nid_item;
     v.data_item =[[all_data objectForKey:@"post"] objectForKey:nid_item];
     
     [self.navigationController pushViewController:v animated:YES];
     */
}


-(Boolean)isLikes : (NSString *)post_id{
    NSDictionary *post = [[data objectForKey:@"posts"] objectForKey:post_id];
    if ([post objectForKey:@"likes"]) {
        NSDictionary *likes = [post objectForKey:@"likes"];
        
        for (NSString* key in likes) {
            NSDictionary* value = [likes objectForKey:key];
            // do stuff
            
            if ([key isEqualToString:[[Configs sharedInstance] getUIDU]]) {
                if ([[value objectForKey:@"status"] isEqualToString:@"1"]) {
                    return true;
                }
                break;
            }
        }
    }
    return false;
}

-(NSDictionary*)getLike:(NSString *)post_id{
    
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    if ([data objectForKey:@"posts"]) {
        NSDictionary* posts = [data objectForKey:@"posts"];
        
        if ([posts objectForKey:post_id]) {
            NSDictionary *post = [posts objectForKey:post_id];
            if ([post objectForKey:@"likes"]) {
                NSDictionary *likes = [post objectForKey:@"likes"];
                
                int count = 0;
                
                for (NSString* key in likes) {
                    NSDictionary* l = [likes objectForKey:key];
                    if ([[l objectForKey:@"status"] isEqualToString:@"1"] ) {
                        count++;
                    }
                }
                
                for (NSString* key in likes) {
                    NSDictionary* l = [likes objectForKey:key];
                    /*
                    if ([[l objectForKey:@"uid"] isEqualToString:[[Configs sharedInstance] getUIDU]]) {
                        [values setValue:[NSString stringWithFormat:@"%d", [likes count]] forKey:@"count"];
                        [values setValue:@"1" forKey:@"is_like"];
                        [values setValue:key forKey:@"object_id"];
                        
                        return values;
                        break;
                    }
                    */
                    if ([[l objectForKey:@"uid"] isEqualToString:[[Configs sharedInstance] getUIDU]] && [[l objectForKey:@"status"] isEqualToString:@"1"] ) {
                        [values setValue:@"1" forKey:@"is_like"];
                        [values setValue:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
                        return values;
                    }
                }
                
                [values setValue:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
                [values setValue:@"0" forKey:@"is_like"];
                return values;
            }
        }
    }
    [values setValue:@"0" forKey:@"count"];
    [values setValue:@"0" forKey:@"is_like"];
    return values;
}

-(Boolean)isFollowing{
    if ([data objectForKey:@"follows"]) {
        NSDictionary *follows = [data objectForKey:@"follows"];
        for (NSString* key in follows) {
            NSDictionary* value = [follows objectForKey:key];
            if ([[value objectForKey:@"uid"] isEqualToString:[[Configs sharedInstance] getUIDU]] && [[value objectForKey:@"status"] isEqualToString:@"1"]){
                return true;
                break;
            }
        }
    }
    return false;
}

-(void)showMenu:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"%i", btn.tag);
    
    NSMutableDictionary *tposts = [data objectForKey:@"posts"];
    NSArray *keys = [tposts allKeys];
    
    // จะได้ id post
    NSString *post_id = [keys objectAtIndex:[btn tag]];
    
    
    CustomUIActionSheet *actionSheet = [[CustomUIActionSheet alloc] initWithTitle:@"Post"
                                                                         delegate:self
                                                                cancelButtonTitle:@"Cancel"
                                                           destructiveButtonTitle:@"Delete"
                                                                otherButtonTitles:@"Edit", nil];
    
    actionSheet.tag = 501;
    actionSheet.object = @{@"post_id":post_id};
    
    [actionSheet showInView:self.view];
}

-(void)onClickLike:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id post_id = [keys objectAtIndex:[btn tag]];
    id anObject = [[data objectForKey:@"posts"] objectForKey:post_id];

    NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/likes/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [data objectForKey:@"category"], app_id, post_id];
    
    [[[[ref child:child] queryOrderedByChild:@"uid"] queryEqualToValue:[[Configs sharedInstance] getUIDU]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // NSLog(@"%@-%@", snapshot.key, snapshot.value);
        if (snapshot.value != [NSNull null]){
            for(FIRDataSnapshot* snap in snapshot.children){
                if ([snap.value isKindOfClass:[NSDictionary class]]) {
                    // NSLog(@"%@, %@", snap.key,snap.value);
                    // https://firebase.google.com/docs/database/ios/read-and-write#save_data_as_transactions
                    [[[ref child: child] child:snap.key] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                        NSMutableDictionary *like = currentData.value;
                        if (!like || [like isEqual:[NSNull null]]) {
                            return [FIRTransactionResult successWithValue:currentData];
                        }
                        
                        NSMutableDictionary* newLike = [[NSMutableDictionary alloc] init];
                        [newLike addEntriesFromDictionary:like];
                        if ([newLike objectForKey:@"status"]) {
                            if ([[newLike objectForKey:@"status"] isEqualToString:@"0"]) {
                                [newLike removeObjectForKey:@"status"];
                                [newLike setValue:@"1" forKey:@"status"];
                            }else{
                                [newLike removeObjectForKey:@"status"];
                                [newLike setValue:@"0" forKey:@"status"];
                            }
                        }
                        
                        // Update local database
                        if ([data objectForKey:@"posts"]) {
                            NSMutableDictionary *posts = [data objectForKey:@"posts"];
                            
                            if ([posts objectForKey:post_id]) {
                                NSMutableDictionary* post = [posts objectForKey:post_id];
                                if ([post objectForKey:@"likes"]) {
                                    NSDictionary *likes = [post objectForKey:@"likes"];
                                    if ([likes objectForKey:snap.key]) {
                                        
                                        NSMutableDictionary*newLikes = [[NSMutableDictionary alloc] init];
                                        [newLikes addEntriesFromDictionary:likes];
                                        
                                        [newLikes removeObjectForKey:snap.key];
                                        [newLikes setValue:newLike forKey:snap.key];
                                        
                                        NSMutableDictionary*newPost = [[NSMutableDictionary alloc] init];
                                        [newPost addEntriesFromDictionary:post];
                                        [newPost setValue:newLikes forKey:@"likes"];
                                        
                                        NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
                                        [newPosts addEntriesFromDictionary:posts];
                                        if ([newPosts objectForKey:post_id]) {
                                            [newPosts removeObjectForKey:post_id];
                                        }
                                        [newPosts setValue:newPost forKey:post_id];
                                        
                                        NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                                        [newData addEntriesFromDictionary:data];
                                        if ([newData objectForKey:@"posts"]) {
                                            [newData removeObjectForKey:@"posts"];
                                        }
                                        [newData setValue:newPosts forKey:@"posts"];
                                        
                                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
                                    }
                                }
                            }
                        }
                        // Update local database
                        
                        
                        // Update firebase
                        currentData.value = newLike;
                        return [FIRTransactionResult successWithValue:currentData];
                    } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                        // Transaction completed
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            }
        }else{
            // Update firebase
            NSString* object_id = [ref childByAutoId].key;
            NSDictionary *value = @{@"uid": [[Configs sharedInstance] getUIDU], @"status": @"1"};
            [[ref child:[NSString stringWithFormat:@"%@%@", child, object_id]] setValue:value];
            // Update firebase
            
            // Update local database
            if ([data objectForKey:@"posts"]) {
                NSMutableDictionary *posts = [data objectForKey:@"posts"];
                
                if ([posts objectForKey:post_id]) {
                    NSMutableDictionary* post = [posts objectForKey:post_id];
                    if ([post objectForKey:@"likes"]) {
                        NSDictionary *likes = [post objectForKey:@"likes"];
                        if ([likes objectForKey:object_id]) {
                            // แสดงว่ามีแล้ว อาจ การ response จาก firebase update function AppDelegate แล้ว
                            
                        }else{
                            NSMutableDictionary*newLikes = [[NSMutableDictionary alloc] init];
                            [newLikes addEntriesFromDictionary:likes];
                            [newLikes setValue:value forKey:object_id];
                            
                            
                            NSMutableDictionary*newPost = [[NSMutableDictionary alloc] init];
                            [newPost addEntriesFromDictionary:post];
                            [newPost setValue:newLikes forKey:@"likes"];
                            
                            NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
                            [newPosts addEntriesFromDictionary:posts];
                            if ([newPosts objectForKey:post_id]) {
                                [newPosts removeObjectForKey:post_id];
                            }
                            [newPosts setValue:newPost forKey:post_id];
                            
                            NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                            [newData addEntriesFromDictionary:data];
                            if ([newData objectForKey:@"posts"]) {
                                [newData removeObjectForKey:@"posts"];
                            }
                            [newData setValue:newPosts forKey:@"posts"];
                            
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
                        }
                    }else{
                        NSMutableDictionary*newLikes = [[NSMutableDictionary alloc] init];
                        // [newLikes addEntriesFromDictionary:likes];
                        [newLikes setValue:value forKey:object_id];
                        
                        
                        NSMutableDictionary*newPost = [[NSMutableDictionary alloc] init];
                        [newPost addEntriesFromDictionary:post];
                        [newPost setValue:newLikes forKey:@"likes"];
                        
                        NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
                        [newPosts addEntriesFromDictionary:posts];
                        if ([newPosts objectForKey:post_id]) {
                            [newPosts removeObjectForKey:post_id];
                        }
                        [newPosts setValue:newPost forKey:post_id];
                        
                        NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                        [newData addEntriesFromDictionary:data];
                        if ([newData objectForKey:@"posts"]) {
                            [newData removeObjectForKey:@"posts"];
                        }
                        [newData setValue:newPosts forKey:@"posts"];
                        
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
                    }
                }
            }
            // Update local database
        }
    }];
}

-(void)actionSheet:(CustomUIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*
     if (actionSheet.tag == 500) {
     
     NSDictionary *item = actionSheet.object;
     UIButton *sender = [item objectForKey:@"sender"];
     // จะได้ id post
     NSString *post_id = [item objectForKey:@"post_id"];
     
     // [sender setTitle:[NSString stringWithFormat:@"Like (%d)", 100] forState:UIControlStateNormal];
     switch (buttonIndex) {
     case 0:{
     NSMutableDictionary *tposts = [data objectForKey:@"posts"];
     
     NSArray *keys = [tposts allKeys];
     
     // NSMutableDictionary*_item = [tposts objectForKey:[keys objectAtIndex:[btn tag]]];
     
     
     // จะเก็บว่าเราไป liking อะไรไว้บ้าง
     __block NSString *child = [NSString stringWithFormat:@"heart-id/external/%@/data/like/", [[Configs sharedInstance] getUIDU]];
     [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
     
     FIRDatabaseReference *childRef = [ref child:child];
     [childObservers addObject:childRef];
     
     NSMutableDictionary *val = [[NSMutableDictionary alloc] init];
     // [val setObject:owner_id forKey:@"owner_id"];
     // [val setObject:post_id forKey:@"post_id"];
     
     BOOL flag = TRUE;
     for(FIRDataSnapshot* snap in snapshot.children){
     flag = FALSE;
     
     NSMutableDictionary *like = snapshot.value;
     if ([like objectForKey:post_id]) {
     NSDictionary* key = [like objectForKey:post_id];
     
     if ([[key objectForKey:@"isLike"] isEqualToString:@"0"]) {
     
     [val setObject:@"1" forKey:@"isLike"];
     
     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
     [ref updateChildValues:childUpdates];
     
     [self ownerPost:post_id :val];
     }else{
     
     [val setObject:@"0" forKey:@"isLike"];
     
     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
     [ref updateChildValues:childUpdates];
     
     [self ownerPost:post_id :val];
     }
     }else{
     
     [val setObject:@"1" forKey:@"isLike"];
     
     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
     [ref updateChildValues:childUpdates];
     
     [self ownerPost:post_id :val];
     }
     }
     
     //  กรณียังไม่มี child like
     if (flag) {
     
     [val setObject:@"1" forKey:@"isLike"];
     
     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, post_id]: val};
     [ref updateChildValues:childUpdates];
     
     [self ownerPost:post_id :val];
     }
     }];
     
     isRefresh = FALSE;
     
     int clike = 0;
     if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id]){
     NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
     if ([plike objectForKey:@"like"]) {
     NSDictionary* like = [plike objectForKey:@"like"];
     
     NSLog(@"");
     for (NSString* key in like) {
     id value = [like objectForKey:key];
     // do stuff
     
     if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
     clike++;
     }
     }
     }
     }
     
     NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
     if ([plike objectForKey:@"like"]) {
     NSDictionary* like = [[plike objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]];
     
     if ([[like objectForKey:@"isLike"] isEqualToString:@"1"]) {
     [sender setTitle:[NSString stringWithFormat:@"Unlike (%d)", clike] forState:UIControlStateNormal];
     }else{
     [sender setTitle:[NSString stringWithFormat:@"Like (%d)", clike] forState:UIControlStateNormal];
     }
     }
     }
     break;
     case 1:{
     // List people like
     int clike = 0;
     if([[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id]){
     NSDictionary *plike = [[[center objectAtIndex:[category integerValue]] objectForKey:item_id] objectForKey:post_id];
     if ([plike objectForKey:@"like"]) {
     NSDictionary* like = [plike objectForKey:@"like"];
     
     NSLog(@"");
     for (NSString* key in like) {
     id value = [like objectForKey:key];
     // do stuff
     
     if ([[value objectForKey:@"isLike"] isEqualToString:@"1"]) {
     clike++;
     }
     }
     }
     }
     
     if (clike > 0) {
     UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     ListPeopleLike *v = [storybrd instantiateViewControllerWithIdentifier:@"ListPeopleLike"];
     
     v.application_id = item_id;
     v.post_id        = post_id;
     v.category       = category;
     
     [self.navigationController pushViewController:v animated:YES];
     }
     }
     break;
     
     default:
     break;
     }
     }else if(actionSheet.tag == 501){
     NSDictionary *item = actionSheet.object;
     // จะได้ post id
     NSString *post_id = [item objectForKey:@"post_id"];
     
     switch (buttonIndex) {
     case 0:{
     // Delete
     //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete Post?" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
     //                [alert show];
     
     CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Confirm Delete Post?" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
     
         alertView.tag = -999;
     alertView.object = post_id;
     [alertView show];
     }
     break;
     case 1:{
     // Edit
     AddPost *v  = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
     v.is_add    = @"0";
     v.item_id   = item_id;
     v.post_nid  = post_id;
     v.edit_data = [[data objectForKey:@"posts"] objectForKey:post_id];
     
     [self.navigationController pushViewController:v animated:YES];
     }
     break;
     default:
     break;
     }
     }
     */
}

-(void)ownerPost:(NSString* )post_id :(NSDictionary *)val{
    //    NSString *ochild = [NSString stringWithFormat:@"heart-id/center/data/%@/%@/%@/like/", category, item_id, post_id];
    //    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", ochild, [[Configs sharedInstance] getUIDU]]: val};
    //    [ref updateChildValues:childUpdates];
}

-(void)onComment:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"onComment > %d", [btn tag]);
    
    /*
     ViewPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPost"];
     
     NSDictionary *post = [all_data objectForKey:@"post"];
     NSArray *keys = [post allKeys];
     id aKey = [keys objectAtIndex:[btn tag]];
     
     // v.item_data =[[all_data objectForKey:@"post"] objectForKey:aKey];
     
     [self.navigationController pushViewController:v animated:YES];
     */
    
    
    ViewComment_Center *v = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewComment_Center"];
    // v.owner_id = owner_id;
    /*
     NSDictionary *post = [all_data objectForKey:@"post"];
     NSArray *keys = [post allKeys];
     id nid_item = [keys objectAtIndex:[btn tag]];
     
     v.nid  = item_id;
     v.nid_item = nid_item;
     v.data_item =[[all_data objectForKey:@"post"] objectForKey:nid_item];
     */
    
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id aKey = [keys objectAtIndex:[btn tag]];
    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    v.app_id    = app_id;
    v.post_id   = aKey;
    
    [self.navigationController pushViewController:v animated:YES];
    
}

-(void)onEdit:(id)sender{
    UIButton *btn = (UIButton *)sender;
    // NSLog(@"onEdit > %d", [btn tag]);
    
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id aKey = [keys objectAtIndex:[btn tag]];
    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];

    v.is_edit = @"1";
    v.app_id = app_id;
    v.post_id = aKey;
    [self.navigationController pushViewController:v animated:YES];
    
//    UINavigationController* iDNANavController = [[UINavigationController alloc] initWithRootViewController:v];
//    [self presentViewController:iDNANavController animated:YES completion:nil];
}

-(void)onDelete:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"onDelete > %d", [btn tag]);
    
    //    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    //    id aKey = [keys objectAtIndex:[btn tag]];
    //    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
        alertView.tag = -999;
    alertView.object = [NSString stringWithFormat:@"%d", [btn tag]] ;
    [alertView show];
}

-(void)onSharePost:(id)sender{

    UIButton *btn = (UIButton *)sender;
    
    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    id post_id = [keys objectAtIndex:[btn tag]];
    id anObject = [[data objectForKey:@"posts"] objectForKey:post_id];
    
    // /field-collection/field-my-app-update/1105490
    
    
    NSString *textToShare = @"iDNA Share Post";
    // @"http://188.166.208.70/profile-main/729"
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-app-update/%@", [Configs sharedInstance].API_URL, post_id]];
    
    // NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/node/%@", [Configs sharedInstance].API_URL, app_id]];
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });
    
    /*
    UIButton *btn = (UIButton *)sender;
    
    NSMutableDictionary *tposts = [data objectForKey:@"posts"];
    NSArray *keys = [tposts allKeys];
    
    // จะได้ id post
    NSString *post_id = [keys objectAtIndex:[btn tag]];
    
    // UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    NSArray * activityItems = @[@"somkid test http://klovers.org", [NSURL URLWithString:@"http://klovers.org"], [UIImage imageNamed:@"bcc59e573a289.png"]];
    // NSArray * activityItems = @[[NSString stringWithFormat:@"MY ID : Mr.Somkid Simajarn"], [NSURL URLWithString:@"http://128.199.247.179/sites/default/files/bcc59e573a289.png"]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities =  @[UIActivityTypePostToWeibo,
                                     UIActivityTypeMessage,
                                     UIActivityTypeMail,
                                     UIActivityTypePrint,
                                     UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeAssignToContact,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypeAddToReadingList,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePostToVimeo,
                                     UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop];
    
    NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-app-update/%@", [Configs sharedInstance].API_URL, post_id]];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
     */
}

-(void)MenuMyApp:(NSNotification *)notification{
    
    /*
     NSDictionary* userInfo = notification.userInfo;
     NSString *row   = (NSString*)userInfo[@"row"];
     NSString *index = (NSString*)userInfo[@"index"];
     
     [settingsPopoverController dismissPopoverAnimated:YES completion:^{
     [self popoverControllerDidDismissPopover:settingsPopoverController];
     }];
     
     switch ([index integerValue]) {
     case 0:{
     //Edit
     AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
     
     v.is_add = @"0";
     // v.key = key;
     v.item_id = item_id;
     
     
     }
     break;
     
     case 1:{
     //Delete
     CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
     
         alertView.tag = -999;
     alertView.object = userInfo;
     [alertView show];
     
     }
     break;
     default:
     break;
     }
     
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MenuMyApp" object:nil];
     */
}

-(void)AddPost:(NSNotification *)notification{
    /*
     NSMutableDictionary* userInfo = notification.userInfo;
     
     id post_id = [[userInfo allKeys] objectAtIndex:0];
     
     NSMutableDictionary *_tmp_data = [[[Configs sharedInstance] loadData:_DATA] mutableCopy];
     
     NSMutableDictionary *_tmp_my_application = [[_tmp_data objectForKey:@"my_applications"] mutableCopy];
     
     if ([[_tmp_my_application objectForKey:item_id] objectForKey:@"posts"]) {
     NSMutableDictionary *titem_id = [[_tmp_my_application objectForKey:item_id] mutableCopy];
     NSMutableDictionary *tposts   = [[[_tmp_my_application objectForKey:item_id] objectForKey:@"posts"] mutableCopy];
     
     if(![tposts objectForKey:post_id]){
     [tposts setObject:[userInfo objectForKey:post_id] forKey:post_id];
     
     NSMutableDictionary *new_item_id = [[NSMutableDictionary alloc] init];
     [new_item_id addEntriesFromDictionary:titem_id];
     [new_item_id removeObjectForKey:@"posts"];
     [new_item_id setObject:tposts forKey:@"posts"];
     
     NSMutableDictionary *new_my_application = [[NSMutableDictionary alloc] init];
     [new_my_application addEntriesFromDictionary:_tmp_my_application];
     [new_my_application removeObjectForKey:item_id];
     [new_my_application setObject:new_item_id forKey:item_id];
     
     NSMutableDictionary *new_data = [[NSMutableDictionary alloc] init];
     [new_data addEntriesFromDictionary:_tmp_data];
     [new_data removeObjectForKey:@"my_applications"];
     [new_data setObject:new_my_application forKey:@"my_applications"];
     
     [[Configs sharedInstance] saveData:_DATA :new_data];
     }
     }else{
     NSMutableDictionary *titem_id = [[_tmp_my_application objectForKey:item_id] mutableCopy];
     
     NSMutableDictionary *tposts   = [[NSMutableDictionary alloc] init];
     
     [tposts setObject:[userInfo objectForKey:post_id] forKey:post_id];
     NSMutableDictionary *new_item_id = [[NSMutableDictionary alloc] init];
     [new_item_id addEntriesFromDictionary:titem_id];
     [new_item_id removeObjectForKey:@"posts"];
     [new_item_id setObject:tposts forKey:@"posts"];
     
     NSMutableDictionary *new_my_application = [[NSMutableDictionary alloc] init];
     [new_my_application addEntriesFromDictionary:_tmp_my_application];
     [new_my_application removeObjectForKey:item_id];
     [new_my_application setObject:new_item_id forKey:item_id];
     
     NSMutableDictionary *new_data = [[NSMutableDictionary alloc] init];
     [new_data addEntriesFromDictionary:_tmp_data];
     [new_data removeObjectForKey:@"my_applications"];
     [new_data setObject:new_my_application forKey:@"my_applications"];
     
     [[Configs sharedInstance] saveData:_DATA :new_data];
     }
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddPost" object:nil];
     [self reloadData:nil];
     */
}

-(void)onMyAppProfile:(UITapGestureRecognizer *)gestureRecognizer{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tab_Center_AppProfile *tab_Center_AppProfile = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Center_AppProfile"];
    tab_Center_AppProfile.app_id = app_id;
    [self.navigationController pushViewController:tab_Center_AppProfile animated:YES];
}

-(void)deleteMyApplication:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onFollower:(UITapGestureRecognizer *)gestureRecognizer{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Follower *v = [storybrd instantiateViewControllerWithIdentifier:@"Follower"];
    v.app_id = app_id;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)onFollow:(id)sender{
    NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/follows/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [data objectForKey:@"category"], app_id];
    
    [[[[ref child:child] queryOrderedByChild:@"uid"] queryEqualToValue:[[Configs sharedInstance] getUIDU]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // NSLog(@"%@-%@", snapshot.key, snapshot.value);
        if (snapshot.value != [NSNull null]){
            
            for(FIRDataSnapshot* snap in snapshot.children){
                if ([snap.value isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"%@, %@", snap.key,snap.value);
                    // https://firebase.google.com/docs/database/ios/read-and-write#save_data_as_transactions
                    [[[ref child: child] child:snap.key] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                        NSMutableDictionary *follow = currentData.value;
                        if (!follow || [follow isEqual:[NSNull null]]) {
                            return [FIRTransactionResult successWithValue:currentData];
                        }
                        
                        NSMutableDictionary* newFollow = [[NSMutableDictionary alloc] init];
                        [newFollow addEntriesFromDictionary:follow];
                        if ([newFollow objectForKey:@"status"]) {
                            if ([[newFollow objectForKey:@"status"] isEqualToString:@"0"]) {
                                [newFollow removeObjectForKey:@"status"];
                                [newFollow setValue:@"1" forKey:@"status"];
                            }else{
                                [newFollow removeObjectForKey:@"status"];
                                [newFollow setValue:@"0" forKey:@"status"];
                            }
                        }
                        
                        // update local database
                        if ([data objectForKey:@"follows"]) {
                            NSMutableDictionary *follows = [data objectForKey:@"follows"];
                            
                            NSMutableDictionary *newFollows = [[NSMutableDictionary alloc] init];
                            [newFollows addEntriesFromDictionary:follows];
                            if ([newFollows objectForKey:snap.key]) {
                                [newFollows removeObjectForKey:snap.key];
                            }
                            [newFollows setObject:newFollow forKey:snap.key];
                            
                            NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                            [newData addEntriesFromDictionary:data];
                            if ([newData objectForKey:@"follows"]) {
                                [newData removeObjectForKey:@"follows"];
                            }
                            [newData setValue:newFollows forKey:@"follows"];
                            
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
                        }
                        // update local database
                        
                        // update following database
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFollowing:app_id :newFollow];
                        // update following database
                        
                        // update firebase
                        currentData.value = newFollow;
                        return [FIRTransactionResult successWithValue:currentData];
                        // update firebase
                    } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                        // Transaction completed
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            }
        }else{
            // insert firebase
            NSString* object_id = [ref childByAutoId].key;
            NSDictionary *value = @{@"uid": [[Configs sharedInstance] getUIDU], @"status": @"1"};
            [[ref child:[NSString stringWithFormat:@"%@%@", child, object_id]] setValue:value];
            // insert firebase
            
            // update local database
            if ([data objectForKey:@"follows"]) {
                NSMutableDictionary *follows = [data objectForKey:@"follows"];
                
                NSMutableDictionary *newFollows = [[NSMutableDictionary alloc] init];
                [newFollows addEntriesFromDictionary:follows];
                if ([newFollows objectForKey:object_id]) {
                    [newFollows removeObjectForKey:object_id];
                }
                
                [newFollows setValue:value forKey:object_id];
                
                NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                [newData addEntriesFromDictionary:data];
                if ([newData objectForKey:@"follows"]) {
                    [newData removeObjectForKey:@"follows"];
                }
                [newData setValue:newFollows forKey:@"follows"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
            }else{
                NSMutableDictionary *follows = [[NSMutableDictionary alloc] init];
                
                [follows setValue:value forKey:object_id];
                
                NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                [newData addEntriesFromDictionary:data];
                if ([newData objectForKey:@"follows"]) {
                    [newData removeObjectForKey:@"follows"];
                }
                [newData setValue:follows forKey:@"follows"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
            }
            // update local database
            
            
            // update following database
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFollowing:app_id :value];
            // update following database
        }
    }];
}

-(void)f_setFollower:(NSString *) status
{
    
    // จะไป update ให้เจ้าของ application ด้วย ว่า  ไครเป็น คน follower application
    
    // *owner_id, *item_id;
    
    /*
     __block NSString *fchild = [NSString stringWithFormat:@"heart-id/external/%@/data/follower/%@/", owner_id, item_id];
     
     [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
     
     FIRDatabaseReference *childRef = [ref child:fchild];
     [childObservers addObject:childRef];
     
     
     
     NSMutableDictionary *fuser = [[NSMutableDictionary alloc] init];
     // [fuser setObject:fname forKey:@"fname"];
     // [fuser setObject:picture forKey:@"fpicture"];
     [fuser setObject:status forKey:@"status"];
     
     
     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", fchild, [[Configs sharedInstance] getUIDU]]: fuser};
     [ref updateChildValues:childUpdates];
     
     }];
     */
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                NSArray *keys = [[data objectForKey:@"posts"] allKeys];
                id aKey = [keys objectAtIndex:[alertView.object integerValue]];
                id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
                
                NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [data objectForKey:@"category"], app_id, aKey];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error == nil) {
                        // Update local database
                        if ([data objectForKey:@"posts"]) {
                            NSMutableDictionary *posts = [data objectForKey:@"posts"];
                            
                            if ([posts objectForKey:aKey]) {
                                
                                NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
                                [newPosts addEntriesFromDictionary:posts];
                                if ([newPosts objectForKey:aKey]) {
                                    [newPosts removeObjectForKey:aKey];
                                    
                                    NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                                    [newData addEntriesFromDictionary:data];
                                    if ([newData objectForKey:@"posts"]) {
                                        [newData removeObjectForKey:@"posts"];
                                    }
                                    [newData setValue:newPosts forKey:@"posts"];
                                    
                                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
                                }
                            }
                        }
                        // Update local database
                    }
                }];
            }
            break;
            
        case 1:{
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else if (buttonIndex == 1){
                // @"Add post"
                [self onAddPost];
            }else if (buttonIndex == 2){
                // @"Share"
                [self onShareApplication];
            }
        }
            break;
            
        case 2:{
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else if (buttonIndex == 1){
                // @"Share"
                [self onShareApplication];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - WYPopoverControllerDelegate
- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

#pragma mark - UIViewControllerRotation

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        /*
         CGRect frame = self.bottomRightButton.frame;
         frame.origin.y = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? self.bottomLeftButton.frame.origin.y : frame.origin.y - frame.size.height * 1.25f);
         self.bottomRightButton.frame = frame;
         */
    }];
}

-(void)onAddPost{
    AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
    v.is_edit = @"0";
    v.app_id = app_id;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:v animated:YES];
    });
}

-(IBAction)onCloseApplication:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onShareApplication{
    
    NSString *textToShare = @"iDNA Share My Application";
    // @"http://188.166.208.70/profile-main/729"
    // NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-application/%@", [Configs sharedInstance].API_URL, app_id]];
    
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/node/%@", [Configs sharedInstance].API_URL, app_id]];
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });
}

-(void)onChatView:(UITapGestureRecognizer *)gestureRecognizer{
    //  [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"ChatView."];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatViewController *cV = [storybrd instantiateViewControllerWithIdentifier:@"ChatViewController"];
        cV.type      = @"center";
        // cV.friend_id = [sortedKeys objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:cV animated:YES];
    });
}

-(BOOL)isOwner{
    if (data == nil) {
        return  false;
    }
    if ([[[Configs sharedInstance] getUIDU] isEqualToString:[data objectForKey:@"owner_id"]]) {
        return true;
    }
    
    return false;
}

- (void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *center_data =  [[[centerRepo get:app_id] objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization JSONObjectWithData:center_data options:0 error:nil];

        /*
        if ([self isOwner]) {
            UIBarButtonItem *addPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddPost:)];
            
            UIBarButtonItem *shareApplicationButton = [[UIBarButtonItem alloc]
                                                       initWithTitle:@"Share"
                                                       style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(onShareApplication:)];
            
            self.navigationItem.rightBarButtonItems = @[addPostButton, shareApplicationButton];
        }else{
            UIBarButtonItem *shareApplicationButton = [[UIBarButtonItem alloc]
                                                       initWithTitle:@"Share"
                                                       style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(onShareApplication:)];

            self.navigationItem.rightBarButtonItems = @[shareApplicationButton];
        }
         */
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [self._table reloadData];
    });
    
    [self setTitle:app_id];
}

- (IBAction)onSettings:(id)sender {
    if ([self isOwner]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:nil
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles:@"Add post", @"Share", nil];
        alertView.tag = 1;
        [alertView show];
    }else{
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:nil
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles:@"Share", nil];
        alertView.tag = 2;
        [alertView show];
    }
}
@end


