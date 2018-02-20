//
//  CreateMyCard.m
//  Heart
//
//  Created by Somkid on 1/12/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "CreateMyCard.h"
#import "BackgroundCard.h"
#import "MyCardCell.h"
#import "MyCardPhotoCell.h"
#import "MyCardMultiCell.h"
#import "CreateMyCardThread.h"
#import "Configs.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "ViewImageView.h"
#import "GKImagePicker.h"
#import "CreateMyCardSelectEmail.h"
#import "CreateMyCardSelectPhone.h"

@interface CreateMyCard ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *fieldSelected;
    
    NSString *indexBG, *nameBG, *name;
    
    UIImage *img;
}

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic) float rowHeight;

@end

@implementation CreateMyCard
@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fieldSelected = [NSMutableArray array];
    
    // self._table.estimatedRowHeight = 400.0;
    // self._table.rowHeight = UITableViewAutomaticDimension;
    
    self.btnCreate.enabled = NO;
    name = @"";
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [fieldSelected addObject:indexPath];
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [fieldSelected addObject:indexPath];
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [fieldSelected addObject:indexPath];
    NSLog(@"%@", indexPath);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
-(void)viewWillAppear:(BOOL)animated{
//    [self._table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    [self._table reloadData];
    
    
//    self._table.estimatedRowHeight = 80;
//    self._table.rowHeight = UITableViewAutomaticDimension;
//    
//    [self._table setNeedsLayout];
//    [self._table layoutIfNeeded];
//    
//    self._table.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;// Status bar inset
    

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // select_category
    if ([segue.identifier isEqualToString:@"select_bg"]) {
        
        // http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller
        // get register to fetch notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectBG:)
                                                     name:@"selectBG" object:nil];
        
        BackgroundCard* v = segue.destinationViewController;
        v.select = indexBG;
    }
}


