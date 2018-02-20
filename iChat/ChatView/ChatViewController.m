//
//  DetailViewController.m
//  InputAccessoryExample
//
//  Created by Guilherme Moura on 10/7/14.
//  Copyright (c) 2014 Reefactor, Inc. All rights reserved.
//

#import "ChatViewController.h"

#import "SPHTextBubbleCell.h"
#import "SPHMediaBubbleCell.h"
#import "Constantvalues.h"
#import "SPH_PARAM_List.h"
#import "GroupChatRepo.h"
#import "GroupMembers.h"

@interface ChatViewController ()<TextCellDelegate,MediaCellDelegate>
{
    NSMutableArray *sphBubbledata;
    BOOL isfromMe;
}
@property NSMutableArray *objects;
@end

@implementation ChatViewController
@synthesize friend_id, type;

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = type;
    self.objects = [NSMutableArray arrayWithArray:@[@"Message 1", @"Message 2", @"Message 3", @"Message 4", @"Message 5", @"Message 6", @"Message 7", @"Message 8", @"Message 9", @"Message 10", @"Message 11", @"Message 12", @"Message 13"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GT_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GT_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.containerView.customInputView = self.customInputView;
    [self.containerView becomeFirstResponder];
    
    // เป็นคำสั่งเมือเริ่ม tableView cell จะอยู่ bottom
    // [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    // setContentOffset:CGPointZero animated:YES];
    // [self.tableView setContentOffset:CGPointZero animated:YES];
    
    isfromMe=YES;
    sphBubbledata =[[NSMutableArray alloc]init];
    
    [self SetupDummyMessages];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[type lowercaseString] isEqualToString:@"groups"]) {
        GroupChatRepo *groupChatRepo = [[GroupChatRepo alloc] init];
        NSMutableArray * fs = [groupChatRepo get:friend_id];
        
        NSData *data =  [[fs objectAtIndex:[groupChatRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        // NSData *data =  [[sortedValues objectAtIndex:indexPath.row] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *item = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary * member= [item objectForKey:@"members"];
        
        UIBarButtonItem *mm = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%d Member", [member count]] style:UIBarButtonItemStylePlain target:self action:@selector(memberFunction:)];
        self.navigationItem.rightBarButtonItem=mm;
    }else if ([[type lowercaseString] isEqualToString:@"center"]) {
        
    }
}

// กรณีเปิด จะมีการ hide Tabbar
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void) memberFunction:(id)sender{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMembers *mb = [storybrd instantiateViewControllerWithIdentifier:@"GroupMembers"];
    mb.group_id = friend_id;
    [self.navigationController pushViewController:mb animated:YES];
}

- (IBAction)sendButtonPressed:(id)sender
{
//    [self.objects addObject:self.inputTextField.text];
//    self.inputTextField.text = @"";
//    [self.tableView reloadData];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    if ([self.inputTextField.text length]>0) {
        
        if (isfromMe)
        {
            NSString *rowNum=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
            [self adddMediaBubbledata:kTextByme mediaPath:self.inputTextField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:[self genRandStringLength:7]];
            [self performSelector:@selector(messageSent:) withObject:rowNum afterDelay:1];
            
            isfromMe=NO;
        }
        else
        {
            [self adddMediaBubbledata:kTextByOther mediaPath:self.inputTextField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
            isfromMe=YES;
        }
        self.inputTextField.text=@"";
        [self.tableView reloadData];
        // [self scrollTableview];
    }
    [self scrollToLastCell];
}

- (IBAction)sendButtonCamera:(id)sender {
    NSLog(@"sendButtonCamera");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self
//               action:@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 50, 160.0, 40.0);
    
    [button setBackgroundColor:[UIColor blueColor]];
    
    // [view addSubview:button];
    
//    CGRect currentFrame = self.containerView.customInputView.frame;
//
//    currentFrame.size.height = currentFrame.size.height  + 100;
//
//    self.containerView.customInputView.frame = currentFrame;
    
    [self.containerView.customInputView addSubview:button];
    
    CGRect frame = self.containerView.frame;
    frame.size.height = self.containerView.bounds.size.height + 50;
    self.containerView.customInputView.bounds = frame;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=kSent;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
    
    // [self.chattable reloadData];
    
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:animationsEnabled];
    
}

#pragma mark - Notifications
- (void)GT_keyboardWillShow:(NSNotification *)notification
{
    [self GT_showKeyboardWithInfo:notification.userInfo];
    
    // [self scrollToLastCell];

}

- (void)GT_keyboardWillHide:(NSNotification *)notification
{
    [self GT_showKeyboardWithInfo:notification.userInfo];
}

