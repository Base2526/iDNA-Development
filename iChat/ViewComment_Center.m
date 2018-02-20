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
#import "MyAppMyPostHeaderCell.h"
#import "ViewCommentHeaderCell.h"
#import "CustomAlertView.h"
#import "Comment.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ViewComment_Center (){
    NSDictionary *data;
    UIActivityIndicatorView *activityIndicator;
    
    CenterRepo* centerRepo;
    
    NSDictionary *posts;
    NSMutableDictionary *post;
    
    FIRDatabaseReference *ref;
}
@end

@implementation ViewComment_Center
@synthesize app_id, post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    data        = [[NSDictionary alloc] init];
    centerRepo  = [[CenterRepo alloc] init];
    
    posts       = [[NSDictionary alloc] init];
    post        = [[NSMutableDictionary alloc] init];
    
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
    
    [self reloadData:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_CENTER object:nil];
}

- (void)viewDidLayoutSubviews {
    activityIndicator.center = self.view.center;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Comment"])
    {
        // Get reference to the destination view controller
        Comment *vc = [segue destinationViewController];
        
        vc.app_id   = app_id;
        vc.post_id  = post_id;
        vc.is_edit  = @"0";
        // Pass any objects to the view controller here, like...
        // [vc setMyObjectHere:object];
    }
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
        case 1:
            if ([post objectForKey:@"comments"]) {
                NSDictionary *comments = [post objectForKey:@"comments"];
                return [comments count];
            }
            return 0;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 140;
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
        case 0:{
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"ViewCommentHeaderCell" owner:self options:nil];
            ViewCommentHeaderCell *view = [viewArray objectAtIndex:0];
            
            if ([post objectForKey:@"image_url"]) {
                [view.imageV clear];
                [view.imageV showLoadingWheel]; // API_URL
                [view.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [post objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:view.imageV ];
            }else{
                [view.imageV clear];
            }
            
            view.labelName.text = [post objectForKey:@"title"];
            view.textViewDetail.text = [post objectForKey:@"message"];
            
            return view;
        }
        case 1:{
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppMyPostHeaderCell" owner:self options:nil];
            MyAppMyPostHeaderCell *view = [viewArray objectAtIndex:0];
            view.labelName.text = @"Comment";
            return view;
        }
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ViewCommentCell";
    
    ViewCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *comments = [post objectForKey:@"comments"];
    
    NSArray *keys = [comments allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [comments objectForKey:aKey];

    
    cell.text.text = [anObject objectForKey:@"message"];
    
    // cell.btnEdit.enabled    = false;
    // cell.btnDelete.enabled  = false;
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapped:)]];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapped:)]];

    cell.btnLike.tag = indexPath.row;
    [cell.btnLike addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped:)]];
    
    NSDictionary *like = [self getLike:aKey];
    
    if ([[like objectForKey:@"is_like"] isEqualToString:@"1"]) {
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Unlike(%@)", [like objectForKey:@"count"]] forState:UIControlStateNormal];
    }else{
        [cell.btnLike setTitle:[NSString stringWithFormat:@"Like(%@)", [like objectForKey:@"count"]] forState:UIControlStateNormal];
    }
    
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

-(NSDictionary*)getLike:(NSString *)comment_id{
    
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    
    if ([post objectForKey:@"comments"]) {
        NSDictionary *comments = [post objectForKey:@"comments"];
        if ([comments objectForKey:comment_id]) {
            NSDictionary *comment = [comments objectForKey:comment_id];
            
            if ([comment objectForKey:@"likes"]) {
                NSDictionary *likes = [comment objectForKey:@"likes"];
                
                int count = 0;
                
                for (NSString* key in likes) {
                    NSDictionary* l = [likes objectForKey:key];
                    if ([[l objectForKey:@"status"] isEqualToString:@"1"] ) {
                        count++;
                    }
                }
                
                for (NSString* key in likes) {
                    NSDictionary* l = [likes objectForKey:key];
                    
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
    
    /* post
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
    */
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

-(void)likeTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@"likeTapped >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSDictionary *comments = [post objectForKey:@"comments"];
    NSArray *keys = [comments allKeys];
    NSString* comment_id = [keys objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag];
    
    NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/comments/%@/likes/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [posts objectForKey:@"category"], app_id, post_id, comment_id];
    
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
                        /*
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
                        */
                        
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
            // insert new data to firebase
            NSString* object_id = [ref childByAutoId].key;
            NSDictionary *value = @{@"uid": [[Configs sharedInstance] getUIDU], @"status": @"1"};
            [[ref child:[NSString stringWithFormat:@"%@%@", child, object_id]] setValue:value];
            // insert new data to firebase
        }
    }];
    
    /*
    NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/comments/%@/likes/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [data objectForKey:@"category"], app_id, post_id, comment_id];
    
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
    */
}