#pragma mark -
#pragma mark Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    // return UITableViewAutomaticDimension;
//    
//    switch (indexPath.row) {
//        case 3:
//        {
//            
////            NSString *cellText = @"Label";
////            UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:10.0];
////            CGSize labelSize = [cellText sizeWithFont:cellFont
////                                    constrainedToSize:constraintSize
////                                        lineBreakMode:UILineBreakModeWordWrap];
////            return lableSize ;
//            
//            
//           /// return self.rowHeight;
//            
//            static MyCardEmailCell *cell = nil;
//            static dispatch_once_t onceToken;
//            
//            dispatch_once(&onceToken, ^{
//                cell = [self._table dequeueReusableCellWithIdentifier:@"cellIdentify"];
//            });
//            
//            // [self setUpCell:cell atIndexPath:indexPath];
//            
//            return [self calculateHeightForConfiguredSizingCell:cell];
//        
//        }
//            break;
//            
//        default:
//            
//            break;
//    }
//    
//    return 60;
//}

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
    return 5;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 120;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
   
    
    static NSString *CellIdentifier = @"Cell";
    
    switch (indexPath.row) {
        case 0:
        {
            CellIdentifier = @"Cell-CardName";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextView *tv = (UITextView *)[cell viewWithTag:10];
            tv.delegate = self;
        }
            break;
            
            //
        case 1:
        {
            /*
            CellIdentifier = @"Cell-Photo";
            MyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            cell.img_select.tag = indexPath.row;
            cell.img_select.userInteractionEnabled = YES;
            [cell.img_select addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.img_select setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.img_select setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            
            NSLog(@"indexPath : %@", indexPath);
            NSLog(@"");
            return cell;
            */
            
            MyCardPhotoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardPhotoCell"];
            
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MyCardPhotoCell" bundle:nil] forCellReuseIdentifier:@"MyCardPhotoCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardPhotoCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelName.text = @"Photo Card";
            
            cell.imgCheck.tag = indexPath.row;
            cell.imgCheck.userInteractionEnabled = YES;
            [cell.imgCheck addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            
            if (img != nil) {
                
                [cell.hjmPhoto setImage:img];
            }else{
            
                /*
                // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *_dict =  [[Configs sharedInstance] loadData:_USER];;//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            
            
            // IDReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IDReusableView" forIndexPath:indexPath];
            //                NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
            //                headerView.title.text = title;
            //                UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
            //                headerView.backgroundImage.image = headerImage;
            
            
                NSArray *c = [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0];
                if ([[_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0] isKindOfClass:[NSDictionary class]]) {
                    NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]];
                

                    [cell.hjmPhoto clear];
                    [cell.hjmPhoto showLoadingWheel];
                    [cell.hjmPhoto setUrl:[NSURL URLWithString:url]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.hjmPhoto ];
                }
                */
            }
            
            cell.hjmPhoto.userInteractionEnabled = YES;
            // [self.hjmPicture addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
            // [self.hjmPicture addGestureRecognizer:<#(nonnull UIGestureRecognizer *)#>]
            
            [cell.hjmPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker:)]];
            
            
            return cell;
            
        }
            break;
            
        case 2:
        
        {
             /*
            CellIdentifier = @"Cell-Email";
            MyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            cell.img_select.tag = indexPath.row;
            cell.img_select.userInteractionEnabled = YES;
            [cell.img_select addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.img_select setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.img_select setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            return cell;
             */
            
            MyCardMultiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardMultiCell"];
            
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MyCardMultiCell" bundle:nil] forCellReuseIdentifier:@"MyCardMultiCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardMultiCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.labelName.text = @"Email";
            
            /*
            // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict =  [[Configs sharedInstance] loadData:_USER];;//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            

            // NSMutableArray *mail = [[_dict objectForKey:@"user"][@"mail"] componentsSeparatedByString:@"@"];
            
            NSMutableArray *mail = [[_dict objectForKey:@"user"][@"mail"] componentsSeparatedByString:@"@"];
            
            if ([mail[1] isEqualToString:@"annmousu"]) {

                cell.labelDetail.text =@"Not Register";
                
                [fieldSelected removeObject:indexPath];
          
            }else{
                 cell.labelDetail.text = [_dict objectForKey:@"user"][@"mail"];
            }
            
           
            */
            
            cell.imgCheck.tag = indexPath.row;
            cell.imgCheck.userInteractionEnabled = YES;
            [cell.imgCheck addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];

            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            
            return cell;
        }
            break;
            
        case 3:
        {
            /*
            CellIdentifier = @"Cell-Phone";
            MyCardEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            */
            
            MyCardMultiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardMultiCell"];
            
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MyCardMultiCell" bundle:nil] forCellReuseIdentifier:@"MyCardMultiCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardMultiCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelName.text = @"Phone";
            
            

            /*
            // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *_dict =  [[Configs sharedInstance] loadData:_USER];// [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
            NSArray*profile2_phone =  [_dict objectForKey:@"profile2"][@"field_profile_phone"];
            
            if ([profile2_phone count] > 0) {
                 cell.labelDetail.text =[_dict objectForKey:@"profile2"][@"field_profile_phone"][@"und"][0][@"value"];
            }else{

                cell.labelDetail.text = @"";
            }
            
            // cell.labelDetail.text = @"098123234, 0983628123, 098123234, 0983628123, 098123234";
            
            cell.imgCheck.tag = indexPath.row;
            cell.imgCheck.userInteractionEnabled = YES;
            [cell.imgCheck addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            */
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.imgCheck setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            
            return cell;
        }
            break;
            
            /*
        case 4:
        {
            CellIdentifier = @"Cell-Heart";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
        }
            break;
            
        case 5:
        {
            CellIdentifier = @"Cell-Facebook";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
        }
            
            break;
        case 6:
        {
            CellIdentifier = @"Cell-googleplus";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
        }
            break;
            
        case 7:
        {
            CellIdentifier = @"Cell-line";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
        }
            break;
            
        case 8:
        {
            CellIdentifier = @"Cell-ig";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            im.tag = indexPath.row;
            im.userInteractionEnabled = YES;
            [im addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapped:)]];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
        }
            break;
             */
            
        case 4:
        {
            CellIdentifier = @"Cell-BG";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            UILabel *labelName = (UILabel *)[cell viewWithTag:10];
            
            
            if (nameBG != nil) {
                [labelName setText:nameBG];
            }else{
                [labelName setText:@"Default"];
            }
            
            /*
            UIImageView *im = (UIImageView *)[cell viewWithTag:11];
            
            if ([fieldSelected containsObject:indexPath])
            {
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [im setImage:[UIImage imageNamed:@"ic-check.png"]];
            }
            else
            {
                // cell.accessoryType = UITableViewCellAccessoryNone;
                [im setImage:[UIImage imageNamed:@"ic-uncheck.png"]];
            }
            */
        }
            break;
            
        default:
            break;
    }
    
    
    // cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section : %i" , indexPath.section);
    NSLog(@"row : %i" , indexPath.row);
    
    // คำนวณหา array อันสุดท้าย(คือปุ่ม status)
