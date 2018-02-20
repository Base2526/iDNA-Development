//
//  ViewPost.m
//  Heart
//
//  Created by Somkid on 1/19/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "ViewPost.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "MyAppCell.h"
#import "CommentCell.h"
#import "AppConstant.h"

#import "CustomTableView.h"
#import "CommentPostThread.h"
#import "WYPopoverController.h"
#import "MenuMyApp.h"
#import "CustomAlertView.h"
#import "DeletePostThread.h"
#import "AddPost.h"

@interface ViewPost ()<WYPopoverControllerDelegate, UIActionSheetDelegate>{
    
    WYPopoverController *settingsPopoverController;
    
    NSArray *all_data;
}
@property (strong, nonatomic) CustomTableView *tableView;
@end

@implementation ViewPost

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.data_item removeAllObjects];
    
    [self.tableView setAllowsSelection:YES];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAppCell" bundle:nil] forCellReuseIdentifier:@"MyAppCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override loadView so we can use CustomTableView that implements
// inputAccessoryView. Also set the tableView as the first responder
// so that it displays the inputAccessoryView on load.
- (void)loadView {
    // self.title = @"TableView";
    
    self.tableView = [[CustomTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView becomeFirstResponder];
    
    // Pass the current controller as the keyboardBarDelegate
    ((CustomTableView *)self.tableView).keyboardBarDelegate = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchView)];
    [self.view addGestureRecognizer:recognizer];
}

// Dissmiss the keyboard on tableView touches by making
// the view the first responder
- (void)didTouchView {
    [self.tableView becomeFirstResponder];
}

#pragma KeyboardBarDelegate

