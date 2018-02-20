//
//  InviteFriendForContactsViewController.m
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "InviteFriendForContactsViewController.h"

#import <AddressBook/AddressBook.h>

#import "ContactusCell.h"

#import "SVProgressHUD.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InviteFriendForContactsViewController ()<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
    
    NSMutableArray *users1, *users3;
    NSMutableArray *users2;
    
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
}

@end

@implementation InviteFriendForContactsViewController{
    
    // NSArray *listItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // listItems = @[@"Cell", @"Cell", @"Cell", @"Cell"];
    
    [self._table registerNib:[UINib nibWithNibName:@"ContactusCell" bundle:nil] forCellReuseIdentifier:@"ContactusCell"];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    users1 = [[NSMutableArray alloc] init];
    users2 = [[NSMutableArray alloc] init];
    users3 = [[NSMutableArray alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    [self allowAddressBook];
    
    
    
    ///
    if (!sectionTitleArray) {
        sectionTitleArray = [NSMutableArray arrayWithObjects:@"By Email", @"By Phone", nil];
    }
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES], nil];
    }
//    if (!sectionContentDict) {
//        sectionContentDict  = [[NSMutableDictionary alloc] init];
//        NSArray *array1     = [NSArray arrayWithObjects:@"bla 1", @"bla 2", @"bla 3", @"bla 4", nil];
//        [sectionContentDict setValue:array1 forKey:[sectionTitleArray objectAtIndex:0]];
//        NSArray *array2     = [NSArray arrayWithObjects:@"wurst 1", @"käse 2", @"keks 3", nil];
//        [sectionContentDict setValue:array2 forKey:[sectionTitleArray objectAtIndex:1]];
//    }
    ///
    
}

-(void)allowAddressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted){
                [self loadAddressBook];
            }else{
                NSLog(@"");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allow Access Contactus"
                                                                message:@"Settings>Heart-Basic>Contacts Enable"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        });
    });
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

#pragma mark - Table view data source
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // return [listItems count];
    
    return  [users1 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    //
    //    // Configure the cell...
    //
    //    return cell;
    
    
    ContactusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactusCell" forIndexPath:indexPath];
    
    //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    UILabel *labelName  = (UILabel *)[cell viewWithTag:11];
    UILabel *labelEmail = (UILabel *)[cell viewWithTag:12];
//    UILabel *labelPhone = (UILabel *)[cell viewWithTag:13];
    
    NSDictionary *user = [users1 objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [user valueForKey:@"emails"]);
    
    // [emails addObjectsFromArray:user[@"emails"]];
    
    [labelName setText:[user valueForKey:@"name"]];
    [labelEmail setText:[user valueForKey:@"emails"][0]];
    // [labelPhone setText:[user valueForKey:@"phones"][0]];
    
    return cell;
}

*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor brownColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-30, 30)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    /*
     if (!manyCells) {
     headerString.text = @"click to enlarge";
     }else{
     headerString.text = @"click again to reduce";
     }
     */
    
    headerString.text = [NSString stringWithFormat:@"%@ (%d)", [sectionTitleArray objectAtIndex:section], [[sectionContentDict objectForKey:[sectionTitleArray objectAtIndex:section]] count]];
    
    
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"ic-arrow-up.png"] : [UIImage imageNamed:@"ic-arrow-down.png"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-30, 3, 25, 25); //CGRe
    [headerView addSubview:upDownArrow];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 80;
    }
    return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    return cell;
    */
    
    ContactusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactusCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    UILabel *labelName  = (UILabel *)cell.labelName;
    UILabel *labelEmail = (UILabel *)cell.labelEmail;
    UIButton *btn       = (UIButton *)cell.btnInvite;
   
    
    // [emails addObjectsFromArray:user[@"emails"]];
    
    if (indexPath.section == 0) {
        
        BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        if (!manyCells) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        // cell.textLabel.text = [content objectAtIndex:indexPath.row];
        
        
        // NSLog(@"%@", content);
        
        // NSDictionary *user = [users1 objectAtIndex:indexPath.row];
        
        // NSLog(@"%@", [user valueForKey:@"emails"]);
        
        if (content != nil) {
            [labelName setText:[[content objectAtIndex:indexPath.row] valueForKey:@"name"]/*[content valueForKey:@"name"]*/];
            [labelEmail setText:[[content objectAtIndex:indexPath.row] valueForKey:@"emails"][0]];
            // [labelPhone setText:[user valueForKey:@"phones"][0]];
        }
        
        btn.tag = indexPath.row;
        [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(byEmailTapped:)]];
    }else  if (indexPath.section == 1) {
        
        BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        if (!manyCells) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        // cell.textLabel.text = [content objectAtIndex:indexPath.row];
        
        
        // NSLog(@"%@", content);
        
        // NSDictionary *user = [users1 objectAtIndex:indexPath.row];
        
        // NSLog(@"%@", [user valueForKey:@"emails"]);
        
        if (content != nil) {
            [labelName setText:[[content objectAtIndex:indexPath.row] valueForKey:@"name"]/*[content valueForKey:@"name"]*/];
            [labelEmail setText:[[content objectAtIndex:indexPath.row] valueForKey:@"phones"][0]];
            // [labelPhone setText:[user valueForKey:@"phones"][0]];
        }
        
        btn.tag = indexPath.row;
        [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(byPhonesTapped:)]];
    }
    

    
    return cell;
}

