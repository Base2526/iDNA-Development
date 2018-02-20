//
//  CreateGroup.m
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "CreateGroup.h"
#import "Configs.h"
#import "HJManagedImageV.h"
#import "AppDelegate.h"
#import "CreateGroupChatThread.h"
#import "FriendProfileRepo.h"
#import "FriendsRepo.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface CreateGroup (){
    FIRDatabaseReference *ref;
    FriendProfileRepo *friendProfileRepo;
    
    FriendsRepo *friendsRepo;
}

@property (nonatomic, strong) NSMutableDictionary *selectedIndex;
@property (nonatomic, strong) NSMutableDictionary *friends;
@end

@implementation CreateGroup
@synthesize selectedIndex, txtFName, friends, ImageVGroup;
@synthesize imagePicker;
@synthesize popoverController;

@synthesize fction, item_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"Create Group";
    
    friendProfileRepo = [[FriendProfileRepo alloc] init];
    friends = [NSMutableDictionary dictionary];
    selectedIndex = [NSMutableDictionary dictionary];
    
    ref = [[FIRDatabase database] reference];
    
    friendsRepo = [[FriendsRepo alloc] init];
    
    friends = [[NSMutableDictionary alloc] init];
    
    ImageVGroup.userInteractionEnabled = YES;
    [ImageVGroup addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    
    [txtFName setReturnKeyType:UIReturnKeyDone];
    txtFName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtFName resignFirstResponder];
    return YES;
}

// กรณีเปิด จะมีการ hide Tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void) viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadData:)
//                                                 name:RELOAD_DATA_PROFILES
//                                               object:nil];
    
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [friends removeAllObjects];
        
        NSMutableArray * fs = [friendsRepo getFriendsAll];
        for (int i = 0; i < [fs count]; i++) {
            NSArray *val =  [fs objectAtIndex:i];
            
            NSString* friend_id =[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"friend_id"]];
            NSData *data =  [[val objectAtIndex:[friendsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* friend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            Boolean flag = true;
            if ([friend objectForKey:@"hide"]) {
                if ([[friend objectForKey:@"hide"] isEqualToString:@"1"]) {
                    flag = false;
                }
            }
            if ([friend objectForKey:@"block"]) {
                if ([[friend objectForKey:@"block"] isEqualToString:@"1"]) {
                    flag = false;
                }
            }
            
            // สถานะรอการตอบรับคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    
                    flag = false;
                }
            }
            
            // สถานะทีเราส่งคำขอเป้นเพือน
            if ([friend objectForKey:@"status"]) {
                if (![[friend objectForKey:@"status"] isEqualToString:_FRIEND_STATUS_FRIEND]) {
                    
                    flag = false;
                }
            }
            
            if (flag) {
                [friends setObject:friend forKey:friend_id];
            }
        }
        
        [self.tableView reloadData];
    });
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Select Friend";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // NSMutableArray *friends = [data valueForKey:@"friends"];
    
    // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName =(UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    NSArray *keys = [friends allKeys];
    NSString* key = [keys objectAtIndex:indexPath.row];
    NSMutableDictionary* item = [friends objectForKey:key];
    
    NSArray *fprofile = [friendProfileRepo get:key];
    
    NSData *data =  [[fprofile objectAtIndex:[friendProfileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data == nil) {
        return  cell;
    }
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // NSMutableDictionary *f = [[Configs sharedInstance] loadData:key];//[[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
    
    if ([item objectForKey:@"change_friends_name"]) {
        lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"change_friends_name"], key];
    }
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        // [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (selectedIndex[indexPath] == nil) {
        // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
        NSArray *keys = [friends allKeys];
        
        [selectedIndex setObject:[keys objectAtIndex:indexPath.row] forKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [selectedIndex removeObjectForKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.title =[NSString stringWithFormat:@"Create Group(%d)", [selectedIndex count]];
    
    [txtFName resignFirstResponder];
}

- (IBAction)onCreateGroup:(id)sender {
    NSString *str_name = [txtFName.text stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceCharacterSet]];
    
    if ([str_name length] > 0 && [selectedIndex count] > 0) {
        
        
        NSMutableDictionary* members =[NSMutableDictionary dictionary];
        for (NSString* key in selectedIndex) {
            id value = [selectedIndex objectForKey:key];
            // do stuff
            [members setObject:@"" forKey:value];
        }

        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        CreateGroupChatThread *createGroup = [[CreateGroupChatThread alloc] init];
        [createGroup setCompletionHandler:^(NSData *data) {
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {     
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] updateGroup:jsonDict[@"item_id"] :jsonDict[@"value"]];
            }
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        
        [createGroup setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [createGroup start:str_name :[ImageVGroup image] : members];
    }else{
        NSLog(@"Name group empty or Not select Friend?");
        
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Name group empty or Not select Friend?"];
    }
}


-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:/*@"Take Photo", */ @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            /*
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
            */
        case 0:
        {
            NSLog(@"");
            self.imagePicker = [[GKImagePicker alloc] init];
            self.imagePicker.cropSize = CGSizeMake(280, 280);
            self.imagePicker.delegate = self;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            } else {
                [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    
    [ImageVGroup setImage:image];
    // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    /*
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [imageV clear];
            [imageV showLoadingWheel];
            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            
            [self updateURI:jsonDict[@"url"]];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:image];
    */
    
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //    img = image;
    //
    //    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
    //        [self.popoverController dismissPopoverAnimated:YES];
    //    } else {
    //        [picker dismissViewControllerAnimated:YES completion:nil];
    //    }
    //    [self reloadData:nil];
    
    NSLog(@"");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [ImageVGroup setImage:chosenImage];
    /*
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdatePictureProfileThread *uThread = [[UpdatePictureProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [imageV clear];
            [imageV showLoadingWheel];
            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            
            [self updateURI:jsonDict[@"url"]];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:chosenImage];
    */
    //
    //    img = chosenImage;
    //    // [self hideImagePicker];
    //
    //    [self reloadData:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