// Handle keyboard bar event by creating an alert that contains
// the text from the keyboard bar. In reality, this would do something more useful
- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text {
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Keyboard Text" message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//    [alert show];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
    
    CommentPostThread *commentThread = [[CommentPostThread alloc] init];
    [commentThread setCompletionHandler:^(NSString *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            /*
             2017-01-23 09:58:31.933272 Heart[3297:834577] {"nid_item_c":"748","firebase":"{\"name\":\"-Kb8FfWy3NgAdyfP_e7t\"}","result":true,"function":"comment_post"}
             */
            
            NSDictionary *firebase_key = jsonDict[@"firebase_key"];
            
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Add Post success."];
            // [self.navigationController popViewControllerAnimated:YES];
            
//            else if ([snapshot.key isEqualToString:@"comment"]){
//                [self.data_item removeObjectForKey:snapshot.key];
//                [self.data_item setObject:snapshot.value forKey:snapshot.key];
//            }
            
            
            
            [keyboardBar.textView setText:@""];
            
            [self.view endEditing:YES];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
        
    }];
    
    [commentThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [commentThread start:self.nid :self.nid_item :text];
    // [apThread start:self.is_add:self.nid :self.post_nid :img :self.txtTitle.text :self.textViewMessage.text];
}

#pragma Check dealloc

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

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [all_data count];
    
    if ([self.data_item objectForKey:@"comment"]) {
        NSDictionary *items = [self.data_item objectForKey:@"comment"] ;
        
        return [items count] + 1;
    }
    
    return  1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    // items_post
    NSArray *keys = [[all_data objectForKey:@"post"] allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id anObject = [[all_data objectForKey:@"post"] objectForKey:aKey];
    
    NSMutableDictionary *picture = [anObject valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        [cell.hjmImage clear];
        [cell.hjmImage showLoadingWheel];
        
        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
        
        [cell.hjmImage setUrl:[NSURL URLWithString:url]];
        // [img setImage:[UIImage imageWithData:fileData]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
    }else{
    }
    
    cell.title.text = [anObject objectForKey:@"title"];
    cell.labelMessage.text = [anObject objectForKey:@"detail"];
    
    cell.btnPopup.tag = indexPath.row;
    NSLog(@"indexPath : %d", indexPath.row);
    [cell.btnPopup addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    
    // Buttom Like
    cell.btnLike.tag = indexPath.row;
    [cell.btnLike addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchDown];
    
    // Buttom Comment
    cell.btnComment.tag = indexPath.row;
    [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchDown];
    
    // Buttom Share
    cell.btnShare.tag = indexPath.row;
    [cell.btnShare addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchDown];
     */
    
    switch (indexPath.row) {
        case 0:
        {
            MyAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSMutableDictionary *picture = [self.data_item valueForKey:@"picture"];
            if ([picture count] > 0 ) {
                [cell.hjmImage clear];
                [cell.hjmImage showLoadingWheel];
                
                NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]];
                
                [cell.hjmImage setUrl:[NSURL URLWithString:url]];
                // [img setImage:[UIImage imageWithData:fileData]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmImage ];
            }else{
            }
            
            cell.btnPopup.tag = indexPath.row;
            NSLog(@"indexPath : %d", indexPath.row);
            [cell.btnPopup addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
            
            // Buttom Like
            cell.btnLike.tag = indexPath.row;
            [cell.btnLike addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchDown];
            
            if ([self.data_item objectForKey:@"like"]) {
                
                if ([[self.data_item objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]]) {
                    
                    NSString* is_like = [[[self.data_item objectForKey:@"like"] objectForKey:[[Configs sharedInstance] getUIDU]] objectForKey:@"is_like"];
                    if ([is_like isEqualToString:@"0"]) {
                        [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
                    }else{
                        [cell.btnLike setTitle:@"Unlike" forState:UIControlStateNormal];
                    }
                }else{
                    [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
                }
            }else{
                [cell.btnLike setTitle:@"Like" forState:UIControlStateNormal];
            }
            
            // Buttom Comment
            cell.btnComment.tag = indexPath.row;
            [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchDown];
            
            cell.title.text = [self.data_item objectForKey:@"title"];
            cell.labelMessage.text = [self.data_item objectForKey:@"detail"];
        
            
            if ([self.data_item objectForKey:@"comment"]) {
                NSDictionary *comment = [self.data_item objectForKey:@"comment"];
                [cell.btnComment setTitle:[NSString stringWithFormat:@"Comment(%lu)", [comment count]] forState:UIControlStateNormal];
            }else{
                [cell.btnComment setTitle:[NSString stringWithFormat:@"Comment(0)"] forState:UIControlStateNormal];
            }
            
            return cell;
        }
            break;
            
        default: {
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"index row = %d", indexPath.row);
            NSLog(@"count = %d", [self.data_item count]);
            
            if (indexPath.row >= [self.data_item count] - 1) {
                NSLog(@"");
            }else{
            
                NSArray *keys = [[self.data_item objectForKey:@"comment"] allKeys];
                id aKey = [keys objectAtIndex:indexPath.row - 1];
                id anObject = [[self.data_item objectForKey:@"comment"] objectForKey:aKey];
            
                cell.labelName.text = [anObject objectForKey:@"uid"];
                cell.labelDetail.text = [anObject objectForKey:@"text"];
                
                
            }
            
            // [cell addTarget:self action:@selector(onCell:) forControlEvents:UIControlEventTouchDown];
            
            
            // UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
            // [cell addGestureRecognizer:headerTapped];
            
            cell.tag = indexPath.row;
            cell.userInteractionEnabled = YES;
            [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)]];
            return cell;
                
        }
            break;
    }
    
    return nil;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    NSLog(@"section : %d" , gestureRecognizer.view.tag);
    
    if (gestureRecognizer.view.tag == 0) {
        
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Edit", nil];
        
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        
        NSLog(@"");
    }
}