-(void)editTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSDictionary *comments = [post objectForKey:@"comments"];
    NSArray *keys = [comments allKeys];
    id aKey = [keys objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag];
    id anObject = [comments objectForKey:aKey];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Comment *cm = [storybrd instantiateViewControllerWithIdentifier:@"Comment"];
    
    cm.app_id       = app_id;
    cm.post_id      = post_id;
    cm.is_edit      = @"1";
    cm.object_id    = aKey;
    cm.message      = [anObject objectForKey:@"message"];
    [self.navigationController pushViewController:cm animated:YES];
}

-(void)deleteTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    //    NSArray *keys = [[data objectForKey:@"posts"] allKeys];
    //    id aKey = [keys objectAtIndex:[btn tag]];
    //    id anObject = [[data objectForKey:@"posts"] objectForKey:aKey];
    
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
        alertView.tag = -999;
    alertView.object = [NSString stringWithFormat:@"%d", [(UIGestureRecognizer *)gestureRecognizer view].tag] ;
    [alertView show];
}


- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                NSDictionary *comments = [post objectForKey:@"comments"];
                NSArray *keys = [comments allKeys];
                id aKey = [keys objectAtIndex:[alertView.object integerValue]];
                id anObject = [comments objectForKey:aKey];
                
                NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/comments/%@/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [posts objectForKey:@"category"], app_id, post_id, aKey];
                
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error == nil) {
                        
                    
                        // Update local database
                        
//                        if ([post objectForKey:aKey]) {
//                            NSMutableDictionary *posts = [data objectForKey:@"posts"];
//                            if ([posts objectForKey:aKey]) {
//
//                                NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
//                                [newPosts addEntriesFromDictionary:posts];
//                                if ([newPosts objectForKey:aKey]) {
//                                    [newPosts removeObjectForKey:aKey];
//
//                                    NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
//                                    [newData addEntriesFromDictionary:data];
//                                    if ([newData objectForKey:@"posts"]) {
//                                        [newData removeObjectForKey:@"posts"];
//                                    }
//                                    [newData setValue:newPosts forKey:@"posts"];
//
//                                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCenter:app_id :newData];
//                                }
//                            }
//                        }
                        
                        if ([comments objectForKey:aKey]) {
                            NSMutableDictionary*newComments = [[NSMutableDictionary alloc] init];
                            [newComments addEntriesFromDictionary:comments];
                            if ([newComments objectForKey:aKey]) {
                                [newComments removeObjectForKey:aKey];
                                
                                NSMutableDictionary*newPost = [[NSMutableDictionary alloc] init];
                                [newPost addEntriesFromDictionary:post];
                                if ([newPost objectForKey:@"comments"]) {
                                    [newPost removeObjectForKey:@"comments"];
                                    [newPost setValue:newComments forKey:@"comments"];
                                    
                                    NSMutableDictionary*newPosts = [[NSMutableDictionary alloc] init];
                                    [newPosts addEntriesFromDictionary:[posts objectForKey:@"posts"]];
                                    if ([newPosts objectForKey:post_id]) {
                                        [newPosts removeObjectForKey:post_id];
                                        
                                        [newPosts setValue:newPost forKey:post_id];
                                        
                                        NSMutableDictionary*newData = [[NSMutableDictionary alloc] init];
                                        [newData addEntriesFromDictionary:posts];
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
                    }
                }];
    
            }
            break;
            
        default:
            break;
    }
}

-(void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *center_data =  [[[centerRepo get:app_id] objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        posts   = [NSJSONSerialization JSONObjectWithData:center_data options:0 error:nil];
        post = [[posts objectForKey:@"posts"] objectForKey:post_id];
        
//        if ([post objectForKey:@"comments"]) {
//        }
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    
        [self._table reloadData];
    });
}
@end
