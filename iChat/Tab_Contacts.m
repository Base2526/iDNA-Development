//
//  ContactsViewController.m
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.

#import "Tab_Contacts.h"
#import "ViewControllerCell.h"
#import "ViewControllerCellHeader.h"
#import "ProfileTableViewCell.h"
#import "FriendTableViewCell.h"
#import "GroupTableViewCell.h"
#import "CreateGroup.h"
#include <stdlib.h>
#import "Configs.h"
#import "AppConstant.h"
#import "AnNmousUThread.h"
#import "AppDelegate.h"
#import "UserDataUILongPressGestureRecognizer.h"
#import "UserDataUIAlertView.h"
#import "MyProfile.h"
#import "Changefriendsname.h"
#import "ManageGroup.h"
#import "FriendProfile.h"
#import "FriendProfileRepo.h"
#import "FriendProfileView.h"
#import "ChatWall.h"
#import "GroupChatRepo.h"
#import "GroupChat.h"
#import "Tab_Home.h"
#import "FriendsRepo.h"
#import "ProfilesRepo.h"
#import "AddFriend.h"
#import "ChatViewController.h"
#import "FriendRequestCell.h"
#import "FriendWaitForAFriendCell.h"
#import "CustomTapGestureRecognizer.h"
#import "YSLContainerViewController.h"

#import "Tab_Contacts_Friend.h"
#import "ListGroup.h"
#import "ListClasss.h"

@interface Tab_Contacts (){
    YSLContainerViewController *containerVC;
}

@end

@implementation Tab_Contacts

#pragma mark - View Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tab_Contacts_Friend *tabCF = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Contacts_Friend"];
    tabCF.title = @"Friends";
    
    
//    Tab_Contacts_GroupChat *tabCG = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Contacts_GroupChat"];
//    tabCG.title = @"Groups";
//
//    Tab_Contacts_Classs *tabCC = [storybrd instantiateViewControllerWithIdentifier:@"Tab_Contacts_Classs"];
//    tabCC.title = @"Classs";

    ListGroup* tabCG = [storybrd instantiateViewControllerWithIdentifier:@"ListGroup"];
    tabCG.title = @"Groups";
    
    ListClasss* tabCC = [storybrd instantiateViewControllerWithIdentifier:@"ListClasss"];
    tabCC.title = @"Classs";
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[tabCF, tabCG, tabCC]
                                                            topBarHeight:statusHeight + navigationHeight
                                                    parentViewController:self];
    containerVC.delegate = self;
    // containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    
    [self.view addSubview:containerVC.view];
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void) viewDidDisappear:(BOOL)animated{
    
}

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    NSMutableArray *items = [containerVC childControllers];
    
    NSObject *object = [items objectAtIndex:index];
    if ([object isKindOfClass:[Tab_Contacts_Friend class]]) {
        [((Tab_Contacts_Friend *)object) reloadData:nil];
    }else if([object isKindOfClass:[ListGroup class]]){
        [((ListGroup *)object) reloadData:nil];
    }else if([object isKindOfClass:[ListClasss class]]){
        [((ListClasss *)object) reloadData:nil];
    }
    
}

- (IBAction)onAddFriend:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriend* addFriend = [storybrd instantiateViewControllerWithIdentifier:@"AddFriend"];
    [self.navigationController pushViewController:addFriend animated:YES];
}
@end
