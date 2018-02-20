//
//  Comment.m
//  iDNA
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Comment.h"
#import "CenterRepo.h"
#import "Configs.h"
#import "AddCommentThread.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface Comment (){
    FIRDatabaseReference *ref;
    CenterRepo *centerRepo;
    
    NSMutableDictionary* data;
}
@end

@implementation Comment
@synthesize app_id, post_id, is_edit, object_id, message;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([is_edit isEqualToString:@"0"]) {
        // add new comment
        self.title = @"Add New Comment";
    }else{
        self.title = @"Edit Comment";
        
        self.tvText.text = message;
    }
    
    ref = [[FIRDatabase database] reference];
    centerRepo = [[CenterRepo alloc] init];
    
    data = [[NSMutableDictionary alloc] init];
    
    [self reloadData:nil];
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

- (void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *center_data =  [[[centerRepo get:app_id] objectAtIndex:[centerRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization JSONObjectWithData:center_data options:0 error:nil];
        
        NSLog(@"");
    });
}


- (IBAction)onSave:(id)sender {
    NSString *child = [NSString stringWithFormat:@"%@center/%@/%@/posts/%@/comments/", [[Configs sharedInstance] FIREBASE_ROOT_PATH], [data objectForKey:@"category"], app_id, post_id];
    NSLog(@"");
    
    NSString *text_comment = [self.tvText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([text_comment length] < 1) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Empty Comment"];
        return;
    }
    
    if ([is_edit isEqualToString:@"0"]) {
        // add new comment
        /*
        NSString* object_id = [ref childByAutoId].key;
        NSDictionary *value = @{@"uid": [[Configs sharedInstance] getUIDU], @"message": text_comment};
        [[ref child:[NSString stringWithFormat:@"%@%@", child, object_id]] setValue:value];
        */
        
         [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
         AddCommentThread *apThread = [[AddCommentThread alloc] init];
         [apThread setCompletionHandler:^(NSData *d) {
             
             NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:d  options:kNilOptions error:nil];
             if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                 
                 if ([data objectForKey:@"posts"]) {
                     NSMutableDictionary *posts = [data objectForKey:@"posts"];
                     
                     if ([posts objectForKey:post_id]) {
                         NSMutableDictionary* post = [posts objectForKey:post_id];
                         if ([post objectForKey:@"comments"]) {
                             NSDictionary *comments = [post objectForKey:@"comments"];
                             if (![comments objectForKey:jsonDict[@"item_id"]]) {
                                 
                                 NSMutableDictionary*newComments = [[NSMutableDictionary alloc] init];
                                 [newComments addEntriesFromDictionary:comments];
                                 [newComments setValue:jsonDict[@"value"] forKey:jsonDict[@"item_id"]];
                                 
                                 
                                 NSMutableDictionary*newPost = [[NSMutableDictionary alloc] init];
                                 [newPost addEntriesFromDictionary:post];
                                 [newPost removeObjectForKey:@"comments"];
                                 [newPost setValue:newComments forKey:@"comments"];
                                 
                                 
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
         
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[Configs sharedInstance] SVProgressHUD_Dismiss];
                     [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Add Comment success."];
                     [self.navigationController popViewControllerAnimated:NO];
                 });
             }else{
                 [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
             }
         }];
         
         [apThread setErrorHandler:^(NSString *error) {
             [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
         }];
        
         [apThread start:app_id :post_id :text_comment];
    }else{
        // edit comment
        NSDictionary *value = @{@"uid": [[Configs sharedInstance] getUIDU], @"message": text_comment};
        [[ref child:[NSString stringWithFormat:@"%@%@", child, object_id]] updateChildValues:value];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    }
    
    
    /*
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
    */
}
@end