//    if ([all_data count] == indexPath.row + 1) {
//    }else{
    
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
//        //self.selectedIndexPath = indexPath;
//        
//        //the below code will allow multiple selection
//        if ([fieldSelected containsObject:indexPath])
//        {
//            [fieldSelected removeObject:indexPath];
//        }
//        else
//        {
//            [fieldSelected addObject:indexPath];
//        }
////    }
    
    switch (indexPath.row) {
        case 2:
        {
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreateMyCardSelectEmail *v = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyCardSelectEmail"];
            
            //    UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
            //
            //    [self presentViewController:navV animated:YES completion:nil];
            
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
        case 3:
        {
            
            UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreateMyCardSelectPhone *v = [storybrd instantiateViewControllerWithIdentifier:@"CreateMyCardSelectPhone"];
            
            //    UINavigationController* navV = [[UINavigationController alloc] initWithRootViewController:v];
            //
            //    [self presentViewController:navV animated:YES completion:nil];
            
            [self.navigationController pushViewController:v animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    [self reloadData];
}

-(void)selectTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    // NSIndexPath *indexPath = [self._table indexPathForSelectedRow];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gestureRecognizer.view.tag inSection:0];
    NSLog(@"%@", indexPath);
    
    [self._table deselectRowAtIndexPath:indexPath animated:YES];
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
}

-(void)selectBG:(NSNotification *)notification{
    
    NSDictionary* userInfo = notification.userInfo;
    indexBG = (NSString*)userInfo[@"index"];
    nameBG = (NSString*)userInfo[@"value"];
    
    [self reloadData];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    name = textField.text;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    /*
     if(range.length + range.location > textField.text.length)
     {
     return NO;
     }
     
     NSUInteger newLength = [textField.text length] + [string length] - range.length;
     return newLength <= 25;
     */
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength == 0) {
        self.btnCreate.enabled = NO;
    }else if(newLength > 0 /*&& imgPhoto != nil && ![textCategory isEqualToString:@""]*/ )
    {
        self.btnCreate.enabled = YES;
    }
    return YES;
}

-(void)reloadData
{
//    if([fieldSelected count] > 0){
//        self.btnCreate.enabled = YES;
//    }else{
//        self.btnCreate.enabled = NO;
//    }
    [self._table reloadData];
}

- (IBAction)onClose:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCreate:(id)sender {
    
    [self reloadData];
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait"];
    
    CreateMyCardThread *createMyCardThread = [[CreateMyCardThread alloc] init];
    [createMyCardThread setCompletionHandler:^(NSString *data) {
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Create Card success."];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"output"]];
        }
        
    }];
    
    [createMyCardThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    // [sendHeartToFriendThread start:[self.data valueForKey:@"uid"]];
    
    [createMyCardThread start:name :nil :nil :nil];

}


//- (void)showPicker:(UIButton *)btn{
-(void)showPicker:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    /*
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *_dict =  [[Configs sharedInstance] loadData:_USER];;//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
    NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
    
    if ([profile2_img count] > 0) {
        
        if ([[_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0] isKindOfClass:[NSDictionary class]]) {
            
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
                                                            otherButtonTitles:@"Edit Picture", nil];
            
            actionSheet.tag = 101;
            [actionSheet showInView:self.view];
        }
        
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Edit Picture", nil];
        
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
    }
    */
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        
        switch (buttonIndex) {
                // View Picture
            case 0:{
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ViewImageView *v = [storybrd instantiateViewControllerWithIdentifier:@"ViewImageView"];
                
                //                if (![self.profile_picture isEqualToString:@""]) {
                //                    v.uri = self.profile_picture;
                //                }
                
                if (img != nil) {
                    v.image = img;
                }else{
                
                    /*
                    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                    NSMutableDictionary *_dict =  [[Configs sharedInstance] loadData:_USER];//[NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
                
                    NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
                
                    if ([profile2_img count] > 0) {
                        NSLog(@"%@", [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]);
                    
                        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [_dict objectForKey:@"profile2"][@"field_profile_image"][@"und"][0][@"filename"]];
                    
                        v.uri = url;
                    }
                    */
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
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    // self.imgView.image = image;
    
    // self.hjmPicture.image = image;
    
    /*
    [SVProgressHUD showWithStatus:@"Update."];
    
    UpdatePictureProfileThread *updatePicture = [[UpdatePictureProfileThread alloc] init];
    [updatePicture setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        NSLog(@"%@", jsonDict);
        
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showSuccessWithStatus:@"Update success"];
        
    
        
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *_dict = [NSKeyedUnarchiver unarchiveObjectWithData:[preferences objectForKey:_USER]];
        
        // NSArray*profile2_img =  [_dict objectForKey:@"profile2"][@"field_profile_image"];
        
        NSMutableDictionary *profile2Dict = [[NSMutableDictionary alloc] init];
        
        [profile2Dict addEntriesFromDictionary:[_dict objectForKey:@"profile2"]];
        
        [profile2Dict removeObjectForKey:@"field_profile_image"];
        
        // NSMutableDictionary *field_profile_image = [profile2Dict objectForKey:@"field_profile_image"];
        
        NSMutableDictionary *new_field_profile_image = [NSMutableDictionary
                                                        dictionaryWithDictionary:@{
                                                                                   @"und" :@[[jsonDict objectForKey:@"file"]]
                                                                                   }];
        
        
        [profile2Dict setObject:new_field_profile_image forKey:@"field_profile_image"];
        
        
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict addEntriesFromDictionary:_dict];
        [newDict removeObjectForKey:@"profile2"];
        
        [newDict setObject:profile2Dict forKey:@"profile2"];
        
        [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: newDict] forKey:_USER];
        
        [preferences synchronize];
        
    }];
    
    [updatePicture setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
        
        [SVProgressHUD showErrorWithStatus:data];
        
        // Delay execution of my block for 2 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    [updatePicture start:image];
    */
    
    
    img = image;
    [self hideImagePicker];
    
    [self reloadData];
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
    [self reloadData];
}
@end
