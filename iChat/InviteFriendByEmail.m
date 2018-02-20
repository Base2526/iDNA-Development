//
//  InviteFriendByEmail.m
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "InviteFriendByEmail.h"

#import <AddressBook/AddressBook.h>

#import "ContactusCell.h"

#import "SVProgressHUD.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InviteFriendByEmail ()<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
    
    NSMutableArray *users1;
    NSMutableArray *users2;
    
    NSMutableArray *fieldSelected;
}

@end

@implementation InviteFriendByEmail{
    
    // NSArray *listItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fieldSelected = [[NSMutableArray alloc] init];
    
    
    // listItems = @[@"Cell", @"Cell", @"Cell", @"Cell"];
    
    [self._table registerNib:[UINib nibWithNibName:@"ContactusCell" bundle:nil] forCellReuseIdentifier:@"ContactusCell"];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    users1 = [[NSMutableArray alloc] init];
    users2 = [[NSMutableArray alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    [self allowAddressBook];
    
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

    ContactusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactusCell" forIndexPath:indexPath];
 
     //  cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
 
     // UILabel *labelName  = (UILabel *)[cell viewWithTag:11];
     // UILabel *labelEmail = (UILabel *)[cell viewWithTag:12];
     //    UILabel *labelPhone = (UILabel *)[cell viewWithTag:13];
    
    UILabel *labelName  = (UILabel *)cell.labelName;
    UILabel *labelEmail = (UILabel *)cell.labelEmail;
    // UIButton *btn       = (UIButton *)cell.btnInvite;
 
    NSDictionary *user = [users1 objectAtIndex:indexPath.row];
 
    NSLog(@"%@", [user valueForKey:@"emails"]);
 
    // [emails addObjectsFromArray:user[@"emails"]];
 
    [labelName setText:[user valueForKey:@"name"]];
    [labelEmail setText:[user valueForKey:@"emails"][0]];
    // [labelPhone setText:[user valueForKey:@"phones"][0]];
     
    // btn.tag = indexPath.row;
    // [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(byEmailTapped:)]];
    
    if ([fieldSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //the below code will allow multiple selection
    if ([fieldSelected containsObject:indexPath]){
        [fieldSelected removeObject:indexPath];
    }else{
        [fieldSelected addObject:indexPath];
    }
    [self reloadData];
}

-(void)byEmailTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);

    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Heart"];
        [mailCont setToRecipients:[NSArray arrayWithObject:[[users1 objectAtIndex:[(UIGestureRecognizer *)gestureRecognizer view].tag] valueForKey:@"emails"][0]]];
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

        }
        CFRelease(allPeople);
        CFRelease(addressBook);
        // [self loadUsers];
        
        for (int i=0; i<[users1 count]; i++) {
            [fieldSelected addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        
        [self reloadData];
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
}

- (IBAction)onSend:(id)sender {
    
    NSMutableArray* recipents = [[NSMutableArray alloc] init];
    for (id object in fieldSelected) {
        NSIndexPath* indexPath = object;
        [recipents addObject:[[users1 objectAtIndex:indexPath.row] valueForKey:@"emails"][0]];
    }

    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Heart"];
        [mailCont setToRecipients:recipents];
        [mailCont setMessageBody:@"Heart get this app and add me https://beta.itunes.apple.com/v1/app/1184807478" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
        
#define URLEMail @"mailto:info@satitpatumwan.ac.th?subject=subject&body=body"
        
        NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    }

}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadData
{
    [self._table reloadData];
}
@end