- (void)GT_showKeyboardWithInfo:(NSDictionary *)info
{
    CGRect keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat targetBottomSpace = viewHeight - CGRectGetMinY(keyboardFrame);
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    contentInsets = UIEdgeInsetsMake(contentInsets.top, contentInsets.left, targetBottomSpace, contentInsets.right);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sphBubbledata.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kImagebyme]||[feed_data.chat_media_type isEqualToString:kImagebyOther]){
        return 180;
    }
    
    CGSize labelSize =[feed_data.chat_message boundingRectWithSize:CGSizeMake(226.0f, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                           context:nil].size;
    return labelSize.height + 30 + TOP_MARGIN + 20;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
//
//    cell.textLabel.text = self.objects[indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *L_CellIdentifier = @"SPHTextBubbleCell";
    static NSString *R_CellIdentifier = @"SPHMediaBubbleCell";
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kTextByme]||[feed_data.chat_media_type isEqualToString:kTextByOther])
    {
        SPHTextBubbleCell *cell = (SPHTextBubbleCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil)
        {
            cell = [[SPHTextBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        cell.bubbletype=([feed_data.chat_media_type isEqualToString:kTextByme])?@"LEFT":@"RIGHT";
        cell.textLabel.text = feed_data.chat_message;
        cell.textLabel.tag=indexPath.row;
        cell.timestampLabel.text = [self getCurrentTime]; //@"02:20 AM";
        cell.CustomDelegate=self;
        cell.AvatarImageView.image=([feed_data.chat_media_type isEqualToString:kTextByme])?[UIImage imageNamed:@"ProfilePic.png"]:[UIImage imageNamed:@"person.png"];
        
        return cell;
    }
    
    SPHMediaBubbleCell *cell = (SPHMediaBubbleCell *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
    if (cell == nil)
    {
        cell = [[SPHMediaBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
    }
    cell.bubbletype=([feed_data.chat_media_type isEqualToString:kImagebyme])?@"LEFT":@"RIGHT";
    cell.textLabel.text = feed_data.chat_message;
    cell.messageImageView.tag=indexPath.row;
    cell.CustomDelegate=self;
    cell.timestampLabel.text = [self getCurrentTime]; //@"02:20 AM";
    cell.AvatarImageView.image=([feed_data.chat_media_type isEqualToString:kImagebyme])?[UIImage imageNamed:@"ProfilePic.png"]:[UIImage imageNamed:@"person.png"];
    
    return cell;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@">>> View dealloc with success!");
}

-(void)scrollToLastCell{
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        // เป็นการให้ cell last อยู่ top keyboard
        // First figure out how many sections there are
        NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
        // Then grab the number of rows in the last section
        NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
        // Now just construct the index path
        NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
        
        // [self.tableView beginUpdates] ;//tableView.beginUpdates()
        
        
        
        // [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, TOP_MARGIN, 0)];
        
        [UIView animateWithDuration: 0.3
                         animations: ^{
//
                         }completion: ^(BOOL finished){
                             
                         }
         ];
    });
     */
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: sphBubbledata.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


//=========***************************************************=============
#pragma mark - CELL CLICKED  PROCEDURE
//=========***************************************************=============


-(void)textCellDidTapped:(SPHTextBubbleCell *)tesxtCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tesxtCell.textLabel.tag inSection:0];
    NSLog(@"Forward Pressed =%@ and IndexPath=%@",tesxtCell.textLabel.text,indexPath);
    [tesxtCell showMenu];
}
// 7684097905

-(void)cellCopyPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"copy Pressed =%@",tesxtCell.textLabel.text);
    
}

-(void)cellForwardPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Forward Pressed =%@",tesxtCell.textLabel.text);
    
}
-(void)cellDeletePressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Delete Pressed =%@",tesxtCell.textLabel.text);
    
}

//=========*******************  BELOW FUNCTIONS FOR IMAGE  **************************=============

-(void)mediaCellDidTapped:(SPHMediaBubbleCell *)mediaCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mediaCell.messageImageView.tag inSection:0];
    NSLog(@"Media cell Pressed  and IndexPath=%@",indexPath);
    
    [mediaCell showMenu];
}

-(void)mediaCellCopyPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"copy Pressed =%@",mediaCell.messageImageView.image);
    
}

-(void)mediaCellForwardPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Forward Pressed =%@",mediaCell.messageImageView.image);
    
}
-(void)mediaCellDeletePressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Delete Pressed =%@",mediaCell.messageImageView.image);
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark               KEYBOARD UPDOWN EVENT
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard
{
    // [myTextField isFirstResponder]
    if(![self.view isFirstResponder]){
        [self.view endEditing:YES];
    }
    //
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  GENERATE RANDOM ID to SAVE IN LOCAL
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString *) genRandStringLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark       SETUP DUMMY MESSAGE / REPLACE THEM IN LIVE
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)SetupDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    //  msg_ID  Any Random ID
    
    //  mediaPath  : Your Message  or  Path of the Image
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    //[self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];
    
    [self adddMediaBubbledata:kTextByOther mediaPath:@"Hello! How are you?" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"I'm doing Great!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyOther mediaPath:@"Yeah its cool!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"Supports Image too." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByOther mediaPath:@"Yup. I like the tail part of it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:@"ABFCXYZ"];
    
    [self adddMediaBubbledata:kImagebyOther mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    [self adddMediaBubbledata:kTextByme mediaPath:@"lets meet some time for dinner! hope you will like it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self.tableView reloadData];
}

-(NSString*)getCurrentTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm a"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    return newDateString;
}

@end
