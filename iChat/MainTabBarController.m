//
//  MainTabBarController.m
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "MainTabBarController.h"
#import "MXContacts.h"
#import "Tab_Contacts.h"
#import "Tab_iDNA.h"
#import "RecentViewController.h"
#import "Tab_Center.h"
#import "Tab_Settings.h"
#import "Tab_Home.h"
#import "Tab_Chats.h"
#import "MXiDNA.h"

@interface MainTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate, UITabBarControllerDelegate>{
    NSMutableArray *childObservers;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CONTACTS";
    
    // assert(false);
    
 
    
    childObservers = [[NSMutableArray alloc] init];
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    /*
    Tab_Home *tabBarHome =[storybrd instantiateViewControllerWithIdentifier:@"Tab_Home"];
    tabBarHome.title = @"Home";
    UINavigationController* homeNavController = [[UINavigationController alloc] initWithRootViewController:tabBarHome];
    homeNavController.navigationBar.topItem.title = @"Home";
    */
    
    MXContacts* tabBarMX =[storybrd instantiateViewControllerWithIdentifier:@"MXContacts"];
    tabBarMX.title = @"Mx-Contacts";
    UINavigationController* mxNavController = [[UINavigationController alloc] initWithRootViewController:tabBarMX];
    mxNavController.navigationBar.topItem.title = @"Mx-Contacts";
    
    
    Tab_Contacts *tabBarContacts =[storybrd instantiateViewControllerWithIdentifier:@"Tab_Contacts"];
    tabBarContacts.title = @"Contacts";
    UINavigationController* heartNavController = [[UINavigationController alloc] initWithRootViewController:tabBarContacts];
    heartNavController.navigationBar.topItem.title = @"Contacts";
    
    RecentViewController *tabBarRecent =[storybrd instantiateViewControllerWithIdentifier:@"RecentViewController"];
    tabBarRecent.title = @"Recent";
    UINavigationController* recentNavController = [[UINavigationController alloc] initWithRootViewController:tabBarRecent];
    recentNavController.navigationBar.topItem.title = @"Recent";
    
    // Tab_Chats
    /*
    Tab_Chats *tabBarChats =[storybrd instantiateViewControllerWithIdentifier:@"Tab_Chats"];
    tabBarChats.title = @"Chats";
    UINavigationController* chatsNavController = [[UINavigationController alloc] initWithRootViewController:tabBarChats];
    chatsNavController.navigationBar.topItem.title = @"Chats";
    */
    
    
    MXiDNA* tabBarMY =[storybrd instantiateViewControllerWithIdentifier:@"MXiDNA"];
    tabBarMY.title = @"Mx-iDNA";
    UINavigationController* myNavController = [[UINavigationController alloc] initWithRootViewController:tabBarMY];
    myNavController.navigationBar.topItem.title = @"Mx-iDNA";
    
    
    Tab_iDNA *tabBariDNA =[storybrd instantiateViewControllerWithIdentifier:@"Tab_iDNA"];
    tabBariDNA.title = @"iDNA";
    UINavigationController* iDNANavController = [[UINavigationController alloc] initWithRootViewController:tabBariDNA];
    iDNANavController.navigationBar.topItem.title = @"iDNA";
    
    
//    Tab_Center *tabBarCenter =[storybrd instantiateViewControllerWithIdentifier:@"Tab_Center"];
//    tabBarCenter.title = @"Center";
//    UINavigationController* centerNavController = [[UINavigationController alloc] initWithRootViewController:tabBarCenter];
//    centerNavController.navigationBar.topItem.title = @"Center";
    
    Tab_Settings *tabBarSettings =[storybrd instantiateViewControllerWithIdentifier:@"Tab_Settings"];
    tabBarSettings.title = @"Settings";
    UINavigationController* settingsNavController = [[UINavigationController alloc] initWithRootViewController:tabBarSettings];
    settingsNavController.navigationBar.topItem.title = @"Settings";
    
    NSArray *controllers = @[/*mxNavController,*/ heartNavController /*, recentNavController, chatsNavController /*, myNavController, /*/,iDNANavController ,settingsNavController];
    [self setViewControllers:controllers animated:YES];
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

@end