-(void)showMenu:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"%i", btn.tag);
    
    MenuMyApp *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuMyApp"];
    settingsViewController.preferredContentSize = CGSizeMake(320, 80);
    settingsViewController.row = [NSString stringWithFormat:@"%d", btn.tag];
    
    // settingsViewController.preferredContentSize
    
    // settingsViewController.title = @"Settings";
    
    /*
     [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
     
     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
     */
    
    settingsViewController.modalInPopover = NO;
    
    // UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:settingsViewController];
    settingsPopoverController.delegate = self;
    
    settingsPopoverController.theme.arrowHeight = 13;
    settingsPopoverController.theme.arrowBase = 25;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MenuMyApp:)
                                                 name:@"MenuMyApp" object:nil];
    
    [settingsPopoverController presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

-(void)MenuMyApp:(NSNotification *)notification{
    
    NSDictionary* userInfo = notification.userInfo;
    NSString *row   = (NSString*)userInfo[@"row"];
    NSString *index = (NSString*)userInfo[@"index"];
    
    NSLog(@"MenuMyApp> row=%@, index=%@", row,index);
    
    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:settingsPopoverController];
    }];
    
    switch ([index integerValue]) {
        case 0:
        {
            
            //Edit
            
            // MenuMyApp *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuMyApp"];
            
            AddPost *v = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPost"];
            
            /*
            v.is_add = @"0";
            // v.key = key;
            v.item_id = self.nid;
             */
            
            
            // ดึงข้อมูลเพือทำการแก้ไข
//            NSDictionary *post = [all_data objectForKey:@"post"];
//            NSArray *keys = [post allKeys];
//            id aKey = [keys objectAtIndex:[row integerValue]];
            
           //  v.post_nid = self.nid_item;
           // v.edit_data =self.data_item;//[[all_data objectForKey:@"post"] objectForKey:aKey];
            
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
            
        case 1:
        {
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
}

-(void)onLike:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    // NSLog(@"onLike > %d - %@", [btn tag], [preferences objectForKey:_UID]);
    
//    NSArray *keys = [[all_data objectForKey:@"post"] allKeys];
//    id nid_item = [keys objectAtIndex:[btn tag]];
    
    /*
    NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/my-id/my-app/%@/post/%@/like/%@", [[Configs sharedInstance] getUIDU], self.nid, self.nid_item, [[Configs sharedInstance] getUIDU]];
    
    [[self.ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.value == [NSNull null]){
            NSLog(@"");
            
            NSDictionary *userInformation = @{@"is_like": @"1"};
            
            [[self.ref child:child] setValue:userInformation withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                NSLog(@"");
            }];
        }else{
            [[[self.ref child:child] child:@"is_like"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                NSLog(@"%@", snapshot.value);
                if ([snapshot.value isEqualToString:@"1"]) {
                    NSLog(@"");
                    
                    [[self.ref child:child] updateChildValues:@{@"is_like":@"0"} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        if (error) {
                            NSLog(@"Error updating data: %@", error.debugDescription);
                        }
                    }];
                }else{
                    [[self.ref child:child] updateChildValues:@{@"is_like":@"1"} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        if (error) {
                            NSLog(@"Error updating data: %@", error.debugDescription);
                        }
                    }];
                }
            }];
        }
        
        [self reloadData];
        
        // [ref removeObserverWithHandle:crv_handle];
        // [usersRef removeAllObservers];
    }];
    */
}

-(void)onComment:(id)sender
{
    /* call keyboard open */
    KeyboardBar*v = (KeyboardBar *)self.tableView.inputAccessoryView;
    [v.textView becomeFirstResponder];
}

- (void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
            }else{
                NSDictionary* userInfo = alertView.object;
                
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
                
                DeletePostThread *deleteThread = [[DeletePostThread alloc] init];
                [deleteThread setCompletionHandler:^(NSString *data) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        
                        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Delete Post success."];
                        // [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
                    }
                    
                }];
                
                [deleteThread setErrorHandler:^(NSString *error) {
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                
                // NSLog(@"key - %@", self.key);
                // NSLog(@"nid - %@", [all_data objectForKey:@"nid"]);
                
//                NSDictionary *post = [self.data_item objectForKey:@"post"];
//                NSArray *keys = [post allKeys];
//                id nid_post = [keys objectAtIndex:[[userInfo objectForKey:@"row"] integerValue]];
                
                // NSLog(@"key_edit - %d", key_edit);
                // NSLog(@"edit_item_id - %@", [[items_post objectForKey:key_edit] objectForKey:@"item_id"]);
                
                [deleteThread start: self.nid : self.nid_item];
            }
            break;
            
        default:
            break;
    }
}

-(void) reloadData
{
    [self.tableView reloadData];
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
@end