-(void)byEmailTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:0]];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Heart"];
        [mailCont setToRecipients:[NSArray arrayWithObject:[[content objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"emails"][0]]];
        [mailCont setMessageBody:@"Heart get this app and add me https://beta.itunes.apple.com/v1/app/1184807478" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
        
#define URLEMail @"mailto:info@satitpatumwan.ac.th?subject=subject&body=body"
        
        NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            // NSLog(@"You sent the email.");
            
            [SVProgressHUD showSuccessWithStatus:@"You sent the email."];
            break;
        case MFMailComposeResultSaved:
            // NSLog(@"You saved a draft of this email");
            
            [SVProgressHUD showSuccessWithStatus:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            // NSLog(@"You cancelled sending this email.");
            
            // [SVProgressHUD showErrorWithStatus:@"You cancelled sending this email."];
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            
            [SVProgressHUD showErrorWithStatus:@"Mail failed:  An error occurred when trying to compose this email."];
            break;
        default:
            // NSLog(@"An error occurred when trying to compose this email");
            
            [SVProgressHUD showErrorWithStatus:@"An error occurred when trying to compose this email."];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)byPhonesTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    
    NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:1]];
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    //[[content objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"emails"][0]
    NSArray *recipents = @[[[content objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"phones"][0]];
    NSString *message = [NSString stringWithFormat:@"https://beta.itunes.apple.com/v1/app/1184807478"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            [SVProgressHUD showSuccessWithStatus:@"Send SMS Success."];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self._table reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadAddressBook
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef sourceBook = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, sourceBook, kABPersonFirstNameProperty);
        CFIndex personCount = CFArrayGetCount(allPeople);
        
        [users1 removeAllObjects];
        [users3 removeAllObjects];
        for (int i=0; i<personCount; i++)
        {
            ABMultiValueRef tmp;
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            NSString *first = @"";
            tmp = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if (tmp != nil) first = [NSString stringWithFormat:@"%@", tmp];
            
            NSString *last = @"";
            tmp = ABRecordCopyValue(person, kABPersonLastNameProperty);
            if (tmp != nil) last = [NSString stringWithFormat:@"%@", tmp];
            
            NSMutableArray *emails = [[NSMutableArray alloc] init];
            ABMultiValueRef multi1 = ABRecordCopyValue(person, kABPersonEmailProperty);
            for (CFIndex j=0; j<ABMultiValueGetCount(multi1); j++)
            {
                tmp = ABMultiValueCopyValueAtIndex(multi1, j);
                if (tmp != nil) [emails addObject:[NSString stringWithFormat:@"%@", tmp]];
            }
            
            NSMutableArray *phones = [[NSMutableArray alloc] init];
            ABMultiValueRef multi2 = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (CFIndex j=0; j<ABMultiValueGetCount(multi2); j++)
            {
                tmp = ABMultiValueCopyValueAtIndex(multi2, j);
                if (tmp != nil) [phones addObject:[NSString stringWithFormat:@"%@", tmp]];
            }
            
            NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
            
            // Email จะเป็น array เพราะว่า 1 user สามารถมีได้หลาย Email
            
            //            NSLog(@"%@", [PFUser currentUser][PF_USER_EMAIL]);
            //            NSLog(@"%@", emails[0]);
            //
            //            if(![[PFUser currentUser][PF_USER_EMAIL] isEqualToString:emails]){
            //
            //            }
            
            NSLog(@"email : %@", emails);
            
            if ([emails count] > 0) {
                [users1 addObject:@{@"name":name, @"emails":emails, @"phones":phones}];
            }
            
            if ([phones count] > 0) {
                [users3 addObject:@{@"name":name, @"emails":emails, @"phones":phones}];
            }
        }
        CFRelease(allPeople);
        CFRelease(addressBook);
        // [self loadUsers];
        
        
        
        if (!sectionContentDict) {
            sectionContentDict  = [[NSMutableDictionary alloc] init];
            // NSArray *array1     = [NSArray arrayWithObjects:@"bla 1", @"bla 2", @"bla 3", @"bla 4", nil];
            [sectionContentDict setValue:users1 forKey:[sectionTitleArray objectAtIndex:0]];
            // NSArray *array2     = [NSArray arrayWithObjects:@"wurst 1", @"käse 2", @"keks 3", nil];
            [sectionContentDict setValue:users3 forKey:[sectionTitleArray objectAtIndex:1]];
        }

        
        [self._table reloadData];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadUsers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    for (NSDictionary *user in users1)
    {
        [emails addObjectsFromArray:user[@"emails"]];
    }
    
    NSLog(@"%@", emails);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    /*
     PFQuery *query1 = [PFQuery queryWithClassName:PF_BLOCKED_CLASS_NAME];
     [query1 whereKey:PF_BLOCKED_USER1 equalTo:[PFUser currentUser]];
     
     PFQuery *query2 = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
     [query2 whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentId]];
     [query2 whereKey:PF_USER_OBJECTID doesNotMatchKey:PF_BLOCKED_USERID2 inQuery:query1];
     [query2 whereKey:PF_USER_EMAILCOPY containedIn:emails];
     [query2 orderByAscending:PF_USER_FULLNAME_LOWER];
     [query2 setLimit:1000];
     [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
     if (error == nil)
     {
     [users2 removeAllObjects];
     for (PFUser *user in objects)
     {
     [users2 addObject:user];
     [self removeUser:user[PF_USER_EMAILCOPY]];
     }
     [self._table reloadData];
     }
     else {
     [ProgressHUD showError:@"Network error."];
     }
     
     self._table.hidden = NO;
     [self.spinner stopAnimating];
     [self.spinner removeFromSuperview];
     }];
     */
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
