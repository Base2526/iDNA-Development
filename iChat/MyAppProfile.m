//
//  MyAppDetail.m
//  Heart
//
//  Created by Somkid on 1/16/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "MyAppProfile.h"
#import "AppConstant.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "MyAppMyPostHeaderCell.h"
#import "ViewImageView.h"
#import "GKImagePicker.h"
#import "UpdateMyAppProfileThread.h"
#import "DeleteMyApplicationThread.h"
#import "EditNameMAProfile.h"
#import "CategoryViewController.h"
#import "ListEP.h"
#import "HJManagedImageV.h"
#import "MyApplicationsRepo.h"
#import "MyApplications.h"

@interface MyAppProfile ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSArray *all_data;
    UIImage *img;
    NSMutableDictionary *category_application;
    
    NSMutableArray* center;
    
    MyApplicationsRepo* myAppRepo;
    
    NSArray* myApp;
    
    NSMutableDictionary *data ;
}

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation MyAppProfile
@synthesize app_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    category_application = [[Configs sharedInstance] loadData:_CATEGORY_APPLICATION];
    
    // fieldSelected = [NSMutableArray array];
    /*
    if (isOwner) {
        all_data = @[@"Cell-Name", @"Cell-Category", @"Cell-Subcategory", @"Cell-Email", @"Cell-Phone", @"Cell-Delete"];
    }else{
        all_data = @[@"Cell-Name", @"Cell-Category", @"Cell-Subcategory", @"Cell-Email", @"Cell-Phone"];
    }
    */
    
    all_data = @[@"Cell-Name", @"Cell-Category", @"Cell-Subcategory", @"Cell-Email", @"Cell-Phone"];
    
    [self._table registerNib:[UINib nibWithNibName:@"MyAppProfileMultiCell" bundle:nil] forCellReuseIdentifier:@"MyAppProfileMultiCell"];


    myAppRepo = [[MyApplicationsRepo alloc] init];
    myApp = [myAppRepo get:app_id];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    switch (section) {
        case 0:
        {
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyIDHeaderCell" owner:self options:nil];
            UIView *view = [viewArray objectAtIndex:0];
            HJManagedImageV *hjmPicture = [view viewWithTag:100];
            // lblTitle.text = @"Text you want to set";
            
            // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            // NSMutableDictionary *_dict = [[Configs sharedInstance] loadData:_USER];//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            //
            /*
            if (img != nil) {
                [hjmPicture setImage:img];
            }else{
            
                NSMutableDictionary *picture = [data valueForKey:@"picture"];
                if ([picture count] > 0 ) {
                    [hjmPicture showLoadingWheel];
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [hjmPicture setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmPicture ];
                }else{
                    [hjmPicture setImage:[UIImage imageNamed:@"ic-profile-defualt.png"]];
                }
            }
            
            hjmPicture.userInteractionEnabled = YES;
            // [self.hjmPicture addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
            // [self.hjmPicture addGestureRecognizer:<#(nonnull UIGestureRecognizer *)#>]
            
            [hjmPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker:)]];
            */
            
            
            
            // NSMutableArray *_item = [_items objectAtIndex:indexPath.row - 1];
            /****/
            
            NSData *data =  [[myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([f objectForKey:@"image_url"]) {
                [hjmPicture clear];
                [hjmPicture showLoadingWheel]; // API_URL
                [hjmPicture setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:hjmPicture];
                
                hjmPicture.userInteractionEnabled = YES;
                [hjmPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker:)]];
            }else{
                [hjmPicture clear];
            }
            
            return view;
        }
            break;
            
        case 1:
        {
            NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"MyAppMyPostHeaderCell" owner:self options:nil];
            MyAppMyPostHeaderCell *view = [viewArray objectAtIndex:0];
            
            view.labelName.text = [NSString stringWithFormat:@"Data"];
            
            return view;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return 120;
        }
            break;
            
        case 1:
        {
            return 30;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [all_data count];
    switch (section) {
        case 0:
            return 0;
            break;
            
        case 1:
            return [all_data count];
            break;
            
        default:
            break;
    }
    
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:[all_data objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
   
    
    // cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (isOwner) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSData *data =  [[myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    switch (indexPath.row) {
        case 0:{
            UILabel *label = (UILabel *)[cell viewWithTag:10];
            label.text = [f objectForKey:@"name"];
        }
            break;
            
        case 1:{
//            id anObject = [category_application objectForKey:[data objectForKey:@"category"]];
//
//            NSLog(@"%@", [self.data objectForKey:@"category"]);
//            UILabel *label = (UILabel *)[cell viewWithTag:10];
//            label.text = [anObject objectForKey:@"name"];//[self.data objectForKey:@"category"];
//
            
            NSData *data =  [[myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            id anObject = [category_application objectForKey:[f objectForKey:@"category"]];
            
            // NSLog(@"%@", [data objectForKey:@"category"]);
            UILabel *label = (UILabel *)[cell viewWithTag:10];
            label.text = [anObject objectForKey:@"name"];//[self.data objectForKey:@"category"];
            NSLog(@"");
        }
            break;
            
        case 2:{
            // Cell-Subcategory
            NSData *data =  [[myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary* category = [category_application objectForKey:[f objectForKey:@"category"]];
            
            NSDictionary* children = [category objectForKey:@"children"];
            
            UILabel *label = (UILabel *)[cell viewWithTag:10];
            if ([f objectForKey:@"subcategory"]) {
                NSDictionary* subcategory = [children objectForKey:[f objectForKey:@"subcategory"]];
                
                label.text = [subcategory objectForKey:@"name"];//[self.data objectForKey:@"category"];
                
            }else{
                label.text = @"Not select";
            }
        }
            break;
            
        case 3:
        {
            
//            NSDictionary *emails = [[center objectAtIndex:[[data objectForKey:@"category"] integerValue]] objectForKey:item_id];
//
//            UILabel *label = (UILabel *)[cell viewWithTag:10];
//            if ([emails objectForKey:@"mails"]) {
//                NSDictionary *temails=[emails objectForKey:@"mails"];
//
//
//                int count = 0;
//                for (NSString* key in temails) {
//                    if ([[[temails objectForKey:key] objectForKey:@"isUse"] isEqualToString:@"1"]) {
//                        count++;
//                    }
//                }
//
//                label.text = [NSString stringWithFormat:@"%lu Email", count];
//            }else{
//                label.text = @"0 Email";
//            }
            
            return cell;
        }
            break;
            
        case 4:
        {

//            NSDictionary *phones = [[center objectAtIndex:[[data objectForKey:@"category"] integerValue]] objectForKey:item_id];
//
//            UILabel *label = (UILabel *)[cell viewWithTag:10];
//            if ([phones objectForKey:@"phones"]) {
//                NSDictionary *tphones=[phones objectForKey:@"phones"];
//
//                int count = 0;
//                for (NSString* key in tphones) {
//                    if ([[[tphones objectForKey:key] objectForKey:@"isUse"] isEqualToString:@"1"]) {
//                        count++;
//                    }
//                }
//
//                label.text = [NSString stringWithFormat:@"%lu Phone", count];
//            }else{
//                label.text = @"0 Phone";
//            }
            
            return cell;
        }
            break;
        case 5:{
            cell.accessoryType = UITableViewCellAccessoryNone;
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            
            break;
        default:
            break;
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    switch (indexPath.section) {
        case 0:
            break;
            
        case 1:{
            
            if (isOwner) {
                switch (indexPath.row) {
                    case 0:{
                        NSLog(@"");
                        
                        // Edit name my application
                        
                        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        EditNameMAProfile *v = [storybrd instantiateViewControllerWithIdentifier:@"EditNameMAProfile"];
                        v.name = [data objectForKey:@"name"];
                        
                        [self.navigationController pushViewController:v animated:YES];
                    }
                        break;
                        
                    case 1:{
                        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        CategoryViewController *v = [storybrd instantiateViewControllerWithIdentifier:@"CategoryViewController"];
 
                        id anObject = [category_application objectForKey:[data objectForKey:@"category"]];
                        
                        NSLog(@"%@", [self.data objectForKey:@"category"]);
                        
                        v.category =[self.data objectForKey:@"category"];
                        [self.navigationController pushViewController:v animated:YES];
                    }
                        break;
                        
                    case 2:{
                        // List Emails
                        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ListEP *v   = [storybrd instantiateViewControllerWithIdentifier:@"ListEP"];
                        v.isYes     = TRUE;
                        v.item_id   = item_id;
                        v.category  = [self.data objectForKey:@"category"];
                        [self.navigationController pushViewController:v animated:YES];
                    }
                        break;
                        
                    case 3:{
                        // List Phones
                        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ListEP *v = [storybrd instantiateViewControllerWithIdentifier:@"ListEP"];
                        v.isYes = FALSE;
                        v.item_id   = item_id;
                        v.category  = [self.data objectForKey:@"category"];
                        [self.navigationController pushViewController:v animated:YES];
                    }
                        break;
                    case 4:{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Confirm Delete My Application." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                        
                            alertView.tag = -999;
                        [alertView show];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
            
        default:
            break;
    }
    */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*
    switch (alertView.tag) {
        case -999:
            if (buttonIndex == 0){
                NSLog(@"ยกเลิก");
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                
                DeleteMyApplicationThread *deleteThread = [[DeleteMyApplicationThread alloc] init];
                [deleteThread setCompletionHandler:^(NSString * data) {
                    
                    [[Configs sharedInstance] SVProgressHUD_Dismiss];
                    
                    NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                    
                    if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMyApplication" object:self userInfo:@{}];
                        
                        [self.navigationController popViewControllerAnimated:NO];
                    }else{
                        
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
                    }
                    
                }];
                [deleteThread setErrorHandler:^(NSString * error) {
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
                }];
                
                [deleteThread start:item_id];
                
            }
            
            break;
            
        default:
            break;
    }
    */
}

//- (void)showPicker:(UIButton *)btn{
-(void)showPicker:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSMutableDictionary *picture = [data valueForKey:@"picture"];
    if ([picture count] > 0 ) {
        /*
        if (isOwner) {
            // แสดงเป็น เจ้าของ application
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"View Picture", @"Edit Picture", nil];
            
            actionSheet.tag = 100;
            [actionSheet showInView:self.view];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"View Picture", nil];
            
            actionSheet.tag = 102;
            [actionSheet showInView:self.view];
        }
        */
    }else{
         UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Edit Picture", nil];
         
         actionSheet.tag = 101;
         [actionSheet showInView:self.view];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
                // View Picture
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
                NSMutableDictionary *picture = [data valueForKey:@"picture"];
                if ([picture count] > 0 ) {
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                    v.uri = url;
                }

                
                // v.name = self.name_friend;
                // [self.navigationController pushViewController:v animated:YES];
                
                UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
                
                [self presentViewController:navV animated:YES completion:nil];
                
                break;
            }
                
                // Edit Picture
            case 1:{
                
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(280, 280);
                self.imagePicker.delegate = self;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                    [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
                } else {
                    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
                }
                
                break;
            }
            default:
                break;
        }
    }
    else if (actionSheet.tag == 101){
        
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
    else if (actionSheet.tag == 102){
        switch (buttonIndex) {
                // View Picture
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
                NSMutableDictionary *picture = [data valueForKey:@"picture"];
                if ([picture count] > 0 ) {
                    
                    NSString *url = [[NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [picture objectForKey:@"filename"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    v.uri = url;
                }
                
                
                // v.name = self.name_friend;
                // [self.navigationController pushViewController:v animated:YES];
                
                UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
                
                [self presentViewController:navV animated:YES completion:nil];
                
                break;
            }
                
            default:
                break;
        }
        
    }
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
    UpdateMyAppProfileThread *uThread = [[UpdateMyAppProfileThread alloc] init];
    [uThread setCompletionHandler:^(NSData *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
//            img = image;
//            [self hideImagePicker];
//
//            [self reloadData:nil];
//
//            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
            
            
            NSData *data =  [[myApp objectAtIndex:[myAppRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableDictionary *newMyAppProfile = [[NSMutableDictionary alloc] init];
            [newMyAppProfile addEntriesFromDictionary:f];
            
            if ([newMyAppProfile objectForKey:@"image_url"]) {
                [newMyAppProfile removeObjectForKey:@"image_url"];
            }
            [newMyAppProfile setValue:jsonDict[@"image_url"] forKey:@"image_url"];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateMyApplications:app_id :newMyAppProfile];
            
            
            [self hideImagePicker];
            img = image;
            [self reloadData:nil];
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
            
        }else{
            
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
        }
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    
    [uThread start:app_id :@"0" :image];
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    // self.imgView.image = image;
    // self.hjmPicture.image = image;
    
    img = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    [self reloadData:nil];
}

- (void) reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        myApp = [myAppRepo get:app_id];
        
        center   = [[Configs sharedInstance] loadData:_CENTER];
        [self._table reloadData];
    });
}

- (IBAction)onShare:(id)sender {
    // /field-collection/field-my-application/1104320
    NSString *textToShare = @"iDNA Share My Application";
    // @"http://188.166.208.70/profile-main/729"
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@/field-collection/field-my-application/%@", [Configs sharedInstance].API_URL, app_id]];
    
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
@end


